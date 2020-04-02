import 'package:flutter/cupertino.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/api/parse_api.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/utils/logger.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class ParseAuthService implements AuthService {
  ParseApi api;

  ParseAuthService({this.api}) {
    api ??= ParseApi();

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
  Observable<User> get user => _userSubject.stream;

  @override
  Future<void> loadUser() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path + '/hive');

    _userBox = await Hive.openBox('userBox');

    var userJson = Map<String, dynamic>.from(_userBox.get('user') ?? {});
    if (userJson.isNotEmpty) {
      var _user = User.fromJson(userJson);
      _userSubject.add(_user);
      _logger.d('user loaded');
    }
  }

  @override
  Future<ServiceResponse> loginWithEmail(
      {@required String email, @required String password}) async {
    var response = await api.login(ParseUser(email, password, email));
    if (response.success) {
      updateUser(User.fromParse(response.results.first));
      return ServiceResponse(success: true);
    } else {
      return ServiceResponse.fromParseError(response.error);
    }
  }

  @override
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    var response = await ParseUser.createUser(email, password, email).signUp();
    if (response.success) {
      updateUser(User.fromParse(response.results.first));
      return ServiceResponse(success: true);
    } else {
      return ServiceResponse.fromParseError(response.error);
    }
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
      var oldUser = _userSubject.value;
      _userSubject.add(User.newAddress(newUser, oldUser.address));
    }
  }

  @override
  User getUser() => _userSubject.value;

  @override
  void logout() async {
    var oldUser = _userSubject.value;

    ParseUser _user = await ParseUser.currentUser();
    await _user.logout(deleteLocalUserData: true);

    _userSubject.add(User.newAddress(User(), oldUser.address));
  }
}
