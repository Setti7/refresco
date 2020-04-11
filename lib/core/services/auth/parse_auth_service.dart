import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
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
  Box _userBox;

  ParseAuthService() {
    loadUser().then((value) {
      user.listen((user) {
        _userBox.put('user', user.toJson());
        // TODO: upload user to backend
      });
    });
  }

  // Subjects
  final BehaviorSubject<User> _userSubject =
      BehaviorSubject<User>.seeded(User());

  @override
  Stream<User> get user => _userSubject.stream;

  @override
  Future<void> loadUser() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path + '/hive');

    _userBox = await Hive.openBox('userBox');

    final userJson = Map<String, dynamic>.from(_userBox.get('user') ?? {});
    if (userJson.isNotEmpty) {
      final _user = User.fromJson(userJson);
      _userSubject.add(_user);
      _logger.d('user loaded');
    }
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

    updateUser(GraphQLNode.parse<User>(userJson));

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

    updateUser(GraphQLNode.parse<User>(userJson));

    return ServiceResponse(success: true);
  }

  @override
  void updateUser(User newUser, {bool force = false}) {
    var tempUser = newUser;
    final currentUser = getUser();

    if (!force && currentUser.address != null) {
      tempUser = User.newAddress(newUser, currentUser.address);
    }

    _userSubject.add(tempUser);
  }

  @override
  User getUser() => _userSubject.value;

  @override
  void logout() async {
    final oldUser = _userSubject.value;

    await api.mutate(MutationOptions(documentNode: gql(Logout.mutation)));

    api.updateSessionToken(null);
    _userSubject.add(User.newAddress(User(), oldUser.address));
  }

  @override
  Future<ServiceResponse> uploadUser(User user) async {
    final response = await api.mutate(
      MutationOptions(
        documentNode: gql(UpdateUser.mutation),
        variables: UpdateUser.builder(user),
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
}
