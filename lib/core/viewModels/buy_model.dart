import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/models/gallon.dart';
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
  TabController tabController;
  RefreshController refreshController = RefreshController();
  GallonType gallonType = GallonType.l20;
  String errorMessage;
  String errorTitle;

  BuyModel() {
    authService.user.listen((user) {
      logger.d('user changed: getting new stores');
      getStores(address: user.address);
    });
  }

  // TODO: when chaging addresses, the store list does not update
  Future<void> getStores({
    @required Address address,
    bool force = false,
  }) async {
    if (!force) setState(ViewState.busy);

    errorTitle = null;
    errorMessage = null;

    try {
      stores = await dbService.getStores(
        address: address,
        gallonType: gallonType,
        force: force,
      );
    } on TimeoutException {
      errorTitle = 'Erro de conexão :(';
      errorMessage = 'Verifique que você está conectado com a internet.';
    } on NullThrownError {
      errorTitle = 'Escolha um endereço de entrega';
      errorMessage = 'Pra gente encontrar as lojas mais pertinhas :)';
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

  void setGallonType(GallonType newGallonType) => gallonType = newGallonType;

  void logout() => authService.logout();
}
