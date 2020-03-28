import 'dart:io';

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
import 'package:flutter_parse/flutter_parse.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // TODO: check timeout with fake service or ngrok
  final client = IOClient(
    HttpClient()..connectionTimeout = Duration(seconds: 5),
  );

  // Parse initialization
  Parse.initialize(
    ParseConfiguration(
      server: 'http://192.168.15.13:1337/parse',
      applicationId: '9UBUIZ0VeTdGe6YfwEg7KBbL8LSoM8ONAMQyLKzw',
      enableLogging: true,
      httpClient: client,
    ),
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
