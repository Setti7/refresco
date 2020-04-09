import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class ParseAuthService implements AuthService {
  GraphQLApi api = GraphQLApi();

  ParseAuthService({this.api}) {
    api ??= GraphQLApi();

    loadUser().then((value) {
      user.listen((user) {
        _userBox.put('user', user.toJson());
      });
    });
  }

  Box _userBox;
  final Logger _logger = getLogger('ParseAuthService');

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
    final response = await api.loginWithEmail(email, password);
    if (response.success) {
      updateUser(response.results.first);
    }

    return response;
  }

  @override
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    final response = await api.createUserWithEmailAndPassword(email, password);
    if (response.success) {
      updateUser(response.results.first);
    }

    return response;
  }

  @override
  void updateUser(User newUser, {bool force = false}) {
    if (force) {
      _userSubject.add(newUser);
      return;
    }

    if (_userSubject.value.address == null) {
      _userSubject.add(newUser);
    } else {
      final oldUser = _userSubject.value;
      _userSubject.add(User.newAddress(newUser, oldUser.address));
    }
  }

  @override
  User getUser() => _userSubject.value;

  @override
  void logout() async {
    final oldUser = _userSubject.value;

    await api.logout();

    _userSubject.add(User.newAddress(User(), oldUser.address));
  }
}
