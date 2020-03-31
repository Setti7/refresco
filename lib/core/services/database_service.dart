import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_base/core/models/gallon.dart';

class DatabaseService {
  Map<GallonType, List<Gallon>> _gallons = {};

  Future<List<Gallon>> getGallons(GallonType gallonType, {bool force = false}) async {
    if (_gallons[gallonType]?.isNotEmpty == true && !force) return _gallons[gallonType];

    QuerySnapshot snapshot = await Firestore.instance
        .collection('gallons')
        .where('type', isEqualTo: gallonType == GallonType.l20 ? 'l20' : 'l10')
        .getDocuments().timeout(Duration(seconds: 5));

    List<Gallon> gallons = snapshot.documents.map((DocumentSnapshot doc) {
      return Gallon.fromJson(doc.data);
    }).toList();

    _gallons[gallonType] = gallons;

    return _gallons[gallonType];
  }
}
