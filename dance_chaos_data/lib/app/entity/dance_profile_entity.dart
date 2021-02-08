import 'package:dance_chaos_data/app/entity/utility.dart';

class DanceProfileEntity {
  final String id;
  final String danceCode;
  final String note;
  final int level;
  final Range range;

  static const ID = 'id';
  static const DANCE_CODE = 'danceCode';
  static const NOTE = 'note';
  static const LEVEL = 'level';
//  static const RANGE = 'range';

  const DanceProfileEntity({this.id, this.danceCode, this.note, this.level, this.range = Range.RANGE_ALL});

  @override
  int get hashCode =>
      level.hashCode ^ danceCode.hashCode ^ note.hashCode ^ id.hashCode ^ range.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DanceProfileEntity &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          danceCode == other.danceCode &&
          note == other.note &&
          range == other.range &&
          id == other.id;

  Map<String, Object> toJson() {
    Map<String, Object> map = {};
    Utility.addToMap(map, DANCE_CODE, danceCode);
    Utility.addToMap(map, NOTE, note);
    Utility.addToMap(map, LEVEL, level);
    // Utility.addToMap(map, RANGE, Range.rangeToMap(range));
    Utility.addToMap(map, Range.RANGE_FROM, range?.from);
    Utility.addToMap(map, Range.RANGE_TO, range?.to);
    return map;
  }

  static DanceProfileEntity fromJson(String id, Map<String, dynamic> json) {
    return DanceProfileEntity(
      id: id ?? json[ID] as String,
      danceCode: json[DANCE_CODE] as String,
      note: json[NOTE] as String,
      level: json[LEVEL] as int,
      range: json[Range.RANGE_FROM] == null && json[Range.RANGE_TO] == null ? null : Range(json[Range.RANGE_FROM] == null ? Range.MIN_FROM : json[Range.RANGE_FROM] as int, json[Range.RANGE_TO] == null ? Range.MAX_TO : json[Range.RANGE_TO] as int),
    );
  }

  @override
  String toString() {
    return 'DanceProfileEntity{$ID: $id, $LEVEL: $level, $DANCE_CODE: $danceCode, $NOTE: $note, ${Range.RANGE_FROM}: ${range?.from}, ${Range.RANGE_TO}: ${range?.to}';
  }
}
