import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/utility.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

@immutable
class LocationInfoEntity {
  final String id;
  final String displayName;
  final GeoPoint location;
  final Timestamp timestamp;
  final Map danceProfile;
  final String snippet;

  static const ID = 'id';
  static const DISPLAY_NAME = 'displayName';
  static const LOCATION = 'position';
  static const TIMESTAMP = 'timestamp';
  static const DANCE_PROFILE = 'danceProfile';
  static const SNIPPET = 'snippet';

  static Geoflutterfire geo = Geoflutterfire();

  const LocationInfoEntity({@required this.id, this.displayName, this.location, this.timestamp, this.danceProfile, this.snippet});

  @override
  int get hashCode =>
      id.hashCode ^ displayName.hashCode ^ location.hashCode ^ snippet.hashCode ^ timestamp.hashCode ^ danceProfile.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInfoEntity &&
          id == other.id &&
          displayName == other.displayName &&
          location == other.location &&
          snippet == other.snippet &&
          timestamp == other.timestamp &&
          danceProfile == other.danceProfile;

  @override
  String toString() {
    return 'LocationInfoEntity{$ID: $id, $DISPLAY_NAME: $displayName, $LOCATION: $location, $DANCE_PROFILE: $danceProfile, $TIMESTAMP: $timestamp)}';
  }

  Map<String, dynamic> toJson() {
    Map<String, Object> map = {}; //{ID: id};
    if (location != null)
      Utility.addToMap(map, LOCATION, geo.point(latitude: location.latitude, longitude: location.longitude).data);
    Utility.addToMap(map, DISPLAY_NAME, displayName);
    Utility.addToMap(map, SNIPPET, snippet);
    Utility.addToMap(map, TIMESTAMP, timestamp);
    Utility.addToMap(map, DANCE_PROFILE, danceProfile);
    return map;
    // return {'id': id,
    // 'position': geo.point(latitude: location.latitude, longitude: location.longitude).data};
  }

  static LocationInfoEntity fromJson(String id, Map<String, dynamic> json) {
    return LocationInfoEntity(
      id: id ?? json[ID] as String,
      displayName: json[DISPLAY_NAME] as String,
      location: json[LOCATION]['geopoint'] as GeoPoint,
      timestamp: json[TIMESTAMP],
      danceProfile: json[DANCE_PROFILE] as Map,
      snippet: json[SNIPPET],
    );
  }

}
