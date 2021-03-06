import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService() {
    loadUser().then((value) {
      user.listen((user) {
        _userBox.put('user', user.toJson());
      });
    });
  }

  Box _userBox;
  final Logger _logger = getLogger('FirebaseAuthService');

  // Subjects
  final BehaviorSubject<User> _userSubject =
      BehaviorSubject<User>.seeded(User());

  // Observables
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
    AuthResult authResult;

    try {
      authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      unawaited(updateUser(User.fromFirebase(authResult.user)));
    } on PlatformException catch (e) {
      return ServiceResponse.fromFirebaseError(e.code);
    }

    return ServiceResponse(success: true);
  }

  @override
  Future<ServiceResponse> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    AuthResult authResult;

    try {
      authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      unawaited(updateUser(User.fromFirebase(authResult.user)));
    } on PlatformException catch (e) {
      return ServiceResponse.fromFirebaseError(e.code);
    }

    return ServiceResponse(success: true);
  }

  @override
  Future<ServiceResponse> updateUser(User newUser) async {
    _userSubject.add(newUser);
    throw UnimplementedError();
  }

  @override
  User getUser() => _userSubject.value;

  @override
  void logout() {
    FirebaseAuth.instance.signOut();
    _userSubject.add(User());
  }
}
