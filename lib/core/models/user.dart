import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base/core/models/user_address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  final String fullName;
  final String email;
  final UserAddress userAddress;

  User({
    this.id,
    this.fullName,
    this.email,
    this.userAddress,
  });

  bool get isAnonymous => id == null;

  factory User.newAddress(User user, UserAddress newAddress) {
    return User(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      userAddress: newAddress,
    );
  }

  factory User.fromFirebase(FirebaseUser user) {
    return User(
      id: user.uid,
      fullName: user.displayName,
      email: user.email,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
