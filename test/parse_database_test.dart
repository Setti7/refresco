import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/database/parse_database_service.dart';
import 'package:refresco/utils/sample_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'parse_testing_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, String>{});

  MockParseApi mockApi;
  ParseDatabaseService dbService;

  setUp(() async {
    await setupParseInstance();

    mockApi = MockParseApi();
    dbService = ParseDatabaseService(api: mockApi);
  });

  group('ParseDatabaseService getStores ', () {
    /// ParseDatabaseService getStores with no address should return a failed
    /// ServiceResponse, with an empty list of results, but with no message to
    /// show in the screen.
    test('getStores with null address', () async {
      var response = await dbService.getStores(null);

      // Should not hit the backend
      verifyNever(mockApi.query(any));
      expect(response.success, false);
      expect(response.message, null);
    });

    /// ParseDatabaseService getStores with no close-by stores should return
    /// a successful ServiceResponse, but with an empty list as results.
    test('getStores with no close stores', () async {
      var mockResponse = buildSuccessResponseWithNoResults(
        ParseResponse(),
        1,
        'Successful request, but no results found',
      );

      when(mockApi.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      var response = await dbService
          .getStores(Address(coordinate: Coordinate(-22.013252, -47.91365)));

      verify(mockApi.query(any)).called(1);
      expect(response.results.isEmpty, true);
      expect(response.message, null);
      expect(response.success, true);
    });

    /// ParseDatabaseService getStores with no errors should return a successful
    /// ServiceResponse with a list of the close-by Stores.
    test('getStores with no errors', () async {
      var stores = [
        Store.toParse(SampleData.store1),
        Store.toParse(SampleData.store2),
      ];

      var mockResponse = ParseResponse()
        ..success = true
        ..statusCode = 200
        ..count = 2
        ..error = null
        ..results = stores;

      when(mockApi.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      var response = await dbService.getStores(
        Address(coordinate: Coordinate(-22.013252, -47.91365)),
      );

      verify(mockApi.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Store>>());
      expect(response.results.isEmpty, false);
      expect(response.message, null);
      expect(response.success, true);
    });
  });

  group('ParseDatabaseService getGallons ', () {
    /// ParseDatabaseService getGallons with any error should return a failed
    /// ServiceResponse with empty list results.
    test('getGallons with error', () async {
      var mockResponse = ParseResponse()
        ..success = false
        ..statusCode = -1
        ..count = 0
        ..error = ParseError(
          code: -1,
          message: 'Error',
        )
        ..results = null;

      when(mockApi.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      var response = await dbService.getGallons(
        SampleData.store1,
        GallonType.l10,
      );

      verify(mockApi.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Gallon>>());
      expect(response.results.isEmpty, true);
      expect(response.message, isNotNull);
      expect(response.success, false);
    });

    /// ParseDatabaseService getGallons with no errors should return a list of
    /// Gallons.
    test('getGallons with no errors', () async {
      var gallons = [
        Gallon.toParse(SampleData.l20gallon1),
        Gallon.toParse(SampleData.l10gallon1),
      ];

      var mockResponse = ParseResponse()
        ..success = true
        ..statusCode = 200
        ..count = 2
        ..error = null
        ..results = gallons;

      when(mockApi.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      var response = await dbService.getGallons(
        SampleData.store1,
        GallonType.l10,
      );

      verify(mockApi.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Gallon>>());
      expect(response.results.isEmpty, false);
      expect(response.message, null);
      expect(response.success, true);
    });
  });
}
