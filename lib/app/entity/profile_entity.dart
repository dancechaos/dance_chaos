import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/entity/user_entity.dart';
import 'package:dance_chaos/app/entity/utility.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:flutter/cupertino.dart';

class ProfileEntity extends UserEntity {
  final Timestamp birthdate;
  final Gender gender;
  final TrackingState tracking;
  final GeoPoint homeLocation;

  static const ID = 'id';
  static const DISPLAY_NAME = 'displayName';
  static const PHOTO_URL = 'photoUrl';
  static const PHONE_NUMBER = 'phoneNumber';
  static const EMAIL = 'email';
  static const IS_ANONYMOUS = 'isAnonymous';
  static const PROVIDER_ID = 'providerId';
  static const BIRTHDATE = 'birthdate';
  static const GENDER = 'gender';
  static const TRACKING = 'tracking';
  static const HOME_LOCATION = 'homeLocation';

  ProfileEntity({@required id, displayName, photoUrl, email, phoneNumber, isAnonymous, providerId, this.birthdate, this.gender, this.tracking, this.homeLocation})
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
          gender == other.gender &&
          homeLocation == other.homeLocation;

  @override
  int get hashCode => super.hashCode ^ birthdate.hashCode ^ gender.hashCode ^ tracking.hashCode ^ homeLocation.hashCode;

  Map<String, Object> toJson() {
    Map<String, Object> map = {}; //{ID: id};
    Utility.addToMap(map, DISPLAY_NAME, displayName);
    Utility.addToMap(map, PHOTO_URL, photoUrl);
    Utility.addToMap(map, PHONE_NUMBER, phoneNumber);
    Utility.addToMap(map, EMAIL, email);
    Utility.addToMap(map, IS_ANONYMOUS, isAnonymous);
    Utility.addToMap(map, BIRTHDATE, birthdate);
    Utility.addToMap(map, GENDER, gender == Gender.unspecified ? null : gender.toString());
    Utility.addToMap(map, TRACKING, tracking.toString());
    Utility.addToMap(map, PROVIDER_ID, providerId);
    Utility.addToMap(map, HOME_LOCATION, homeLocation);
    return map;
  }

  static ProfileEntity fromJson(String id, Map<String, Object> json) {
    return ProfileEntity(
      id: id ?? json[ID] as String,
      displayName: json[DISPLAY_NAME] as String,
      photoUrl: json[PHOTO_URL] as String,
      phoneNumber: json[PHONE_NUMBER] as String,
      email: json[EMAIL] as String,
      isAnonymous: json[IS_ANONYMOUS] as bool,
      birthdate: json[BIRTHDATE] as Timestamp,
      gender: getGenderFromString(json[GENDER]),
      homeLocation: json[HOME_LOCATION] as GeoPoint,
      providerId: json[PROVIDER_ID] as String,
      tracking: getTrackingFromString(json[TRACKING]),
    );
  }

  static TrackingState getTrackingFromString(String tracking) {
    return
      (TrackingState.trackingOn.toString() == tracking) ? TrackingState
          .trackingOn : (TrackingState.trackingWatching.toString() ==
          tracking) ? TrackingState.trackingWatching : TrackingState
          .trackingOff;
  }

  static Gender getGenderFromString(String gender) {
    return
      (Gender.male.toString() == gender) ? Gender
          .male : (Gender.female.toString() ==
          gender) ? Gender.female : Gender.unspecified;
  }

  @override
  String toString() {
    return 'ProfileEntity{$ID: $id, $DISPLAY_NAME: $displayName, $PHOTO_URL: $photoUrl, $PHONE_NUMBER: $phoneNumber, $EMAIL: $email, $IS_ANONYMOUS: $isAnonymous, $BIRTHDATE: $birthdate, $GENDER: gender, $PROVIDER_ID: $providerId, $TRACKING: $tracking, $HOME_LOCATION: $homeLocation}';
  }

}
