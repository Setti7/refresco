import 'package:graphql/client.dart';
import 'package:refresco/core/dataModels/graphql_node.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/api/queries/getCloseStores.dart';
import 'package:refresco/core/services/api/queries/get_store_gallons.dart';

class GraphQLApi {
  GraphQLClient client;

  GraphQLApi([GraphQLClient clientOverride]) {
    if (clientOverride != null) {
      client = clientOverride;
    } else {
      client = GraphQLClient(
        cache: InMemoryCache(),
        link: HttpLink(uri: 'http://192.168.15.14:1337/graphql', headers: {
          'X-Parse-Application-Id': '9UBUIZ0VeTdGe6YfwEg7KBbL8LSoM8ONAMQyLKzw',
        }),
      );
    }
  }

  Future<ServiceResponse> getCloseStores(Address address) async {
    final response = await client.query(
      QueryOptions(
        documentNode: gql(GetCloseStoresQuery.query),
        variables: {
          'latitude': address.coordinate.latitude,
          'longitude': address.coordinate.longitude,
        },
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }

    var stores = <Store>[];

    stores = (response.data['stores']['edges'] as List<dynamic>).map((node) {
      return GraphQLNode.parse<Store>(node['node']);
    }).toList();

    return ServiceResponse(success: true, results: stores);
  }

  Future<ServiceResponse> getStoreGallons(
      Store store, GallonType gallonType) async {
    final response = await client.query(
      QueryOptions(
        documentNode: gql(GetStoreGallons.query),
        variables: {
          'gallonType': Gallon.gallonTypeToString(gallonType),
          'storeId': store.id,
        },
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }

    var gallons = <Gallon>[];

    gallons = (response.data['gallons']['edges'] as List<dynamic>).map((node) {
      return GraphQLNode.parse<Gallon>(node['node']);
    }).toList();

    return ServiceResponse(success: true, results: gallons);
  }

  void authenticate() {}
}
