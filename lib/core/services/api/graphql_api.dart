import 'package:graphql/client.dart';

class GraphQLApi {
  GraphQLClient client;
  final String _uri = 'http://192.168.15.14:1337/graphql';
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

  void updateSessionToken(String sessionToken) {
    if (sessionToken == null) {
      _headers.remove('X-Parse-Session-Token');
    } else {
      _headers['X-Parse-Session-Token'] = sessionToken;
    }

    client = _createGraphQlClient();
  }

  Future<QueryResult> query(QueryOptions options) {
    return client.query(options);
  }

  Future<QueryResult> mutate(MutationOptions options) {
    return client.mutate(options);
  }
}
