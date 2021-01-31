// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:dance_chaos/app/entity/profile_entity.dart';
import 'package:dance_chaos/app/entity/user_entity.dart';

/// A data layer class works with reactive data sources, such as Firebase. This
/// class emits a Stream of TodoEntities. The data layer of the app.
///
/// How and where it stores the entities should defined in a concrete
/// implementation, such as firebase_repository_flutter.
///
/// The domain layer should depend on this abstract class, and each app can
/// inject the correct implementation depending on the environment, such as
/// web or Flutter.
abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(UserEntity userEntity);

  Future<void> addNewProfile(ProfileEntity profile);

  Future<void> deleteProfile(String id);

  Stream<ProfileEntity> profileChanges(String id);

  Future<void> updateProfile(ProfileEntity profile);
}
