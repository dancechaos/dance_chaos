import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utility {
  static String formatDate(Timestamp date) {
    return date == null ? null : DateFormat.yMMMMd().format(date.toDate());
  }

  static bool isTimeoutError(dynamic error) {
    if (error is TimeoutException)
      return true;
    if (error is FirebaseException)
      switch (error.code) {
        case 'unavailable':
          return true;
        default:
          return false;
      }
    return false;
  }

  static Map<String, Object> addToMap(Map<String, Object> map, String field, value) {
    if (value != null) {
      map[field] = value;
    }
    return map;
  }

  static final Duration timeoutDefault = Duration(seconds: 10);

  static final int retriesDefault = 3;

  // Modified from foundation code to compare Map trees
  static bool mapEquals(Map a, Map b) {
    if (a == null)
      return b == null;
    if (b == null || a.length != b.length)
      return false;
    if (identical(a, b))
      return true;
    for (final key in a.keys) {
      if (!b.containsKey(key))
        return false;
      if (b[key] is Map && a[key] is Map) {
        if (!mapEquals(b[key], a[key]))
          return false;
      } else if (b[key] != a[key])
        return false;
    }
    return true;
  }

}

@immutable
class Range {
  final int from;
  final int to;

  static const int MIN_FROM = 1;
  static const int MAX_TO = 10;
  static const Range RANGE_ALL = Range(MIN_FROM, MAX_TO);

  const Range(this.from, this.to);

  @override
  int get hashCode =>
      from.hashCode ^ to.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Range &&
              runtimeType == other.runtimeType &&
              from == other.from &&
              to == other.to;

  static Map rangeToMap(Range range) {
    if (range == null)
      return null;
    return {
      RANGE_FROM: range.from,
      RANGE_TO: range.to,
    };
  }

  static const RANGE_FROM = 'from';
  static const RANGE_TO = 'to';

}