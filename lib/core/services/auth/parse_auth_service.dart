import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:refresco/core/dataModels/graphql_node.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/api/mutations/login.dart';
import 'package:refresco/core/services/api/mutations/logout.dart';
import 'package:refresco/core/services/api/mutations/sign_up.dart';
import 'package:refresco/core/services/api/mutations/update_user.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class ParseAuthService implements AuthService {
  final Logger _logger = getLogger('ParseAuthService');
  GraphQLApi api = locator<GraphQLApi>();
  Box _box;

  ParseAuthService() {
    loadUser();
  }

  // Subjects
  final BehaviorSubject<User> _userSubject =
      BehaviorSubject<User>.seeded(User());

  @override
  Stream<User> get user => _userSubject.stream;

  @override
  Future<void> loadUser() async {
    /// TODO:
    /// Get user email and password from local storage too (encrypted),
    /// re-login the user, and update the session token.
    ///
    /// Save user and email/password in the same box, but under a different key.
    await _openUserBox();
    final userJson = Map<String, dynamic>.from(_box.get('user') ?? {});

    if (userJson.isNotEmpty) {
      final _user = User.fromJson(userJson);
      unawaited(updateUser(_user));
      _logger.d('user loaded');
    }
  }

  Future<void> _openUserBox() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path + '/hive');

    _box = await Hive.openBox('userBox');
  }

  @override
  Future<ServiceResponse> loginWithEmail(
      {@required String email, @required String password}) async {
    final response = await api.mutate(
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
    api.updateSessionToken(sessionToken);

    unawaited(updateUser(GraphQLNode.parse<User>(userJson)));

    return ServiceResponse(success: true);
  }

  @override
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    final response = await api.mutate(
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
    api.updateSessionToken(sessionToken);

    unawaited(updateUser(GraphQLNode.parse<User>(userJson)));

    return ServiceResponse(success: true);
  }

  @override
  Future<ServiceResponse> updateUser(User newUser) async {
    _userSubject.add(newUser);

    // Saving user locally
    await _saveUser(newUser);

    // Saving user remotely
    final response = await api.mutate(
      MutationOptions(
        documentNode: gql(UpdateUser.mutation),
        variables: UpdateUser.builder(newUser),
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }

    return ServiceResponse(success: true);
  }

  void _saveUser(User user) async {
    if (_box == null || !_box.isOpen) {
      await _openUserBox();
    }

    await _box.put('user', user.toJson());
  }

  @override
  User getUser() => _userSubject.value;

  @override
  void logout() async {
    await api.mutate(MutationOptions(documentNode: gql(Logout.mutation)));
    api.updateSessionToken(null);

    _userSubject.add(User());
  }
}
