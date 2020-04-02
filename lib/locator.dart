import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/auth/parse_auth_service.dart';
import 'package:refresco/core/services/cart/cart_service.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/core/services/database/parse_database_service.dart';
import 'package:refresco/core/services/dialog/dialog_service.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/views/address_model.dart';
import 'package:refresco/core/viewModels/views/buy_model.dart';
import 'package:refresco/core/viewModels/views/location_search_model.dart';
import 'package:refresco/core/viewModels/views/login_model.dart';
import 'package:refresco/core/viewModels/views/store_model.dart';
import 'package:refresco/core/viewModels/widgets/cart_sheet_model.dart';
import 'package:refresco/core/viewModels/widgets/current_location_tile.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Parse initialization
  Parse().initialize(
    '9UBUIZ0VeTdGe6YfwEg7KBbL8LSoM8ONAMQyLKzw',
    'http://192.168.15.10:1337/parse',
    autoSendSessionId: true,
    debug: true,
  );

  // Services
  locator.registerLazySingleton<AuthService>(() => ParseAuthService());
  locator.registerLazySingleton<DatabaseService>(() => ParseDatabaseService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<CartService>(() => CartService());
  locator.registerLazySingleton<DialogService>(() => DialogService());

  // View model factories
  locator.registerFactory<LocationSearchModel>(() => LocationSearchModel());
  locator.registerFactory<AddressModel>(() => AddressModel());
  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<BuyModel>(() => BuyModel());
  locator.registerFactory<StoreModel>(() => StoreModel());

  // Widgets model factories
  locator.registerFactory<CartSheetModel>(() => CartSheetModel());
  locator.registerFactory<CurrentLocationTileModel>(
      () => CurrentLocationTileModel());
}
