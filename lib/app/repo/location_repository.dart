// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import '../entity/location_info_entity.dart';

abstract class LocationRepository {
  Future<void> updateLocation(LocationInfoEntity locationInfoEntity);
}
