import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  Address currentAddress;

  Future<Coordinates> getCurrentCoordinates() async {
    LocationData locationData = await location.getLocation();
    return Coordinates(locationData.latitude, locationData.longitude);
  }

  Future<Address> getCurrentAddress() async {
    if (currentAddress != null) return currentAddress;

    Coordinates coordinates = await getCurrentCoordinates();
    List<Address> addresses = await findAddressesFromCoordinates(coordinates);

    currentAddress = addresses.first;
    return currentAddress;
  }

  Future<List<Address>> findAddressesFromCoordinates(
      Coordinates coordinates) async {
    return await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .timeout(Duration(seconds: 2));
  }

  Future<List<Address>> findAddressesFromQuery(String query) async {
    List<Address> addresses;

    try {
      addresses = await Geocoder.local
          .findAddressesFromQuery(query)
          .timeout(Duration(seconds: 2));
    } on PlatformException {
      addresses = [];
    }

    return addresses;
  }
}
