import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/core/services/database/database_service.dart';
import 'package:flutter_base/core/services/service_response.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:logger/logger.dart';

class FirebaseDatabaseService implements DatabaseService {
  final Logger _logger = getLogger('FirebaseDatabaseService');

  /// Firebase doesn't have an easy to implement GeoQuery, so we query the
  /// stores by the same city as the user. This is bad, and should be fixed in
  /// the future with the GeoFlutterFire package.
  @override
  Future<ServiceResponse> getStores({
    @required GallonType gallonType,
    @required Address address,
  }) async {
    if (address == null) {
      _logger.w('failed to get stores: address is null');
      return ServiceResponse(success: false);
    }

    QuerySnapshot snapshot;

    try {
      snapshot = await Firestore.instance
          .collection('stores')
          .where('address.city', isEqualTo: address.city)
          .getDocuments()
          .timeout(Duration(seconds: 5));

      var stores = snapshot.documents.map((doc) {
        return Store.fromJson(doc.data);
      }).toList();

      return ServiceResponse(success: true, results: stores);
    } on PlatformException catch (e) {
      return ServiceResponse.fromFirebaseError(e.code);
    } on TimeoutException {
      return ServiceResponse(
          success: false, message: 'O servidor demorou muito para responder.');
    }
  }

  @override
  Future<ServiceResponse> getGallons(Store store) {
    // TODO: implement getGallons
    throw UnimplementedError();
  }
}
