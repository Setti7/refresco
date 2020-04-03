import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';
import 'package:refresco/utils/routing_constants.dart';

class BuyModel extends BaseModel {
  Logger logger = getLogger('BuyModel');

  // Services
  AuthService authService = locator<AuthService>();
  DatabaseService dbService = locator<DatabaseService>();

  // Controllers
  RefreshController refreshController = RefreshController();

  List<Store> stores = [];
  String errorMessage;
  String errorTitle;

  BuyModel() {
    authService.user.listen((user) {
      logger.d('user changed: getting new stores');
      getStores(address: user.address);
    });
  }

  Future<void> getStores({
    @required Address address,
    bool force = false,
  }) async {
    if (!force) setState(ViewState.busy);

    errorTitle = null;
    errorMessage = null;

    var response = await dbService.getStores(address);

    if (response.success) {
      stores = response.results;
    } else {
      errorTitle = 'Opa :(';
      errorMessage = response.message;
    }

    setState(ViewState.idle);
  }

  Future<void> onRefresh({
    @required Address address,
  }) async {
    await getStores(
      address: address,
      force: true,
    );

    refreshController.refreshCompleted();
  }

  void logout() => authService.logout();

  void navigateToAddressView() => Get.toNamed(AddressViewRoute);
}
