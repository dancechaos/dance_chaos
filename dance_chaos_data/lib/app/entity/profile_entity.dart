import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/user_entity.dart';
import 'package:dance_chaos_data/app/entity/utility.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:flutter/cupertino.dart';

class ProfileEntity extends UserEntity {
  final Timestamp birthdate;
  final Gender gender;
  final TrackingState tracking;
  final PartnerRole partnerRole;
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
  static const PARTNER_ROLE = 'partnerRole';
  static const HOME_LOCATION = 'homeLocation';

  ProfileEntity({@required id, displayName, photoUrl, email, phoneNumber, isAnonymous, providerId, this.birthdate, this.gender, this.tracking, this.partnerRole, this.homeLocation})
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
          partnerRole == other.partnerRole &&
          homeLocation == other.homeLocation;

  @override
  int get hashCode => super.hashCode ^ birthdate.hashCode ^ gender.hashCode ^ tracking.hashCode ^ partnerRole.hashCode ^ homeLocation.hashCode;

  Map<String, Object> toJson() {
    Map<String, Object> map = {}; //{ID: id};
    Utility.addToMap(map, DISPLAY_NAME, displayName);
    Utility.addToMap(map, PHOTO_URL, photoUrl);
    Utility.addToMap(map, PHONE_NUMBER, phoneNumber);
    Utility.addToMap(map, EMAIL, email);
    Utility.addToMap(map, IS_ANONYMOUS, isAnonymous);
    Utility.addToMap(map, BIRTHDATE, birthdate);
    Utility.addToMap(map, GENDER, gender == null ? null : gender.toString());
    Utility.addToMap(map, TRACKING, tracking == null ? null : tracking.toString());
    Utility.addToMap(map, PROVIDER_ID, providerId);
    Utility.addToMap(map, PARTNER_ROLE, partnerRole == null ? null : partnerRole.toString());
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
      isAnonymous: json[IS_ANONYMOUS] is String ? json[IS_ANONYMOUS] == 'true' ? true : false : json[IS_ANONYMOUS] as bool,
      birthdate: json[BIRTHDATE] as Timestamp,
      gender: getGenderFromString(json[GENDER]),
      homeLocation: json[HOME_LOCATION] as GeoPoint,
      providerId: json[PROVIDER_ID] as String,
      partnerRole: getPartnerRoleFromString(json[PARTNER_ROLE]),
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

  static PartnerRole getPartnerRoleFromString(String partnerRole) {
    return
      (PartnerRole.lead.toString() == partnerRole) ? PartnerRole
          .lead : (PartnerRole.follow.toString() ==
          partnerRole) ? PartnerRole.follow : (PartnerRole.both.toString() ==
          partnerRole) ? PartnerRole.both : null;
  }

  @override
  String toString() {
    return 'ProfileEntity{$ID: $id, $DISPLAY_NAME: $displayName, $PHOTO_URL: $photoUrl, $PHONE_NUMBER: $phoneNumber, $EMAIL: $email, $IS_ANONYMOUS: $isAnonymous, $BIRTHDATE: $birthdate, $GENDER: gender, $PROVIDER_ID: $providerId, $TRACKING: $tracking, $PARTNER_ROLE: $partnerRole, $HOME_LOCATION: $homeLocation}';
  }

}
