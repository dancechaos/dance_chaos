// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/app/entity/dance_profile_entity.dart';
import 'package:dance_chaos_data/app/entity/dances_entity.dart';
import 'package:dance_chaos_data/app/entity/utility.dart';
import 'package:dance_chaos_data/app/repo/dance_profile_repository.dart';

import 'firestore_profile_repository.dart';

class FirestoreDanceProfileRepository implements DanceProfileRepository {
  static const String path = 'danceprofile';
  static const String dancesPath = 'dance';

  int _retryCounter = 0;

  FirestoreDanceProfileRepository() : super();

  @override
  Future<void> addNewDanceProfile(String profileId, DanceProfileEntity danceProfile) {
    return FirestoreProfileRepository.firestore().collection(FirestoreProfileRepository.path).doc(profileId).collection(path).doc(danceProfile.id).set(danceProfile.toJson());
  }

  @override
  Future<void> deleteDanceProfile(String profileId, List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return FirestoreProfileRepository.firestore().collection(FirestoreProfileRepository.path).doc(profileId).collection(path).doc(id).delete();
    }));
  }

  @override
  Stream<List<DanceProfileEntity>> danceProfiles(String profileId) {
    return FirestoreProfileRepository.firestore().collection(FirestoreProfileRepository.path).doc(profileId).collection(path).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DanceProfileEntity.fromJson(doc.id, doc.data());
        // return DanceProfileEntity(
        //   id: doc.id,
        //   danceCode: doc[DanceProfileEntity.DANCE_CODE],
        //   note: doc[DanceProfileEntity.NOTE] ?? '',
        //   level: doc[DanceProfileEntity.LEVEL],
        //   range: doc[DanceProfileEntity.RANGE],
        // );
      }).toList();
    });
  }

  @override
  Future<void> updateDanceProfile(String profileId, DanceProfileEntity danceProfile) {
    return FirestoreProfileRepository.firestore()
        .collection(FirestoreProfileRepository.path)
        .doc(profileId)
        .collection(path)
        .doc(danceProfile.id)
        .update(danceProfile.toJson());
  }

  @override
  Future<DancesEntity> getDances(String languageCode, String countryCode, OnDancesUpdated onDancesUpdated) async {
    String code = languageCode ?? '';
    if (countryCode != null)
      code = code + '_' + countryCode;
    return FirestoreProfileRepository.firestore().collection(dancesPath).doc(code)
        .get()
        .timeout(Utility.timeoutDefault)
        .catchError((error) {
      print('getDances error: $error');
      if ((Utility.isTimeoutError(error)) &&
          (_retryCounter++ <= Utility.retriesDefault)) {
        print('getDances Retry counter, $_retryCounter');
        return getDances(languageCode, countryCode, onDancesUpdated); // Retry
      }
      throw error;
    }).whenComplete(() {
      print('getDances complete');
      _retryCounter = 0;
    }).then((doc) {
      print('getDances success');
      if (doc.exists) {
        DancesEntity dancesEntity = DancesEntity.fromJson(code, doc.data());
        onDancesUpdated(dancesEntity);
        return dancesEntity;
      } else { // If not found, try less strict version
        if (languageCode != null)
          return getDances(languageCode, null, onDancesUpdated);
        else if (code != null)
          return getDances(null, null, onDancesUpdated);
        else
          throw 'No default dance map';
      }
    });
  }

}
