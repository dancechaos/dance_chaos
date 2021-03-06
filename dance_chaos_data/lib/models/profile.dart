import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/profile_entity.dart';
import 'package:dance_chaos_data/app/entity/user_entity.dart';
import 'package:dance_chaos_data/models/dance_profile.dart';
import 'package:dance_chaos_data/app/entity/dance_profile_entity.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dance_chaos_data/app/entity/utility.dart';

@immutable
class Profile {
  final String id;
  final String displayName;
  final String photoUrl;
  final String email;
  final String phoneNumber;
  final bool isAnonymous;
  final Timestamp birthdate;
  final Gender gender;
  final TrackingState tracking;
  final GeoPoint homeLocation;
  final PartnerRole partnerRole;
  final List<DanceProfile> danceProfileList;

  static const Profile noProfile = Profile('0', isAnonymous: true);  // No profile (note: This is not an anonymous profile)
  static const List<DanceProfile> danceProfileNotLoaded = const [];  // Not loaded yet

  const Profile(this.id, {this.displayName, this.photoUrl, this.email, this.phoneNumber, this.isAnonymous, this.birthdate, this.gender, this.tracking, this.homeLocation, this.partnerRole, this.danceProfileList});
        // this.isAnonymous = isAnonymous ?? (displayName == null) && (phoneNumber == null) && (email == null) && (photoUrl == null) && (birthdate == null) && (homeLocation == null),
        // this.tracking = tracking ?? TrackingState.trackingOff,
        // this.danceProfileList = danceProfileList ?? danceProfileNotLoaded;

  Profile copyWith({String id, String displayName, String photoUrl, String email, String phoneNumber, bool isAnonymous, Timestamp birthdate, String gender, TrackingState tracking, GeoPoint location, List<DanceProfile> danceProfileList}) {
    return Profile(
      id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      homeLocation: homeLocation ?? this.homeLocation,
      tracking: tracking ?? this.tracking,
      partnerRole: partnerRole ?? this.partnerRole,
      danceProfileList: danceProfileList ?? this.danceProfileList,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ displayName.hashCode ^ photoUrl.hashCode ^ email.hashCode ^ phoneNumber.hashCode ^ isAnonymous.hashCode ^ birthdate.hashCode ^ gender.hashCode ^ tracking.hashCode ^ homeLocation.hashCode ^ partnerRole.hashCode ^ danceProfileList.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          id == other.id &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          isAnonymous == other.isAnonymous &&
          tracking == other.tracking &&
          birthdate == other.birthdate &&
          gender == other.gender &&
          homeLocation == other.homeLocation &&
          partnerRole == other.partnerRole &&
          danceProfileList == other.danceProfileList;

  @override
  String toString() {
    return 'Profile{id: $id, displayName: $displayName, photoUrl: $photoUrl, email: $email, phoneNumber: $phoneNumber, isAnonymous: $isAnonymous, birthdate: $birthdate, gender: gender, tracking, $tracking, homeLocation, $homeLocation, partnerRole: $partnerRole, danceProfileList: $danceProfileList)}';
  }

  ProfileEntity toEntity() {
    return ProfileEntity(id: id, displayName: displayName, photoUrl: photoUrl, email: email, phoneNumber: phoneNumber, isAnonymous: isAnonymous, birthdate: birthdate, gender: gender, tracking: tracking, partnerRole: partnerRole, homeLocation: homeLocation);
  } // Note: ProfileSignInStatus is ephemeral

  static Profile fromEntity(UserEntity entity, {UserSignInStatus userSignInStatus = UserSignInStatus.signedOut, Exception lastException}) {
    return entity == null ? null : Profile(
      entity.id,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      isAnonymous: entity.isAnonymous,
      birthdate: entity is ProfileEntity ? entity.birthdate : null,
      gender: entity is ProfileEntity ? entity.gender : null,
      homeLocation: entity is ProfileEntity ? entity.homeLocation : null,
      partnerRole: entity is ProfileEntity ? entity.partnerRole : null,
      tracking: entity is ProfileEntity ? entity.tracking : null,
    );
  }

  Profile.fromUser(User user)
      : assert(user.uid != null), id=user.uid,
  displayName = user.displayName,
  email = user.email,
  phoneNumber = user.phoneNumber,
  photoUrl = user.photoURL,
  isAnonymous = user.isAnonymous,
  birthdate = null,
  gender = null,
  homeLocation = null,
  tracking = TrackingState.trackingOff,
  partnerRole = null,
  danceProfileList = danceProfileNotLoaded;

  Color getTrackingColor({TrackingState tracking, bool isAnonymous}) {
    isAnonymous ??= this.isAnonymous;
    switch (tracking ?? this.tracking) {
      case TrackingState.trackingOn:
        return Colors.greenAccent;
      case TrackingState.trackingWatching:
        return isAnonymous ? Colors.orange : Colors.blueAccent;
      default:
        return isAnonymous ? Colors.red : Colors.yellow;
    }
  }

  static TrackingState trackingActionToState(ProfileAction profileAction) {
    switch (profileAction) {
      case ProfileAction.trackingOff:
        return TrackingState.trackingOff;
      case ProfileAction.trackingOn:
        return TrackingState.trackingOn;
      case ProfileAction.trackingWatching:
        return TrackingState.trackingWatching;
      default:
        return null;
    }
  }

  Map danceProfileMap() {
    if (danceProfileList == null)
      return null;
    Map danceProfileMap = {};
    danceProfileList.forEach((danceProfile) {
      danceProfileMap[danceProfile.danceCode] = {
        DanceProfileEntity.LEVEL: danceProfile.level ?? Range.MIN_FROM,
        Range.RANGE_FROM: danceProfile?.range?.from ?? Range.MIN_FROM,
        Range.RANGE_TO: danceProfile?.range?.to ?? Range.MAX_TO,
      };
    });
    return danceProfileMap;
  }
}
