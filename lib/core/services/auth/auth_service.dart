import 'package:flutter/material.dart';
import 'package:refresco/core/services/service_response.dart';
import 'package:refresco/core/models/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthService {
  AuthService();

  /// Startup function to load the [User] saved to disk.
  ///
  /// Should only be run at startup time.
  Future<void> loadUser();

  /// User observable
  Observable<User> get user;

  /// Login with [email] and [password].
  Future<ServiceResponse> loginWithEmail(
      {@required String email, @required String password});

  /// Create user with [email] and [password].
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password});

  /// Updates the user.
  ///
  /// If [force]] is set to true, the passed [newUser] will completely overwrite
  /// the current user. Otherwise, the [newUser] will be merged with the current
  /// user, using the current user's [address].
  void updateUser(User newUser, {bool force = false});

  /// Get the current user.
  ///
  /// WARNING: just use this value before updating the user, as it can change
  /// while other operations are running.
  User getUser();

  /// Sign user out, while maintaining the saved address.
  void logout();
}
