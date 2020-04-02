import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:refresco/core/dataModels/alert/alert_request.dart';
import 'package:refresco/core/dataModels/alert/alert_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/cart/cart_service.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/core/services/dialog/dialog_service.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StoreModel extends BaseModel {
  Logger logger = getLogger('StoreModel');

  // Services
  DatabaseService dbService = locator<DatabaseService>();
  LocationService locationService = locator<LocationService>();
  CartService cartService = locator<CartService>();
  DialogService dialogService = locator<DialogService>();

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

  void addToCart(Gallon gallon) async {
    var success = cartService.addToCart(gallon);

    if (!success) {
      var dialogResult = await dialogService.showDialog(
        AlertRequest(
          title: 'Seu carrinho já tem produtos de outra loja',
          description:
              'Caso queira comprar os produtos dessa loja, limpe antes o seu carrinho.',
          cancelButtonTitle: 'Voltar',
          buttonTitle: 'Limpar',
          type: AlertType.warning,
        ),
      );
      if (dialogResult.confirmed) {
        /// TODO: remove all items from cart
        /// TODO: ask why it is better to have a dialog service than to simply
        /// pass the context to a viewModel function and call the dialog from
        /// there
      }
    }
  }

  Future<bool> assessPop() async {
    if (dialogService.dialogIsShown) {
      dialogService.closeDialog(AlertResponse(confirmed: false));
    } else {
      return true;
    }
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
