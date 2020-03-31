import 'package:flutter_base/core/models/store.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallon.g.dart';

enum GallonType { l20, l10 }

@JsonSerializable(nullable: false, explicitToJson: true)
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

  factory Gallon.fromJson(Map<String, dynamic> json) => _$GallonFromJson(json);

  Map<String, dynamic> toJson() => _$GallonToJson(this);
}
