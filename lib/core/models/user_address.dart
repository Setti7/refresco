import 'package:geocoder/geocoder.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_address.g.dart';

@JsonSerializable(explicitToJson: true)
class UserAddress {
  final String streetName;
  final int number;
  final String city;
  final String state;
  final String district;
  final String complement;
  final String country;
  final String pointOfReference;
  final double latitude;
  final double longitude;
  final String completeAddress;
  final String postalCode;

  const UserAddress({
    this.streetName,
    this.number,
    this.city,
    this.state,
    this.district,
    this.complement,
    this.country,
    this.pointOfReference,
    this.latitude,
    this.longitude,
    this.completeAddress,
    this.postalCode,
  });

  factory UserAddress.copy(
    UserAddress address, {
    String streetName,
    int number,
    String city,
    String state,
    String district,
    String complement,
    String country,
    String pointOfReference,
    double latitude,
    double longitude,
    String completeAddress,
    String postalCode,
  }) {
    return UserAddress(
      streetName: streetName ?? address?.streetName,
      number: number ?? address?.number,
      city: city ?? address?.city,
      state: state ?? address?.state,
      district: district ?? address?.district,
      complement: complement ?? address?.complement,
      country: country ?? address?.country,
      pointOfReference: pointOfReference ?? address?.pointOfReference,
      latitude: latitude ?? address?.latitude,
      longitude: longitude ?? address?.longitude,
      completeAddress: completeAddress ?? address?.completeAddress,
      postalCode: postalCode ?? address?.postalCode,
    );
  }

  factory UserAddress.fromGeolocoderAddress(Address address) {
    return UserAddress(
      streetName: address.thoroughfare,
      city: address.subAdminArea,
      state: address.adminArea,
      district: address.subLocality,
      country: address.countryName,
      latitude: address.coordinates.latitude,
      longitude: address.coordinates.longitude,
      completeAddress: address.addressLine,
      postalCode: address.postalCode,
    );
  }

  String get districtAndCity {
    if (district == null) {
      return city ?? state;
    } else {
      return '$district - $city';
    }
  }

  String get streetAndNumber => '$streetName, $number';

  String get simpleAddress {
    String _numberOrCity;

    _numberOrCity =
        number != null ? ', $number' : city != null ? ' - $city' : '';

    return '$streetName$_numberOrCity';
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressToJson(this);
}
