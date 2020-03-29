import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/store.dart';
import 'package:flutter_base/core/services/auth/auth_service.dart';
import 'package:flutter_base/core/services/database/database_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyModel extends BaseModel {
  Logger logger = getLogger('BuyModel');

  // Services
  AuthService authService = locator<AuthService>();
  DatabaseService dbService = locator<DatabaseService>();

  List<Store> stores = [];
  RefreshController refreshController = RefreshController();
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
}
