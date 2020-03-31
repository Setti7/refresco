import 'package:flutter_base/core/services/auth/auth_service.dart';
import 'package:flutter_base/core/services/auth/firebase_auth_service.dart';
import 'package:flutter_base/core/services/database/database_service.dart';
import 'package:flutter_base/core/services/database/parse_database_service.dart';
import 'package:flutter_base/core/services/location/location_service.dart';
import 'package:flutter_base/core/viewModels/address_model.dart';
import 'package:flutter_base/core/viewModels/buy_model.dart';
import 'package:flutter_base/core/viewModels/current_location_tile.dart';
import 'package:flutter_base/core/viewModels/location_search_model.dart';
import 'package:flutter_base/core/viewModels/login_model.dart';
import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Parse initialization
  Parse().initialize(
    '9UBUIZ0VeTdGe6YfwEg7KBbL8LSoM8ONAMQyLKzw',
    'http://192.168.15.13:1337/parse',
  );

  // Services
  locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<DatabaseService>(() => ParseDatabaseService());
  locator.registerLazySingleton<LocationService>(() => LocationService());

  // Factories
  locator.registerFactory<LocationSearchModel>(() => LocationSearchModel());
  locator.registerFactory<CurrentLocationTileModel>(
      () => CurrentLocationTileModel());
  locator.registerFactory<AddressModel>(() => AddressModel());
  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<BuyModel>(() => BuyModel());
}
