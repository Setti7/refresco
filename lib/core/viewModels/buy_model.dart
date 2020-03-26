import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/core/services/database_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BuyModel extends BaseModel {
  AuthService authService = locator<AuthService>();
  DatabaseService dbService = locator<DatabaseService>();

  List<Gallon> gallons = [];
  TabController tabController;
  RefreshController refreshController = RefreshController();
  GallonType gallonType = GallonType.l20;
  String errorMessage;
  String errorTitle;

  BuyModel() {
    getGallons(gallonType);
  }

  Future<void> getGallons(GallonType gallonType, {bool force = false}) async {
    if (!force) setState(ViewState.busy);

    errorTitle = null;
    errorMessage = null;

    try {
      gallons = await dbService.getGallons(gallonType, force: force);
    } on TimeoutException {
      errorTitle = 'Erro de conexão :(';
      errorMessage = 'Verifique que você está conectado com a internet.';
    }

    setState(ViewState.idle);
  }

  Future<void> onRefresh(GallonType gallonType) async {
    await getGallons(gallonType, force: true);
    refreshController.refreshCompleted();
  }

  void setGallonType(GallonType newGallonType) {
    gallonType = newGallonType;
    getGallons(gallonType);
  }

  void logout() => authService.logout();
}
