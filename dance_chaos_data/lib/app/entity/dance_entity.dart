import 'package:dance_chaos_data/app/entity/utility.dart';
import 'package:flutter/cupertino.dart';

@immutable
class DanceEntity {
  final String id;
  final String danceCode;
  final String name;
  final int category;

  static const ID = 'id';
  static const DANCE_CODE = 'danceCode';
  static const NAME = 'name';
  static const CATEGORY = 'category';

  const DanceEntity({this.id, this.danceCode, this.name, this.category});

  @override
  int get hashCode =>
      category.hashCode ^ danceCode.hashCode ^ name.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DanceEntity &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          danceCode == other.danceCode &&
          name == other.name &&
          id == other.id;

  Map<String, Object> toJson() {
    Map<String, Object> map = {};
    Utility.addToMap(map, DANCE_CODE, danceCode);
    Utility.addToMap(map, NAME, name);
    Utility.addToMap(map, CATEGORY, category);
    return map;
  }

  @override
  String toString() {
    return 'DanceEntity{$CATEGORY: $category, $DANCE_CODE: $danceCode, $NAME: $name, $ID: $id}';
  }

  static DanceEntity fromJson(String id, Map<String, Object> json) {
    return DanceEntity(
      id: id ?? json[ID] as String,
      danceCode: json[DANCE_CODE] as String,
      name: json[NAME] as String,
      category: json[CATEGORY] as int,
    );
  }
}
