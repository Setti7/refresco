import 'package:json_annotation/json_annotation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

part 'generated/gallon.g.dart';

enum GallonType { l20, l10 }

@JsonSerializable(explicitToJson: true, nullable: false)
class Gallon {
  final GallonType type;
  final double price;
  final String company;

  const Gallon({
    this.type,
    this.price,
    this.company,
  });

  int get priceDecimals => (price.remainder(1) * 100).round();

  int get priceIntegers => price.truncate();

  factory Gallon.fromParse(ParseObject parseObject) {
    return Gallon(
      type: _gallonTypeFromString(parseObject.get<String>('type')),
      price: parseObject.get<num>('price').toDouble(),
      company: parseObject.get<String>('company'),
    );
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
}
