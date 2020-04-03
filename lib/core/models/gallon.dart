import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:random_string/random_string.dart';
import 'package:refresco/core/models/store.dart';

part 'generated/gallon.g.dart';

enum GallonType { l20, l10 }

@JsonSerializable(explicitToJson: true, nullable: false)
class Gallon {
  final String id;
  final GallonType type;
  final double price;
  final String company;
  final Store store;

  const Gallon({
    this.id,
    this.type,
    this.price,
    this.company,
    this.store,
  });

  int get priceDecimals => (price.remainder(1) * 100).round();

  int get priceIntegers => price.truncate();

  String get typeAsString => type == GallonType.l20 ? '20L' : '10L';

  factory Gallon.fromParse(ParseObject gallon) {
    if (gallon == null) return null;
    return Gallon(
      id: gallon.objectId,
      type: gallonTypeFromString(gallon.get<String>('type')),
      price: gallon.get<num>('price').toDouble(),
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
