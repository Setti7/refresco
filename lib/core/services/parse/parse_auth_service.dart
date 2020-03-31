import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/models/service_response.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:flutter_parse/flutter_parse.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class ParseAuthService implements AuthService {
  ParseAuthService() {
    loadUser().then((value) {
      user.listen((user) {
        _userBox.put('user', user.toJson());
      });
    });
  }

  Box _userBox;
  Logger _logger = getLogger('ParseAuthService');

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
    try {
      ParseUser _user =
          await ParseUser.signIn(username: email, password: password);
      updateUser(User.fromParse(_user));
    } on ParseException catch (e) {
      return ServiceResponse(parseException: e);
    }

    return ServiceResponse();
  }

  @override
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    var _user = ParseUser()
      ..set('username', email)
      ..set('password', password)
      ..set('email', email);

    try {
      _user = await _user.signUp();
      updateUser(User.fromParse(_user));
    } on ParseException catch (e) {
      return ServiceResponse(parseException: e);
    }

    return ServiceResponse();
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
    await ParseUser.signOut();
    _userSubject.add(User.newAddress(User(), oldUser.address));
  }
}
