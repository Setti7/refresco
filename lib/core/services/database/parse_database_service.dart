import 'package:flutter/foundation.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/core/services/database/database_service.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:logger/logger.dart';

class ParseDatabaseService implements DatabaseService {
  final Logger _logger = getLogger('ParseDatabaseService');

  @override
  Future<List<Store>> getStores({
    @required GallonType gallonType,
    @required Address address,
    bool force = false,
  }) async {
    if (address == null) {
      _logger.w('failed to get stores: address is null');
      throw NullThrownError();
    }

    var addressQuery = ParseQuery(className: 'Address')
      ..whereNear(
        'coordinate',
        ParseGeoPoint(
          latitude: address.coordinate.latitude,
          longitude: address.coordinate.longitude,
        ),
      )
      ..maxDistanceInKilometers('coordinate', 10);

    var storeQuery = ParseQuery(className: 'Store')
      ..whereExists('address')
      ..whereMatchesQuery('address', addressQuery)
      ..include('address');

    var storesJson = await storeQuery.findAsync();

    List<Store> stores = storesJson.map((store) {
      return Store.fromParse(store);
    }).toList();

    return stores;
  }
}
