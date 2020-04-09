import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/mockito.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/database/parse_database_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/sample_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'parse_testing_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, String>{});

  MockGraphQLClient mockClient;
  ParseDatabaseService dbService;

  setUp(() async {
    mockClient = MockGraphQLClient();
    setupLocator();
    locator.allowReassignment = true;
    locator.registerSingleton<GraphQLApi>(GraphQLApi(mockClient));

    dbService = ParseDatabaseService();
  });

  group('ParseDatabaseService getStores ', () {
    /// ParseDatabaseService getStores with no address should return a failed
    /// ServiceResponse, with an empty list of results, but with no message to
    /// show in the screen.
    test('getStores with null address', () async {
      final response = await dbService.getStores(null);

      // Should not hit the backend
      verifyNever(mockClient.query(any));
      expect(response.success, false);
      expect(response.errorMessage, null);
    });

    /// ParseDatabaseService getStores with no close-by stores should return
    /// a successful ServiceResponse, but with an empty list as results.
    test('getStores with no close stores', () async {
      final mockResponse = QueryResult(data: {
        'stores': {'edges': []}
      });

      when(mockClient.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      final response = await dbService
          .getStores(Address(coordinate: Coordinate(-22.013252, -47.91365)));

      verify(mockClient.query(any)).called(1);
      expect(response.results.isEmpty, true);
      expect(response.errorMessage, null);
      expect(response.success, true);
    });

    /// ParseDatabaseService getStores with no errors should return a successful
    /// ServiceResponse with a list of the close-by Stores.
    test('getStores with no errors', () async {
      final mockResponse = QueryResult(data: {
        'stores': {
          'edges': [
            {'node': SampleData.store1.toJson()},
            {'node': SampleData.store2.toJson()},
            {'node': SampleData.store3.toJson()},
          ]
        }
      });

      when(mockClient.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      final response = await dbService.getStores(
        Address(coordinate: Coordinate(-22.013252, -47.91365)),
      );

      verify(mockClient.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Store>>());
      expect(response.results.isEmpty, false);
      expect(response.results.length, 3);
      expect(response.errorMessage, null);
      expect(response.success, true);
    });

    /// ParseDatabaseService getStores with any error should return a failed
    /// ServiceResponse with empty list results.
    test('getStores with errors', () async {
      final mockResponse = QueryResult(
        data: null,
        exception:
            OperationException(graphqlErrors: [GraphQLError(raw: 'error')]),
      );

      when(mockClient.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      final response = await dbService.getStores(
        Address(coordinate: Coordinate(-22.013252, -47.91365)),
      );

      verify(mockClient.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Store>>());
      expect(response.results.isEmpty, true);
      expect(response.errorMessage, isNotNull);
      expect(response.success, false);
    });
  });

  group('ParseDatabaseService getGallons ', () {
    /// ParseDatabaseService getGallons with any error should return a failed
    /// ServiceResponse with empty list results.
    test('getGallons with error', () async {
      final mockResponse = QueryResult(
        data: null,
        exception:
            OperationException(graphqlErrors: [GraphQLError(raw: 'error')]),
      );

      when(mockClient.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      final response = await dbService.getGallons(
        SampleData.store1,
        GallonType.l10,
      );

      verify(mockClient.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Gallon>>());
      expect(response.results.isEmpty, true);
      expect(response.errorMessage, isNotNull);
      expect(response.success, false);
    });

    /// ParseDatabaseService getGallons with no errors should return a list of
    /// Gallons.
    test('getGallons with no errors', () async {
      final mockResponse = QueryResult(data: {
        'gallons': {
          'edges': [
            {'node': SampleData.l10gallon2.toJson()},
            {'node': SampleData.l20gallon1.toJson()},
            {'node': SampleData.l20gallon3.toJson()},
          ]
        }
      });

      when(mockClient.query(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      final response = await dbService.getGallons(
        SampleData.store1,
        GallonType.l10,
      );

      verify(mockClient.query(any)).called(1);
      expect(response.results, isInstanceOf<List<Gallon>>());
      expect(response.results.isEmpty, false);
      expect(response.errorMessage, null);
      expect(response.success, true);
    });
  });
}
