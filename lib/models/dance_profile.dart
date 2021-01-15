import 'package:dance_chaos/app/core/uuid.dart';
import 'package:dance_chaos/app/entity/dance_profile_entity.dart';
import 'package:dance_chaos/app/entity/utility.dart';
import 'package:meta/meta.dart';

@immutable
class DanceProfile {
  final String id;
  final String danceCode;
  final String note;
  final int level;
  final Range range;

  DanceProfile({String id, this.danceCode, this.note, this.level, this.range}) :
    this.id = id ?? Uuid().generateV4();

  @override
  int get hashCode =>
      level.hashCode ^ danceCode.hashCode ^ note.hashCode ^ id.hashCode ^ range.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DanceProfile &&
              runtimeType == other.runtimeType &&
              level == other.level &&
              danceCode == other.danceCode &&
              note == other.note &&
              range == other.range &&
              id == other.id;

  DanceProfile copyWith({id, danceCode, note, level, range}) {
    return DanceProfile(
      id: id ?? this.id,
      danceCode: danceCode ?? this.danceCode,
      note: note ?? this.note,
      level: level ?? this.level,
      range: range ?? this.range,
    );
  }

  @override
  String toString() {
    return 'DanceProfile{id: $id, note: $note}';
  }

  DanceProfileEntity toEntity() {
    return DanceProfileEntity(id: id, danceCode: danceCode, note: note, level: level, range: range);
  }

  static DanceProfile fromEntity(DanceProfileEntity entity) {
    return DanceProfile(
      id: entity.id ?? Uuid().generateV4(),
      note: entity.note,
      danceCode: entity.danceCode,
      level: entity.level,
      range: entity.range ?? Range.RANGE_ALL,
    );
  }
}
