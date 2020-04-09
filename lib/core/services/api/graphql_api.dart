import 'package:graphql/client.dart';
import 'package:refresco/core/dataModels/graphql_node.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/api/mutations/login.dart';
import 'package:refresco/core/services/api/mutations/logout.dart';
import 'package:refresco/core/services/api/mutations/sign_up.dart';
import 'package:refresco/core/services/api/queries/get_close_stores.dart';
import 'package:refresco/core/services/api/queries/get_store_gallons.dart';

class GraphQLApi {
  GraphQLClient client;
  String _uri = 'http://192.168.15.14:1337/graphql';
  final _headers = {
    'X-Parse-Application-Id': '9UBUIZ0VeTdGe6YfwEg7KBbL8LSoM8ONAMQyLKzw',
  };

  GraphQLApi([GraphQLClient clientOverride]) {
    client = clientOverride ?? _createGraphQlClient();
  }

  GraphQLClient _createGraphQlClient() {
    return GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(uri: _uri, headers: _headers),
    );
  }

  void _updateSessionToken(String sessionToken) {
    if (sessionToken == null) {
      _headers.remove('X-Parse-Session-Token');
    } else {
      _headers['X-Parse-Session-Token'] = sessionToken;
    }

    client = _createGraphQlClient();
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

  Future<ServiceResponse> loginWithEmail(String email, String password) async {
    final response = await client.mutate(
      MutationOptions(
        documentNode: gql(Login.mutation),
        variables: {'email': email, 'password': password},
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }

    final userJson = response.data['logIn']['viewer']['user'];
    final sessionToken = response.data['logIn']['viewer']['sessionToken'];
    _updateSessionToken(sessionToken);
    final user = GraphQLNode.parse<User>(userJson);

    return ServiceResponse(success: true, results: [user]);
  }

  Future<ServiceResponse> createUserWithEmailAndPassword(
      String email, String password) async {
    final response = await client.mutate(
      MutationOptions(
        documentNode: gql(SignUp.mutation),
        variables: {'email': email, 'password': password},
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }

    final userJson = response.data['signUp']['viewer']['user'];
    final sessionToken = response.data['signUp']['viewer']['sessionToken'];
    _updateSessionToken(sessionToken);
    final user = GraphQLNode.parse<User>(userJson);

    return ServiceResponse(success: true, results: [user]);
  }

  Future<ServiceResponse> logout() async {
    final response = await client.mutate(
      MutationOptions(documentNode: gql(Logout.mutation)),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }

    _updateSessionToken(null);
    return ServiceResponse(success: true);
  }
}
