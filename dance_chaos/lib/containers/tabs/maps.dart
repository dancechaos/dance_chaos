// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/containers/map/map_screen.dart';
import 'package:dance_chaos/models/location_info.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Maps extends StatelessWidget {
  Maps({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return FireMap(
          profile: vm.profile,
          locationInfo: vm.locationInfo,
        );
      },
    );
  }
}

class _ViewModel {
  final Profile profile;
  final LocationInfo locationInfo;

  _ViewModel({@required this.profile, @required this.locationInfo});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      profile: store.state.profile,
      locationInfo: store.state.locationInfo,
    );
  }
}
