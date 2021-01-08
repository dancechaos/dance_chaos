// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/reducers/loading_reducer.dart';
import 'package:dance_chaos/reducers/profile_reducer.dart';
import 'package:dance_chaos/reducers/tabs_reducer.dart';
import 'package:dance_chaos/reducers/todos_reducer.dart';
import 'package:dance_chaos/reducers/visibility_reducer.dart';
import 'package:dance_chaos/reducers/user_reducer.dart';

import 'location_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    todos: todosReducer(state.todos, action),
    activeFilter: visibilityReducer(state.activeFilter, action),
    activeTab: tabsReducer(state.activeTab, action),
    userInfo: userReducer(state.userInfo, action),
    profile: profileReducer(state.profile, action),
    locationInfo: locationReducer(state.locationInfo, action),
  );

}
