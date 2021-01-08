// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/repo/user_entity.dart';
import 'package:dance_chaos/app/repo/utility.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ProfileEntity extends UserEntity {
  final Timestamp birthdate;
  final TrackingState tracking;
  final GeoPoint homeLocation;

  ProfileEntity({@required id, displayName, photoUrl, email, phoneNumber, isAnonymous, providerId, this.birthdate, this.tracking, this.homeLocation})
    :
    super(
      id: id,
      displayName: displayName,
      photoUrl: photoUrl,
      email: email,
      phoneNumber: phoneNumber,
      isAnonymous: isAnonymous,
      providerId: providerId,
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          isAnonymous == other.isAnonymous &&
          tracking == other.tracking &&
          providerId == other.providerId &&
          birthdate == other.birthdate &&
          homeLocation == other.homeLocation;

  @override
  int get hashCode => super.hashCode ^ birthdate.hashCode ^ tracking.hashCode ^ homeLocation.hashCode;

  Map<String, Object> toJson() {
    Map<String, Object> map = {'id': id};
    addToMap(map, 'displayName', displayName);
    addToMap(map, 'photoUrl', photoUrl);
    addToMap(map, 'phoneNumber', phoneNumber);
    addToMap(map, 'email', email);
    addToMap(map, 'isAnonymous', isAnonymous);
    addToMap(map, 'birthdate', birthdate);
    addToMap(map, 'tracking', tracking.toString());
    addToMap(map, 'providerId', providerId);
    addToMap(map, 'displayName', displayName);
    addToMap(map, 'homeLocation', homeLocation);
    return map;
  }

  Map<String, Object> addToMap(Map<String, Object> map, String field, value) {
    if (value != null)
      map[field] = value;
    return map;
  }

  static ProfileEntity fromJson(String id, Map<String, Object> json) {
    return ProfileEntity(
      id: id ?? json['id'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      isAnonymous: json['isAnonymous'] as bool,
      birthdate: json['birthdate'] as Timestamp,
      homeLocation: json['homeLocation'] as GeoPoint,
      providerId: json['providerId'] as String,
      tracking: getTrackingFromString(json['tracking']),
    );
  }

  static TrackingState getTrackingFromString(String tracking) {
    return
      (TrackingState.trackingOn.toString() == tracking) ? TrackingState
          .trackingOn : (TrackingState.trackingWatching.toString() ==
          tracking) ? TrackingState.trackingWatching : TrackingState
          .trackingOff;
  }

  @override
  String toString() {
    return 'ProfileEntity{id: $id, displayName: $displayName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, email: $email, isAnonymous: $isAnonymous, birthdate: $birthdate, providerID: $providerId, tracking: $tracking, homeLocation: $homeLocation}';
  }

}
