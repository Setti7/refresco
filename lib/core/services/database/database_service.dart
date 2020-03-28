import 'package:flutter/foundation.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/store.dart';

abstract class DatabaseService {

  /// Get all stores based on user address.
  ///
  /// If [address] is [Null], throws  a [NullThrownError].
  ///
  /// If there are no stores near the user, return an empty [List].
  ///
  /// Should NEVER return [Null].
  Future<List<Store>> getStores({
    @required GallonType gallonType,
    @required Address address,
    bool force = false,
  });
}
