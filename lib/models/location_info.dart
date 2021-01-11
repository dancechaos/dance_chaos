import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/entity/location_info_entity.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class LocationInfo {
  final String id;
  final GeoPoint location;

  const LocationInfo({this.id, this.location});

  LocationInfo copyWith({String id, GeoPoint location}) {
    return LocationInfo(
      id: id ?? this.id,
      location: location ?? this.location,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^ location.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInfo &&
          id == other.id &&
          location == other.location;

  @override
  String toString() {
    return 'UserInfo{id: $id, location: $location)}';
  }

  LocationInfoEntity toEntity() {
    return LocationInfoEntity(id: id, location: location);
  }

  static LocationInfo fromEntity(LocationInfoEntity entity) {
    return entity == null ? null : LocationInfo(
      id: entity.id,
      location: GeoPoint(entity.location.latitude, entity.location.longitude),
    );
  }

}
