import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart' as geo;
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/location/base_location_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class LocationService implements BaseLocationService {
  Logger _logger = getLogger('LocationService');
  Location _location = Location();
  Address _addressCache;
  AuthService authService = locator<AuthService>();
  BehaviorSubject<Address> _addressSubject = BehaviorSubject<Address>();
  Box _box;

  LocationService() {
    loadAddress();
  }

  @override
  Stream<Address> get address => _addressSubject.stream;

  @override
  Future<void> loadAddress() async {
    await _openAddressBox();
    final addressJson = Map<String, dynamic>.from(_box.get('address') ?? {});

    if (addressJson.isNotEmpty) {
      final _address = Address.fromJson(addressJson);
      updateAddress(_address);
      _logger.d('address loaded');
    }
  }

  @override
  void updateAddress(Address value) {
    _addressSubject.add(value);
    _saveAddress(value);
  }

  @override
  Address getAddress() {
    return _addressSubject.value;
  }

  @override
  Future<ServiceResponse> getUserAddressFromGPS() async {
    if (_addressCache != null) {
      return ServiceResponse(success: true, results: [_addressCache]);
    }

    final locationData = await _location.getLocation();
    final coordinates =
        geo.Coordinates(locationData.latitude, locationData.longitude);
    final addresses = await _findAddressesFromCoordinates(coordinates);

    _addressCache = addresses.first;
    return ServiceResponse(success: true, results: [_addressCache]);
  }

  @override
  Future<ServiceResponse> findAddressesFromQuery(String query) async {
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
      return ServiceResponse(success: false);
    }

    return ServiceResponse(success: true, results: addresses);
  }

  @override
  double getDistanceBetweenCoordinates(Coordinate c1, Coordinate c2) {
    return GreatCircleDistance.fromDegrees(
      latitude1: c1.latitude,
      longitude1: c1.longitude,
      latitude2: c2.latitude,
      longitude2: c2.longitude,
    ).haversineDistance();
  }

  Future<List<Address>> _findAddressesFromCoordinates(
      geo.Coordinates coordinates) async {
    final geoAddresses =
        await geo.Geocoder.local.findAddressesFromCoordinates(coordinates);

    final addresses = geoAddresses
        .map((address) => Address.fromGeocoderAddress(address))
        .toList();

    return addresses;
  }

  List<geo.Address> _filterValidAddresses(List<geo.Address> addresses) {
    return addresses
        .where((geo.Address address) =>
            address.thoroughfare != null && address.subAdminArea != null)
        .toList();
  }

  void _saveAddress(Address address) async {
    if (_box == null || !_box.isOpen) {
      await _openAddressBox();
    }

    await _box.put('address', address.toJson());
  }

  Future<void> _openAddressBox() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path + '/hive');

    _box = await Hive.openBox('addressBox');
  }
}
