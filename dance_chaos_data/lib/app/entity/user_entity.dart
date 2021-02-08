// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';

@immutable
class UserEntity {
  final String id;
  final String displayName;
  final String photoUrl;
  final String phoneNumber;
  final String email;
  final bool isAnonymous;
  final String providerId;

  UserEntity({@required this.id, this.displayName, this.photoUrl, this.email, this.phoneNumber, this.isAnonymous, this.providerId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          isAnonymous == other.isAnonymous &&
          providerId == other.providerId;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode ^ photoUrl.hashCode ^ phoneNumber.hashCode ^ email.hashCode ^ isAnonymous.hashCode ^ providerId.hashCode;

  @override
  String toString() {
    return 'UserEntity{id: $id, displayName: $displayName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, email: $email, isAnonymous: $isAnonymous, providerId: $providerId}';
  }
}
