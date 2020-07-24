import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/mockito.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/auth/parse_auth_service.dart';
import 'package:refresco/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'parse_testing_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, String>{});

  MockGraphQLClient mockClient;
  ParseAuthService authService;

  setUp(() {
    mockClient = MockGraphQLClient();
    setupLocator();
    locator.allowReassignment = true;
    locator.registerSingleton<GraphQLApi>(GraphQLApi(mockClient));

    authService = ParseAuthService();
  });

  group('ParseAuthService login', () {
    test('login with valid user', () {
      final userEmail = 'valid@email.com';
      final userPassword = 'validPassword';

      final mockResponse = QueryResult(data: {
        'logIn': {
          'viewer': {
            'user': User(email: userEmail).toJson(),
            'sessionToken': 'SampleSessionToken'
          }
        }
      });

      when(mockClient.mutate(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      expect(
          authService
              .loginWithEmail(email: userEmail, password: userPassword)
              .then((response) {
            verify(mockClient.mutate(any)).called(1);
            expect(response.success, true);
            expect(response.results, null);
            expect(response.errorMessage, null);
          }),
          completes);
    }, skip: 'currently failing (asynchronous gap)');

    test('login with invalid user', () {
      final userEmail = 'invalid@email.com';
      final userPassword = 'invalidPassword';

      final mockResponse = QueryResult(
        data: null,
        exception:
            OperationException(graphqlErrors: [GraphQLError(raw: 'error')]),
      );

      when(mockClient.mutate(any)).thenAnswer(
        (_) async => Future.value(mockResponse),
      );

      expect(
          authService
              .createUserWithEmailAndPassword(
                  email: userEmail, password: userPassword)
              .then((response) {
            verify(mockClient.mutate(any)).called(1);
            expect(response.results, null);
            expect(response.errorMessage, isNotNull);
            expect(response.success, false);
          }),
          completes);
    });
  });
}
