// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/entity/profile_entity.dart';
import 'package:dance_chaos/app/entity/user_entity.dart';
import 'package:dance_chaos/app/entity/utility.dart';
import 'package:dance_chaos/app/repo/profile_repository.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:flutter/foundation.dart';

class FirestoreProfileRepository implements ProfileRepository {
  static const String path = 'profile';

  static FirebaseFirestore _firestore;
  static bool _useLocalFirebaseEmulator;

  int _retryCounter = 0;

  FirestoreProfileRepository({FirebaseFirestore firestore, bool useLocalFirebaseEmulator = false}) {
    _firestore = firestore;
    _useLocalFirebaseEmulator = useLocalFirebaseEmulator;
  }

  static FirebaseFirestore firestore() {
    if (_firestore == null) {
      _firestore = FirebaseFirestore.instance;

      bool isAnEmulator = kIsWeb ? (false /*window.location.hostname == 'localhost'*/) : false;  // await FlutterIsEmulator.isDeviceAnEmulatorOrASimulator;
      if (isAnEmulator | _useLocalFirebaseEmulator) {
        String host = io.Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';

        _firestore.settings = Settings(
          host: host,
          sslEnabled: false,
          persistenceEnabled: false,
        );
      }
    }
    return _firestore;
  }

  DocumentReference getDocRef(String id) {
    return firestore().collection(path).doc(id);
  }

  @override
  Stream<ProfileEntity> profileChanges(String id) {
    return convertProfileStream(
      firestore().collection(path).doc(id).snapshots(),
    );
  }

  // There's an easier way to do this... I just don't know how
  Stream<ProfileEntity> convertProfileStream(Stream<DocumentSnapshot> source) async* {
    // Wait until a new chunk is available, then process it.
    await for (DocumentSnapshot user in source) {
      Map<String,dynamic> data = user.data();
      yield data == null || (data['id'] == null && user.id == null) ? null : ProfileEntity.fromJson(user.id, data);
    }
  }

  @override
  Future<ProfileEntity> getProfile(UserEntity user) async {
    if (user.id == Profile.noProfile.id || user.isAnonymous)  // Never
      return Profile.noProfile.toEntity();
    getDocRef(user.id).get().timeout(Utility.timeoutDefault).then((doc) {
      print('getProfile success');
      if (doc.exists) {
        return ProfileEntity.fromJson(user.id, doc.data());
      } else {  // If not found, create the new doc
        return addNewProfile(Profile.fromEntity(user).toEntity());
      }
    }).catchError((error) {
      print('getProfile error: $error');
      if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
        print('getProfile Retry counter, $_retryCounter');
        return getProfile(user);  // Retry
      }
      throw error;
    }).whenComplete(() {
      print('getProfile complete');
      _retryCounter = 0;
    });

    return null;  //Never
  }

  @override
  Future<void> addNewProfile(ProfileEntity profile) {
    return getDocRef(profile.id).set(profile.toJson(), SetOptions(merge: true)).timeout(Utility.timeoutDefault).catchError((error) {
      if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
        print('addNewProfile Retry counter, $_retryCounter');
        return addNewProfile(profile);  // Retry
      }
      throw error;
    }).whenComplete(() {
      print('getProfile complete');
      _retryCounter = 0;
    });
  }

  @override
  Future<void> deleteProfile(String id) async {
    return getDocRef(id).delete().timeout(Utility.timeoutDefault).catchError((error) {
      if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
        print('deleteProfile Retry counter, $_retryCounter');
        return deleteProfile(id);  // Retry
      }
      throw error;
    }).whenComplete(() {
      print('deleteProfile complete');
      _retryCounter = 0;
    });
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    if (profile.id == Profile.noProfile.id)
      throw 'No profile to update';
    return getDocRef(profile.id)
        .update(profile.toJson()).timeout(Utility.timeoutDefault)
        .catchError((error) {
      if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
        print('updateProfile Retry counter, $_retryCounter');
        return updateProfile(profile);
      }
      if (error is FirebaseException && error.code == 'not-found' && _retryCounter++ <= Utility.retriesDefault) {
        sleep(Utility.timeoutDefault);
        return updateProfile(profile);  // If the write hasn't completed yet, wait and try again
      }
      throw error;
    }).whenComplete(() {
      print('updateProfile complete');
      _retryCounter = 0;
    });
  }
}
