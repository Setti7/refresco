import 'package:get_it/get_it.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/auth/parse_auth_service.dart';
import 'package:refresco/core/services/cart_service.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/core/services/database/parse_database_service.dart';
import 'package:refresco/core/services/local_storage_service.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/services/order/order_service.dart';
import 'package:refresco/core/services/order/parse_order_service.dart';
import 'package:refresco/core/viewModels/views/address_model.dart';
import 'package:refresco/core/viewModels/views/buy_model.dart';
import 'package:refresco/core/viewModels/views/finish_registration_model.dart';
import 'package:refresco/core/viewModels/views/location_search_model.dart';
import 'package:refresco/core/viewModels/views/login_model.dart';
import 'package:refresco/core/viewModels/views/payment_method_model.dart';
import 'package:refresco/core/viewModels/views/store_model.dart';
import 'package:refresco/core/viewModels/widgets/cart_sheet_model.dart';
import 'package:refresco/core/viewModels/widgets/change_bottom_sheet_model.dart';
import 'package:refresco/core/viewModels/widgets/current_location_tile_model.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton<AuthService>(() => ParseAuthService());
  locator.registerLazySingleton<DatabaseService>(() => ParseDatabaseService());
  locator.registerLazySingleton<OrderService>(() => ParseOrderService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<CartService>(() => CartService());
  locator.registerLazySingleton<GraphQLApi>(() => GraphQLApi());
  locator.registerLazySingleton<LocalStorageService>(() => LocalStorageService());

  // View model factories
  locator.registerFactory<LocationSearchModel>(() => LocationSearchModel());
  locator.registerFactory<AddressModel>(() => AddressModel());
  locator.registerFactory<LoginModel>(() => LoginModel());
  locator.registerFactory<BuyModel>(() => BuyModel());
  locator.registerFactory<StoreModel>(() => StoreModel());
  locator.registerFactory<PaymentMethodModel>(() => PaymentMethodModel());
  locator
      .registerFactory<ChangeBottomSheetModel>(() => ChangeBottomSheetModel());

  // Widgets model factories
  locator.registerFactory<CartSheetModel>(() => CartSheetModel());
  locator.registerFactory<CurrentLocationTileModel>(
      () => CurrentLocationTileModel());
  locator.registerFactory<FinishRegistrationModel>(
      () => FinishRegistrationModel());
}
