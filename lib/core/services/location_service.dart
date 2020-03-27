import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/locator.dart';
import 'package:geocoder/geocoder.dart' as geo;
import 'package:location/location.dart';

class LocationService {
  AuthService authService = locator<AuthService>();

  Location location = Location();
  Address currentAddress;

  Future<Address> getCurrentAddress() async {
    if (currentAddress != null) return currentAddress;

    var locationData = await location.getLocation();
    var coordinates =
        geo.Coordinates(locationData.latitude, locationData.longitude);
    var addresses = await findAddressesFromCoordinates(coordinates);

    currentAddress = addresses.first;
    return currentAddress;
  }

  Future<List<Address>> findAddressesFromCoordinates(
      geo.Coordinates coordinates) async {
    var _addresses = await geo.Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .timeout(Duration(seconds: 2));

    var addresses = _addresses
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

    var newAddress = Address.copy(
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
}
