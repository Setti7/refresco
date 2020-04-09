import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:random_string/random_string.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/store.dart';

part 'gallon.g.dart';

@JsonSerializable(explicitToJson: true, nullable: false)
class Gallon {
  @JsonKey(name: 'objectId')
  final String id;
  final GallonType type;
  final int price;
  final String company;
  final Store store;

  const Gallon({
    this.id,
    this.type,
    this.price,
    this.company,
    this.store,
  });

  String get priceDecimals => (price / 100).toStringAsFixed(2).split('.').last;

  String get priceIntegers => (price / 100).toStringAsFixed(2).split('.').first;

  String get typeAsString => type == GallonType.l20 ? '20L' : '10L';

  factory Gallon.fromParse(ParseObject gallon) {
    if (gallon == null) return null;
    return Gallon(
      id: gallon.objectId,
      type: gallonTypeFromString(gallon.get<String>('type')),
      price: gallon.get<int>('price'),
      company: gallon.get<String>('company'),
      store: Store.fromParse(gallon.get<ParseObject>('store')),
    );
  }

  static ParseObject toParse(Gallon gallon) {
    return ParseObject('Store')
      ..objectId = gallon.id ?? randomAlphaNumeric(10)
      ..set('type', gallonTypeToString(gallon.type))
      ..set('price', gallon.price)
      ..set('company', gallon.company)
      ..set('store', Store.toParse(gallon.store));
  }

  factory Gallon.fromJson(Map<String, dynamic> json) => _$GallonFromJson(json);

  Map<String, dynamic> toJson() => _$GallonToJson(this);

  static GallonType gallonTypeFromString(String gallonType) {
    if (gallonType == 'l20') {
      return GallonType.l20;
    } else if (gallonType == 'l10') {
      return GallonType.l10;
    } else {
      return null;
    }
  }

  static String gallonTypeToString(GallonType gallonType) {
    if (gallonType == GallonType.l20) {
      return 'l20';
    } else if (gallonType == GallonType.l10) {
      return 'l10';
    } else {
      return null;
    }
  }
}
