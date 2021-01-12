// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';
import 'package:dance_chaos/app/entity/location_info_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationRepository {
  Future<void> updateLocation(LocationInfoEntity locationInfoEntity);
  Stream<List<LocationInfoEntity>> locationChanges(LatLng location);
}
