import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:random_string/random_string.dart';

part 'generated/gallon.g.dart';

enum GallonType { l20, l10 }

@JsonSerializable(explicitToJson: true, nullable: false)
class Gallon {
  final String id;
  final GallonType type;
  final double price;
  final String company;

  const Gallon({
    this.id,
    this.type,
    this.price,
    this.company,
  });

  int get priceDecimals => (price.remainder(1) * 100).round();

  int get priceIntegers => price.truncate();

  factory Gallon.fromParse(ParseObject parseObject) {
    return Gallon(
      id: parseObject.objectId,
      type: _gallonTypeFromString(parseObject.get<String>('type')),
      price: parseObject.get<num>('price').toDouble(),
      company: parseObject.get<String>('company'),
    );
  }

  static ParseObject toParse(Gallon gallon) {
    return ParseObject('Store')
      ..objectId = gallon.id ?? randomAlphaNumeric(10)
      ..set('type', _gallonTypeToString(gallon.type))
      ..set('price', gallon.price)
      ..set('company', gallon.company);
  }

  factory Gallon.fromJson(Map<String, dynamic> json) => _$GallonFromJson(json);

  Map<String, dynamic> toJson() => _$GallonToJson(this);

  static GallonType _gallonTypeFromString(String gallonType) {
    if (gallonType == 'l20') {
      return GallonType.l20;
    } else if (gallonType == 'l10') {
      return GallonType.l10;
    } else {
      return null;
    }
  }

  static String _gallonTypeToString(GallonType gallonType) {
    if (gallonType == GallonType.l20) {
      return 'l20';
    } else if (gallonType == GallonType.l10) {
      return 'l10';
    } else {
      return null;
    }
  }
}
