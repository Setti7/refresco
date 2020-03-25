import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/core/services/database_service.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/viewModels/address_model.dart';
import 'package:flutter_base/core/viewModels/buy_model.dart';
import 'package:flutter_base/core/viewModels/current_location_tile.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<LocationService>(() => LocationService());

  locator.registerLazySingleton<BuyModel>(() => BuyModel());
  locator.registerFactory<AddressModel>(() => AddressModel());
  locator.registerFactory<CurrentLocationTileModel>(() => CurrentLocationTileModel());
}
