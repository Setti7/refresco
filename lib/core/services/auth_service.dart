import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:flutter_base/utils/logger.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  Box userBox;
  Logger logger = getLogger('AuthService');

  // Subjects
  final BehaviorSubject<User> _userSubject =
      BehaviorSubject<User>.seeded(User());

  // Observables
  Observable<User> get user => _userSubject.stream;

  AuthService() {
    loadUser().then((value) {
      user.listen((User user) {
        userBox.put('user', user.toJson());
        logger.d('user saved');
      });
    });
  }

  /// Startup function to load the [User] saved to disk.
  /// Should only be run at startup time.
  Future<void> loadUser() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path + '/hive');

    userBox = await Hive.openBox('userBox');

    var userJson = Map<String, dynamic>.from(userBox.get('user') ?? {});
    if (userJson.isNotEmpty) {
      var _user = User.fromJson(userJson);
      _userSubject.add(_user);
      logger.d('user loaded');
    }
  }

  /// Login with email and password.
  Future<bool> loginWithEmail(
      {@required String email, @required String password}) async {
    var authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    updateUser(User.fromFirebase(authResult.user));
    return true;
  }

  /// Create user with email and password.
  Future<bool> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    var authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    updateUser(User.fromFirebase(authResult.user));
    return true;
  }

  /// Updates the user.
  /// If [force]] is set to true, the passed [newUser] will completely overwrite
  /// the current user. Otherwise, the [newUser] will be merged with the current
  /// user, using the current user's [address].
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

  /// Get the current user.
  /// WARNING: just use this value before updating the user, as it can change
  /// while other operations are running.
  User getUser() => _userSubject.value;

  /// Sign user out, while maintaining the saved address.
  void logout() {
    var oldUser = _userSubject.value;
    FirebaseAuth.instance.signOut();
    _userSubject.add(User.newAddress(User(), oldUser.address));
  }
}
