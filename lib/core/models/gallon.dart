import 'package:json_annotation/json_annotation.dart';

part 'gallon.g.dart';

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

  factory Gallon.fromJson(Map<String, dynamic> json) => _$GallonFromJson(json);

  Map<String, dynamic> toJson() => _$GallonToJson(this);
}
