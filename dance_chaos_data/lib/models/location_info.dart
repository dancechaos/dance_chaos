import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/location_info_entity.dart';
import 'package:dance_chaos_data/app/entity/utility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
class LocationInfo {
  final String id;
  final GeoPoint location;
  final String displayName;
  final Timestamp timestamp;
  final Map danceProfile;

  static const INITIAL_RADIUS_KM = 100.0;
  static const double INITIAL_ZOOM = 17;
  static const DEFAULT_LOCATION = LatLng(53.814167, -3.050278);

  const LocationInfo({this.id, this.displayName, this.location, this.timestamp, this.danceProfile});

  LocationInfo copyWith({String id, GeoPoint location, String displayName, Timestamp timestamp, Map danceProfile}) {
    return LocationInfo(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      danceProfile: danceProfile ?? this.danceProfile,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ displayName.hashCode ^ location.hashCode ^ timestamp.hashCode ^ danceProfile.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInfo &&
          id == other.id &&
          displayName == other.displayName &&
          location == other.location &&
          // timestamp == other.timestamp &&  // Note: Timestamp is not evaluated in == operator
          Utility.mapEquals(danceProfile, other.danceProfile);

  @override
  String toString() {
    return 'UserInfo{id: $id, displayName: $displayName, location: $location, timestamp: $timestamp, danceProfile: $danceProfile)}';
  }

  LocationInfoEntity toEntity() {
    return LocationInfoEntity(id: id, displayName: displayName, location: location, timestamp: timestamp, danceProfile: danceProfile);
  }

  static LocationInfo fromEntity(LocationInfoEntity entity) {
    return entity == null ? null : LocationInfo(
      id: entity.id,
      displayName: entity.displayName,
      location: GeoPoint(entity.location.latitude, entity.location.longitude),
      timestamp: entity.timestamp,
      danceProfile: entity.danceProfile,
    );
  }

}
