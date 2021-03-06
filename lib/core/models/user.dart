import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:refresco/core/models/address.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: 'objectId')
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String cpf;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.cpf,
  });

  bool get isValid {
    if (id == null) return false;
    if (fullName == null) return false;
    if (email == null) return false;
    if (phone == null) return false;
    if (cpf == null) return false;
    return true;
  }

  bool get isAnonymous => id == null;

  User clone({
    String id,
    String fullName,
    String email,
    String phone,
    String cpf,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cpf: cpf ?? this.cpf,
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
