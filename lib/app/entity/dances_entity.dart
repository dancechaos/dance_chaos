import 'package:dance_chaos/app/entity/utility.dart';

class DancesEntity {
  final String id;
  final Map dances;

  static const ID = 'id';
  static const DANCES = 'dances';

  const DancesEntity({this.id, this.dances});

  @override
  int get hashCode =>
      dances.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DancesEntity &&
          runtimeType == other.runtimeType &&
          dances == other.dances &&
          id == other.id;

  Map<String, Object> toJson() {
    Map<String, Object> map = {};
    Utility.addToMap(map, DANCES, dances);
    return map;
  }

  @override
  String toString() {
    return 'DancesEntity{$DANCES: $dances, $ID: $id}';
  }

  static DancesEntity fromJson(String id, Map<String, Object> json) {
    return DancesEntity(
      id: id ?? json[ID] as String,
      dances: json[DANCES] as Map,
    );
  }
}
