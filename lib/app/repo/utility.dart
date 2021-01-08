import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  static final Duration timeoutDefault = Duration(seconds: 10);

  static final int retriesDefault = 3;
}