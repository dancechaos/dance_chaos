// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/location_info_entity.dart';
import 'package:dance_chaos_data/app/entity/utility.dart';
import 'package:dance_chaos_data/app/repo/location_repository.dart';
import 'package:dance_chaos_data/models/location_info.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'firestore_profile_repository.dart';

enum ComparisonType {from, to}

class FirestoreLocationRepository implements LocationRepository {
  static const String path = 'locations';

  int _retryCounter = 0;

  FirestoreLocationRepository() : super();

  CollectionReference getCollection() {
    return FirestoreProfileRepository.firestore().collection(path);
  }

  Query getQuery() {
    Timestamp timestamp = Timestamp(Timestamp.now().seconds - 8 * 60 * 60, 0);
    DateTime date = DateTime(2021, 2, 8, 14, 25, 43);
    timestamp = Timestamp.fromDate(date);
    print('datetime $timestamp');
    print('date $date');
    return getCollection()
    // Note: I can't get timestamp comparison to work
    // .where('test', isEqualTo: 'yes');
    // .where('danceProfile.new', arrayContainsAny: ['IS','IP']);
    // .where('danceProfile.timestamp', isEqualTo: timestamp);
    // .orderBy('danceProfile.timestamp').startAt([timestamp]);
    ;
  }

  String getProfileComparison(ComparisonType comparisonType, String dance) {
    switch (comparisonType) {
      case ComparisonType.from:
        return LocationInfoEntity.DANCE_PROFILE + '.' + dance + '.from';
      case ComparisonType.to:
        return LocationInfoEntity.DANCE_PROFILE + '.' + dance + '.to';
    }
    return null;
  }

  DocumentReference getDocRef(String id) {
    return getCollection().doc(id);
  }

  @override
  Future<void> updateLocation(LocationInfoEntity locationInfoEntity) {
    if (locationInfoEntity?.id == null)
      throw 'No profile to update';
    return getDocRef(locationInfoEntity.id)
        .set(locationInfoEntity.toJson()).timeout(Utility.timeoutDefault)
        .catchError((error) {
      if ((Utility.isTimeoutError(error)) &&
          (_retryCounter++ <= Utility.retriesDefault)) {
        print('updateProfile Retry counter, $_retryCounter');
        return updateLocation(locationInfoEntity);
      }
      if (error is FirebaseException && error.code == 'not-found' &&
          _retryCounter++ <= Utility.retriesDefault) {
        sleep(Utility.timeoutDefault);
        return updateLocation(
            locationInfoEntity); // If the write hasn't completed yet, wait and try again
      }
      throw error;
    }).whenComplete(() {
      print('updateLocation complete');
      _retryCounter = 0;
    });
  }

  Geoflutterfire geo = Geoflutterfire();
  // Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject.seeded(LocationInfo.INITIAL_RADIUS_KM);

  @override
  void setRadius(double radiusKm) {
    radius.add(radiusKm);
  }

  @override
  Stream<List<LocationInfoEntity>> locationChanges(LatLng location) {
    GeoFirePoint center = geo.point(latitude: location.latitude, longitude: location.longitude);

    // subscribe to query
    return convert(radius.switchMap((rad) {
      return geo.collection(collectionRef: getQuery()).within(
        center: center,
        radius: rad,
        field: LocationInfoEntity.LOCATION,
        strictMode: true,
      );
    }));
  }

  Stream<List<LocationInfoEntity>> convert(Stream<List<DocumentSnapshot>> streamListDocumentSnapshot) async* {
    await for (List<DocumentSnapshot> listDocumentSnapshot in streamListDocumentSnapshot) {
      List<LocationInfoEntity> list = List<LocationInfoEntity>.empty(growable: true);
      listDocumentSnapshot.forEach((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        list.add(LocationInfoEntity.fromJson(documentSnapshot.id, data));
      });
      yield list == null || list.isEmpty ? null : list;
    }
  }
}
