import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class UserInfo {
  final String id;
  final String email;
  final String credential;
  final String phone;
  final int passwordHash;
  final UserSignInStatus userSignInStatus;
  final Exception lastError;

  const UserInfo({this.id, this.email, this.userSignInStatus, this.credential, this.phone, this.passwordHash, this.lastError});

  UserInfo copyWith({String id, String email, UserSignInStatus userSignInStatus, credential, phone, passwordHash, Exception lastError}) {
    return UserInfo(
      id: id ?? this.id,
      email: email ?? this.email,
      userSignInStatus: userSignInStatus ?? this.userSignInStatus,
      credential: credential ?? this.credential,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      lastError: lastError ?? this.lastError,
    );
  }

  static const UserInfo noUserInfo = UserInfo(id: '0');  // No profile (note: This is not an anonymous profile)

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ userSignInStatus.hashCode ^ lastError.hashCode ^ credential.hashCode ^ phone.hashCode ^ passwordHash.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfo &&
          id == other.id &&
          email == other.email &&
          userSignInStatus == other.userSignInStatus &&
          credential == other.credential &&
          phone == other.phone &&
          passwordHash == other.passwordHash &&
          lastError == other.lastError;

  @override
  String toString() {
    return 'UserInfo{id: $id, email: $email,  userSignInStatus: $userSignInStatus, credential: $credential, phone: $phone, lastError: $lastError)}';
  }
}

class UserFilter extends UserInfo {
  const UserFilter({id, email, userSignInStatus, credential, phone, passwordHash, lastError, location})
  : super(id: id, email: email, userSignInStatus: userSignInStatus, credential: credential, phone: phone, passwordHash: passwordHash, lastError: lastError);
}
