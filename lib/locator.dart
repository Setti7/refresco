import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/core/services/database_service.dart';
import 'package:flutter_base/core/services/firebase/firebase_database_service.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/services/parse/parse_auth_service.dart';
import 'package:flutter_base/core/viewModels/address_model.dart';
import 'package:flutter_base/core/viewModels/buy_model.dart';
import 'package:flutter_base/core/viewModels/current_location_tile.dart';
import 'package:flutter_base/core/viewModels/location_search_model.dart';
import 'package:flutter_base/core/viewModels/login_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<AuthService>(() => ParseAuthService());
  locator
      .registerLazySingleton<DatabaseService>(() => FirebaseDatabaseService());
  locator.registerLazySingleton<LocationService>(() => LocationService());

  // Factories
  locator.registerFactory<LocationSearchModel>(() => LocationSearchModel());
  locator.registerFactory<CurrentLocationTileModel>(
      () => CurrentLocationTileModel());
  locator.registerFactory<AddressModel>(() => AddressModel());
  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<BuyModel>(() => BuyModel());
}
