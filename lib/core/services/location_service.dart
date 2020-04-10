import 'dart:async';

import 'package:flutter/services.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/locator.dart';
import 'package:geocoder/geocoder.dart' as geo;
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:location/location.dart';

class LocationService {
  AuthService authService = locator<AuthService>();

  Location location = Location();
  Address currentAddress;

  Future<Address> getCurrentAddress() async {
    if (currentAddress != null) return currentAddress;

    final locationData = await location.getLocation();
    final coordinates =
        geo.Coordinates(locationData.latitude, locationData.longitude);
    final addresses = await findAddressesFromCoordinates(coordinates);

    currentAddress = addresses.first;
    return currentAddress;
  }

  Future<List<Address>> findAddressesFromCoordinates(
      geo.Coordinates coordinates) async {
    final _addresses = await geo.Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .timeout(Duration(seconds: 2));

    final addresses = _addresses
        .map((address) => Address.fromGeocoderAddress(address))
        .toList();

    return addresses;
  }

  Future<List<Address>> findAddressesFromQuery(String query) async {
    List<Address> addresses;

    try {
      var _addresses = await geo.Geocoder.local
          .findAddressesFromQuery(query)
          .timeout(Duration(seconds: 2));

      _addresses = _filterValidAddresses(_addresses);

      addresses = _addresses
          .map((address) => Address.fromGeocoderAddress(address))
          .toList();
    } on PlatformException {
      addresses = [];
    }

    return addresses;
  }

  void updateUserAddress(Address selectedAddress,
      {int number, String complement, String pointOfReference}) {
    var user = authService.getUser();

    final newAddress = Address.copy(
      selectedAddress,
      number: number,
      complement: complement,
      pointOfReference: pointOfReference,
    );

    user = User.newAddress(user, newAddress);

    authService.updateUser(user, force: true);
  }

  List<geo.Address> _filterValidAddresses(List<geo.Address> addresses) {
    return addresses
        .where((geo.Address address) =>
            address.thoroughfare != null && address.subAdminArea != null)
        .toList();
  }

  double getDistanceBetweenCoordinates(
      Coordinate coordinate1, Coordinate coordinate2) {
    return GreatCircleDistance.fromDegrees(
      latitude1: coordinate1.latitude,
      longitude1: coordinate1.longitude,
      latitude2: coordinate2.latitude,
      longitude2: coordinate2.longitude,
    ).haversineDistance();
  }
}
