// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/models/settings_actions.dart';
import 'package:redux/redux.dart';

final settingsReducer = combineReducers<SettingsActions>([
  TypedReducer<SettingsActions, UpdateSettingsAction>(_settingsActionsReducer),
]);

SettingsActions _settingsActionsReducer(
    SettingsActions activeFilter, UpdateSettingsAction action) {
  return action.newFilter;
}
