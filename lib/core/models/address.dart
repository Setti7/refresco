import 'package:geocoder/geocoder.dart' as geocoder;
import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:random_string/random_string.dart';
import 'package:refresco/core/models/coordinate.dart';

part 'generated/address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  final String id;
  final String streetName;
  final int number;
  final String city;
  final String state;
  final String district;
  final String complement;
  final String country;
  final String pointOfReference;
  final Coordinate coordinate;
  final String postalCode;

  const Address({
    this.id,
    this.streetName,
    this.number,
    this.city,
    this.state,
    this.district,
    this.complement,
    this.country,
    this.pointOfReference,
    this.coordinate,
    this.postalCode,
  });

  factory Address.copy(
    Address address, {
    String id,
    String streetName,
    int number,
    String city,
    String state,
    String district,
    String complement,
    String country,
    String pointOfReference,
    Coordinate coordinate,
    String postalCode,
  }) {
    return Address(
      id: id ?? address?.id,
      streetName: streetName ?? address?.streetName,
      number: number ?? address?.number,
      city: city ?? address?.city,
      state: state ?? address?.state,
      district: district ?? address?.district,
      complement: complement ?? address?.complement,
      country: country ?? address?.country,
      pointOfReference: pointOfReference ?? address?.pointOfReference,
      coordinate: coordinate ?? address?.coordinate,
      postalCode: postalCode ?? address?.postalCode,
    );
  }

  factory Address.fromGeocoderAddress(geocoder.Address address) {
    return Address(
      streetName: address.thoroughfare,
      city: address.subAdminArea,
      state: address.adminArea,
      district: address.subLocality,
      country: address.countryName,
      coordinate: Coordinate(
        address.coordinates.latitude,
        address.coordinates.longitude,
      ),
      postalCode: address.postalCode,
    );
  }

  factory Address.fromParse(ParseObject address) {
    return Address(
      id: address.objectId,
      streetName: address.get<String>('streetName'),
      number: address.get<int>('number'),
      city: address.get<String>('city'),
      state: address.get<String>('state'),
      district: address.get<String>('district'),
      complement: address.get<String>('complement'),
      country: address.get<String>('country'),
      pointOfReference: address.get<String>('pointOfReference'),
      coordinate:
          Coordinate.fromParse(address.get<ParseGeoPoint>('coordinate')),
      postalCode: address.get<String>('postalCode'),
    );
  }

  static ParseObject toParse(Address address) {
    return ParseObject('Store')
      ..objectId = address.id ?? randomAlphaNumeric(10)
      ..set('coordinate', Coordinate.toParse(address.coordinate))
      ..set('streetName', address.streetName)
      ..set('number', address.number)
      ..set('city', address.city)
      ..set('state', address.state)
      ..set('district', address.district)
      ..set('country', address.country)
      ..set('postalCode', address.postalCode);
  }

  String get districtAndCity {
    if (district == null) {
      return city;
    } else {
      return '$district - $city';
    }
  }

  String get streetAndNumber => '$streetName, $number';

  String get simpleAddress {
    var _numberOrCity =
        number != null ? ', $number' : city != null ? ' - $city' : '';

    return '$streetName$_numberOrCity';
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
