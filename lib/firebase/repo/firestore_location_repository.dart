// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/repo/location_info_entity.dart';
import 'package:dance_chaos/app/repo/location_repository.dart';
import 'package:dance_chaos/app/repo/utility.dart';

import 'firestore_profile_repository.dart';

class FirestoreLocationRepository implements LocationRepository {
  static const String path = 'location';

  int _retryCounter = 0;

  FirestoreLocationRepository() : super();

  DocumentReference getDocRef(String id) {
    return FirestoreProfileRepository.firestore().collection(path).doc(id);
  }

  @override
  Future<void> updateLocation(LocationInfoEntity locationInfoEntity) {
    if (locationInfoEntity?.id == null)
      throw 'No profile to update';
    return getDocRef(locationInfoEntity.id)
        .set(locationInfoEntity.toJson()).timeout(Utility.timeoutDefault)
        .catchError((error) {
      if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
        print('updateProfile Retry counter, $_retryCounter');
        return updateLocation(locationInfoEntity);
      }
      if (error is FirebaseException && error.code == 'not-found' && _retryCounter++ <= Utility.retriesDefault) {
        sleep(Utility.timeoutDefault);
        return updateLocation(locationInfoEntity);  // If the write hasn't completed yet, wait and try again
      }
      throw error;
    }).whenComplete(() {
      print('updateLocation complete');
      _retryCounter = 0;
    });
  }
}
