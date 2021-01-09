import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/repo/utility.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

@immutable
class LocationInfoEntity {
  final String id;
  final GeoPoint location;
  static Geoflutterfire geo = Geoflutterfire();

  const LocationInfoEntity({@required this.id, this.location});

  @override
  int get hashCode =>
      id.hashCode ^ location.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInfoEntity &&
          id == other.id &&
          location == other.location;

  @override
  String toString() {
    return 'LocationInfoEntity{id: $id, location: $location)}';
  }

  Map<String, dynamic> toJson() {
    Map<String, Object> map = {'id': id};
    Utility.addToMap(map, 'position', geo.point(latitude: location.latitude, longitude: location.longitude).data);
    return map;
    // return {'id': id,
    // 'position': geo.point(latitude: location.latitude, longitude: location.longitude).data};
  }

  static LocationInfoEntity fromJson(String id, Map<String, dynamic> json) {
    return LocationInfoEntity(
      id: id ?? json['id'] as String,
      location: json['position']['geopoint'] as GeoPoint,
    );
  }

}
