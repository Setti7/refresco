import 'package:mockito/mockito.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:refresco/core/services/api/parse_api.dart';

class MockParseApi extends Mock implements ParseApi {}

Future<void> setupParseInstance() async {
  await Parse().initialize(
    'appId',
    'serverUrl',
    autoSendSessionId: true,
    debug: true,
  );
}
