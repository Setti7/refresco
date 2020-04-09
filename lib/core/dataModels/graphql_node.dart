import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';

class GraphQLNode {
  static T parse<T>(Map<String, dynamic> jsonObject) {
    switch (T) {
      case Store:
        return Store.fromJson(jsonObject) as T;
      case Address:
        return Address.fromJson(jsonObject) as T;
      case Coordinate:
        return Coordinate.fromJson(jsonObject) as T;
      case Gallon:
        return Gallon.fromJson(jsonObject) as T;
      case User:
        return User.fromJson(jsonObject) as T;
      default:
        return null;
    }
  }
}
