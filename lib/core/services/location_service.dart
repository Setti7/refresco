import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_base/core/models/user_address.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  UserAddress currentAddress;

  Future<UserAddress> getCurrentAddress() async {
    if (currentAddress != null) return currentAddress;

    LocationData locationData = await location.getLocation();
    Coordinates coordinates =
        Coordinates(locationData.latitude, locationData.longitude);
    List<UserAddress> addresses =
        await findAddressesFromCoordinates(coordinates);

    currentAddress = addresses.first;
    return currentAddress;
  }

  Future<List<UserAddress>> findAddressesFromCoordinates(
      Coordinates coordinates) async {
    List<Address> addresses = await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .timeout(Duration(seconds: 2));

    List<UserAddress> userAddresses = addresses
        .map((Address address) => UserAddress.fromGeolocoderAddress(address))
        .toList();

    return userAddresses;
  }

  Future<List<UserAddress>> findAddressesFromQuery(String query) async {
    List<Address> addresses;

    try {
      addresses = await Geocoder.local
          .findAddressesFromQuery(query)
          .timeout(Duration(seconds: 2));
    } on PlatformException {
      addresses = [];
    }

    addresses = _filterValidAddresses(addresses);

    List<UserAddress> userAddresses = addresses
        .map((Address address) => UserAddress.fromGeolocoderAddress(address))
        .toList();

    return userAddresses;
  }

  List<Address> _filterValidAddresses(List<Address> addresses) {
    return addresses
        .where((Address address) => address.thoroughfare != null)
        .toList();
  }
}
