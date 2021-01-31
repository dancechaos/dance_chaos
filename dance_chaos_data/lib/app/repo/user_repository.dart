// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/user_entity.dart';

abstract class UserRepository {
  Future<void> initApp();
  Future<UserEntity> signIn({String user, String password});
  Stream<UserEntity> userChanges();
  Future<GeoPoint> getCurrentLocation();
  Stream<GeoPoint> locationChanges();
}
