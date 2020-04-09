import 'package:graphql/client.dart';
import 'package:logger/logger.dart';
import 'package:refresco/core/dataModels/graphql_node.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/api/queries/get_close_stores.dart';
import 'package:refresco/core/services/api/queries/get_store_gallons.dart';
import 'package:refresco/core/services/database/database_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';

class ParseDatabaseService implements DatabaseService {
  final Logger _logger = getLogger('ParseDatabaseService');
  GraphQLApi api = locator<GraphQLApi>();

  @override
  Future<ServiceResponse> getStores(Address address) async {
    if (address == null) {
      _logger.w('failed to get stores: address is null');
      return ServiceResponse(success: false);
    }

    final response = await api.query(
      QueryOptions(
        documentNode: gql(GetCloseStoresQuery.query),
        variables: {
          'latitude': address.coordinate.latitude,
          'longitude': address.coordinate.longitude,
        },
      ),
    );

    var stores = <Store>[];

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
        results: stores
      );
    }

    stores = (response.data['stores']['edges'] as List<dynamic>).map((node) {
      return GraphQLNode.parse<Store>(node['node']);
    }).toList();

    return ServiceResponse(success: true, results: stores);
  }

  @override
  Future<ServiceResponse> getGallons(Store store, GallonType gallonType) async {
    final response = await api.query(
      QueryOptions(
        documentNode: gql(GetStoreGallons.query),
        variables: {
          'gallonType': Gallon.gallonTypeToString(gallonType),
          'storeId': store.id,
        },
      ),
    );
    var gallons = <Gallon>[];

    if (response.hasException) {
      return ServiceResponse(
          success: false,
          errorTitle: 'Opa :(',
          errorMessage: 'Um erro inesperado ocorreu com o servidor.',
          results: gallons);
    }

    gallons = (response.data['gallons']['edges'] as List<dynamic>).map((node) {
      return GraphQLNode.parse<Gallon>(node['node']);
    }).toList();

    return ServiceResponse(success: true, results: gallons);
  }
}
