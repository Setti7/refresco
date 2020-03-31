import 'package:flutter/foundation.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/services/service_response.dart';

abstract class DatabaseService {
  /// Get all stores based on user address.
  ///
  /// If [address] is [Null], returns a [ServiceResponse] with success set to
  /// false and no message.
  ///
  /// If there are no stores near the user, return an empty [List], otherwise
  /// the list is populated with [Store] objects.
  Future<ServiceResponse> getStores({
    @required GallonType gallonType,
    @required Address address,
  });
}
