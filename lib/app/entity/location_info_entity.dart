import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/entity/utility.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

@immutable
class LocationInfoEntity {
  final String id;
  final String displayName;
  final GeoPoint location;
  final String snippet;

  static const ID = 'id';
  static const DISPLAY_NAME = 'displayName';
  static const POSITION = 'position';

  static Geoflutterfire geo = Geoflutterfire();

  const LocationInfoEntity({@required this.id, this.displayName, this.location, this.snippet});

  @override
  int get hashCode =>
      id.hashCode ^ displayName.hashCode ^ location.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationInfoEntity &&
          id == other.id &&
          displayName == other.displayName &&
          location == other.location;

  @override
  String toString() {
    return 'LocationInfoEntity{$ID: $id, $DISPLAY_NAME: $displayName, location: $location)}';
  }

  Map<String, dynamic> toJson() {
    Map<String, Object> map = {ID: id};
    Utility.addToMap(map, POSITION, geo.point(latitude: location.latitude, longitude: location.longitude).data);
    Utility.addToMap(map, DISPLAY_NAME, displayName);
    return map;
    // return {'id': id,
    // 'position': geo.point(latitude: location.latitude, longitude: location.longitude).data};
  }

  static LocationInfoEntity fromJson(String id, Map<String, dynamic> json) {
    return LocationInfoEntity(
      id: id ?? json[ID] as String,
      displayName: json[DISPLAY_NAME] as String,
      location: json[POSITION]['geopoint'] as GeoPoint,
    );
  }

}
