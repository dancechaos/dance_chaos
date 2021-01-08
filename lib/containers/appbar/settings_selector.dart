// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/models/settings_actions.dart';
import 'package:dance_chaos/presentation/appbar/settings_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SettingsSelector extends StatelessWidget {
  final bool visible;

  SettingsSelector({Key key, @required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return SettingsButton(
          visible: visible,
          activeSettings: vm.settingsActions,
          onSelected: vm.onSettingsSelected,
        );
      },
    );
  }
}

class _ViewModel {
  final Function(SettingsActions) onSettingsSelected;
  final SettingsActions settingsActions;

  _ViewModel({
    @required this.onSettingsSelected,
    @required this.settingsActions,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onSettingsSelected: (Settings) {
        store.dispatch(UpdateSettingsAction(Settings));
      },
      settingsActions: store.state.settingsActions,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          settingsActions == other.settingsActions;

  @override
  int get hashCode => settingsActions.hashCode;
}
