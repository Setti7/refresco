import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';
import 'package:refresco/core/services/database/parse_database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockQueryBuilder extends Mock implements QueryBuilder {}

class MockClient extends Mock implements ParseHTTPClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, String>{});

  group('ParseDatabaseService Test | ', () {
    setUpAll(() {});

    test(
        'getStores with null address should return response with no message and success=false',
        () async {
      var dbService = ParseDatabaseService();

      var response = await dbService.getStores(null);
      expect(response.success, false);
      expect(response.message, null);
    });

    test('getStores with error should return empty list', () async {
      var dbService = ParseDatabaseService();
      var mockQuery = MockQueryBuilder();

      await Parse().initialize('appid', 'serverUrl');

      var mockResponse = ParseResponse()
        ..success = true
        ..statusCode = 200
        ..results = null
        ..count = 0
        ..error = ParseError();

      when(mockQuery.query()).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      var response = await dbService
          .getStores(Address(coordinate: Coordinate(-22.013252, -47.91365)));

      expect(response.results.isEmpty, true);
      expect(response.message, 'Erro inesperado');
      expect(response.success, false);
    });
  });
}
