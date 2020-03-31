import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';

class StoreModel extends BaseModel {
  Logger logger = getLogger('StoreModel');

  // Services
  DatabaseService dbService = locator<DatabaseService>();
  LocationService locationService = locator<LocationService>();

  // Controllers
  TabController tabController;

  String errorTitle;
  String errorMessage;
  List<Gallon> gallons = [];
  GallonType gallonType = GallonType.l20;

  Future<void> getGallons(Store store) async {
    setState(ViewState.busy);

    errorTitle = null;
    errorMessage = null;

    var response = await dbService.getGallons(store, gallonType);

    if (response.success) {
      gallons = response.results;
    } else {
      errorTitle = 'Opa :(';
      errorMessage = response.message;
    }

    setState(ViewState.idle);
  }

  void setGallonType(GallonType newGallonType) => gallonType = newGallonType;

  String getFormattedDistanceFromUser(
      Address userAddress, Address storeAddress) {
    var mDistance = locationService.getDistanceBetweenCoordinates(
      userAddress.coordinate,
      storeAddress.coordinate,
    );

    if (mDistance > 1000) {
      return '${(mDistance / 1000).toStringAsFixed(1)} km';
    } else {
      return '${mDistance.truncate()} m';
    }
  }
}