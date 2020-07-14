import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refresco/locator.dart';

import 'api/graphql_api.dart';

class LocalStorageService {
  GraphQLApi api = locator<GraphQLApi>();
  Box data;

  /// Load data from disk and fetches the user.
  /// Should be used on startup and when needed to refresh.
  Future<void> loadData() async {
    final dir = await getApplicationDocumentsDirectory();

    await Hive.init('${dir.path}/hive');
    data = await Hive.openBox('local_storage');

    await api.init(data);
  }
}
