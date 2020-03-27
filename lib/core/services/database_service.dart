import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/models/user_address.dart';

class DatabaseService {
  final Map<GallonType, List<Gallon>> _gallons = {};

  Future<List<Gallon>> getGallons({
    @required GallonType gallonType,
    @required UserAddress userAddress,
    bool force = false,
  }) async {
    if (_gallons[gallonType]?.isNotEmpty == true && !force) {
      return _gallons[gallonType];
    }

    var snapshot = await Firestore.instance
        .collection('gallons')
        .where('type', isEqualTo: gallonType == GallonType.l20 ? 'l20' : 'l10')
        .getDocuments()
        .timeout(Duration(seconds: 5));

    var gallons = snapshot.documents.map((DocumentSnapshot doc) {
      return Gallon.fromJson(doc.data);
    }).toList();

    _gallons[gallonType] = gallons;

    return _gallons[gallonType];
  }
}
