import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/entity/location_info_entity.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class LocationInfo {
  final String id;
  final GeoPoint location;
  final String displayName;

  const LocationInfo({this.id, this.displayName, this.location});

  LocationInfo copyWith({String id, GeoPoint location}) {
    return LocationInfo(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      location: location ?? this.location,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ displayName.hashCode ^ location.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInfo &&
          id == other.id &&
          displayName == other.displayName &&
          location == other.location;

  @override
  String toString() {
    return 'UserInfo{id: $id, displayName: $displayName, location: $location)}';
  }

  LocationInfoEntity toEntity() {
    return LocationInfoEntity(id: id, displayName: displayName, location: location);
  }

  static LocationInfo fromEntity(LocationInfoEntity entity) {
    return entity == null ? null : LocationInfo(
      id: entity.id,
      displayName: entity.displayName,
      location: GeoPoint(entity.location.latitude, entity.location.longitude),
    );
  }

}
