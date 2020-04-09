import 'package:logger/logger.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/utils/logger.dart';

class ParseDatabaseService implements DatabaseService {
  final Logger _logger = getLogger('ParseDatabaseService');
  GraphQLApi api = GraphQLApi();

  ParseDatabaseService({this.api}) {
    api ??= GraphQLApi();
  }

  @override
  Future<ServiceResponse> getStores(Address address) async {
    if (address == null) {
      _logger.w('failed to get stores: address is null');
      return ServiceResponse(success: false);
    }

    return await api.getCloseStores(address);
  }

  @override
  Future<ServiceResponse> getGallons(Store store, GallonType gallonType) {
    return api.getStoreGallons(store, gallonType);
  }
}
