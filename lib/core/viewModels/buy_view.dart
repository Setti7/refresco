import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/gallon.dart';
import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/core/services/database_service.dart';

enum ViewStatus { loading, completed, error }

class BuyViewModel extends ChangeNotifier {
  final AuthService authService;
  final DatabaseService dbService;
  List<Gallon> _gallons = [];
  ViewStatus _status = ViewStatus.loading;
  TabController tabController;

  BuyViewModel({@required this.authService, @required this.dbService}) {
    getGallons(GallonType.l20);
  }

  void setStatus(ViewStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void getGallons(GallonType gallonType) async {
    setStatus(ViewStatus.loading);
    _gallons = await dbService.getGallons(gallonType);
    setStatus(ViewStatus.completed);
  }

  List<Gallon> get gallons => _gallons;

  ViewStatus get status => _status;
}
