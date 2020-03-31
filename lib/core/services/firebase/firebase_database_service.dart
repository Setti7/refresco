import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/core/services/database_service.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:logger/logger.dart';

class FirebaseDatabaseService implements DatabaseService{
  final Logger _logger = getLogger('DatabaseService');
  List<Store> _storesCache = [];

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

    /// TODO:
    ///  create cache service with attention to when parameters of the query change
//    if (_storesCache?.isNotEmpty == true && !force) {
//      return _storesCache;
//    }

    var snapshot = await Firestore.instance
        .collection('stores')
        .where('address.city', isEqualTo: address.city)
        .getDocuments()
        .timeout(Duration(seconds: 5));

    _storesCache = snapshot.documents.map((doc) {
      return Store.fromJson(doc.data);
    }).toList();

    return _storesCache;
  }
}
