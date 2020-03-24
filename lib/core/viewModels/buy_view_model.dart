import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/core/services/database_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum ViewStatus { loading, completed, error }

class BuyViewModel extends ChangeNotifier {
  final AuthService authService;
  final DatabaseService dbService;
  List<Gallon> _gallons = [];
  ViewStatus _status = ViewStatus.loading;
  TabController tabController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GallonType _currentGallonType = GallonType.l20;

  BuyViewModel({@required this.authService, @required this.dbService}) {
    getGallons();
  }

  void setStatus(ViewStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  Future<void> getGallons({bool force = false}) async {
    if (!force) setStatus(ViewStatus.loading);
    _gallons = await dbService.getGallons(_currentGallonType, force: force);
    setStatus(ViewStatus.completed);
  }

  Future<void> onRefresh(GallonType gallonType) async {
    await getGallons(force: true);
    _refreshController.refreshCompleted();
  }

  List<Gallon> get gallons => _gallons;

  ViewStatus get status => _status;

  void setGallonType(GallonType gallonType) {
    _currentGallonType = gallonType;
    getGallons();
  }

  RefreshController get refreshController => _refreshController;
}
