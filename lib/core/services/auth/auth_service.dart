import 'package:flutter/material.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/user.dart';

abstract class AuthService {
  /// Startup function to load the [User] saved to disk.
  ///
  /// Should only be run at startup time.
  Future<void> loadUser();

  /// [User] stream
  Stream<User> get user;

  /// Login with [email] and [password].
  ///
  /// [ServiceResponse.results] will always be null;
  Future<ServiceResponse> loginWithEmail(
      {@required String email, @required String password});

  /// Create [User] with [email] and [password].
  ///
  /// [ServiceResponse.results] will always be null;
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password});

  /// Updates the [User] locally and remotely.
  Future<ServiceResponse> updateUser(User newUser);

  /// Returns the most recent [User] from [user] stream.
  User getUser();

  /// Sign user out, while maintaining the saved address.
  void logout();
}
