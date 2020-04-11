import 'package:flutter/material.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/user.dart';

abstract class AuthService {
  AuthService();

  /// Startup function to load the [User] saved to disk.
  ///
  /// Should only be run at startup time.
  Future<void> loadUser();

  /// [User] observable
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

  /// Updates the [User].
  ///
  /// If [force] is set to true, the passed [newUser] will completely overwrite
  /// the current user. Otherwise, the [newUser] will be merged with the current
  /// user, using the current user's [Address].
  void updateUser(User newUser, {bool force = false});

  /// Uploads the [User] to the backend.
  ///
  /// Should be called whenever the user changes locally.
  Future<ServiceResponse> uploadUser(User user);

  /// Get the current [User]].
  ///
  /// WARNING: only use this value right after updating the user, as it can
  /// change while other operations are running.
  User getUser();

  /// Sign user out, while maintaining the saved address.
  void logout();
}
