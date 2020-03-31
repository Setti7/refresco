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
    getSavedUser().then((value) {
      user.listen((User user) {
        userBox.put('user', user.toJson());
        print(user.toJson());
      });
    });
  }

  // Startup functions
  Future<void> getSavedUser() async {
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

  // Functions
  Future<bool> loginWithEmail(
      {@required String email, @required String password}) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    _userSubject.add(User.fromFirebase(authResult.user));
    return true;
  }

  Future<bool> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    _userSubject.add(User.fromFirebase(authResult.user));
    return true;
  }

  Future<void> loginWithGoogle() async {}

  void logout() {
    FirebaseAuth.instance.signOut();
    _userSubject.add(User());
  }
}
