import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  Box userBox;

  // Subjects
  BehaviorSubject<User> _userSubject = BehaviorSubject<User>.seeded(User());

  // Observables
  Observable<User> get user => _userSubject.stream;

  AuthService() {
    loadUser().then((value) {
      user.listen((User user) {
        userBox.put('user', user.toJson());
        print('User saved!');
        print(user.toJson());
      });
    });
  }

  /// Startup function to load the [User] saved to disk.
  /// Should only be run at startup time.
  Future<void> loadUser() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path + '/hive');

    userBox = await Hive.openBox('userBox');

    Map<String, dynamic> userJson = Map.from(userBox.get('user') ?? {});
    if (userJson.isEmpty) {
      _userSubject.add(User());
    } else {
      User _user = User.fromJson(userJson);
      print(_user.toJson());
      _userSubject.add(_user);
    }
    print("USER LOADED!");
    print(_userSubject.value.toJson());
  }

  /// Login with email and password.
  Future<bool> loginWithEmail(
      {@required String email, @required String password}) async {
    AuthResult authResult =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    updateUser(User.fromFirebase(authResult.user));
    return true;
  }

  /// Create user with email and password.
  Future<bool> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    AuthResult authResult =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    updateUser(User.fromFirebase(authResult.user));
    return true;
  }

  /// Updates the user.
  /// If [force]] is set to true, the passed [newUser] will completely overwrite
  /// the current user. Otherwise, the [newUser] will be merged with the current
  /// user, using the current user's [userAddress].
  void updateUser(User newUser, {bool force = false}) {
    if (force) {
      _userSubject.add(newUser);
      return;
    }

    if (_userSubject.value.userAddress == null) {
      _userSubject.add(newUser);
    } else {
      User oldUser = _userSubject.value;
      _userSubject.add(User.newAddress(newUser, oldUser.userAddress));
    }
  }

  /// Get the current user.
  /// WARNING: just use this value before updating the user, as it can change
  /// while other operations are running.
  User getUser() => _userSubject.value;

  /// Sign user out, while maintaining the saved address.
  void logout() {
    User oldUser = _userSubject.value;
    FirebaseAuth.instance.signOut();
    _userSubject.add(User.newAddress(User(), oldUser.userAddress));
  }
}
