// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:dance_chaos/app/entity/dance_profile_entity.dart';
import 'package:dance_chaos/app/repo/dance_profile_repository.dart';

import 'firestore_profile_repository.dart';

class FirestoreDanceProfileRepository implements DanceProfileRepository {
  static const String path = 'danceprofile';

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
}
