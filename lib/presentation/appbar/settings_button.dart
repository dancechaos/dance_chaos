// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/app/core/localization.dart';
import 'package:dance_chaos/models/settings_actions.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final PopupMenuItemSelected<SettingsActions> onSelected;
  final SettingsActions activeSettings;
  final bool visible;

  SettingsButton({this.onSelected, this.activeSettings, this.visible, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Theme.of(context).accentColor);
    final button = _Button(
      onSelected: onSelected,
      activeSettings: activeSettings,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: visible ? button : IgnorePointer(child: button),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.onSelected,
    @required this.activeSettings,
    @required this.activeStyle,
    @required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<SettingsActions> onSelected;
  final SettingsActions activeSettings;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SettingsActions>(
      key: ArchSampleKeys.settingsButton,
      tooltip: ArchSampleLocalizations.of(context).filterTodos,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<SettingsActions>>[
        PopupMenuItem<SettingsActions>(
          key: ArchSampleKeys.allSettings,
          value: SettingsActions.all,
          child: Text(
            ArchSampleLocalizations.of(context).trackingOff,
            style: activeSettings == SettingsActions.all
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<SettingsActions>(
          key: ArchSampleKeys.activeSettings,
          value: SettingsActions.active,
          child: Text(
            ArchSampleLocalizations.of(context).trackingWatching,
            style: activeSettings == SettingsActions.active
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<SettingsActions>(
          key: ArchSampleKeys.completedSettings,
          value: SettingsActions.completed,
          child: Text(
            ArchSampleLocalizations.of(context).trackingOn,
            style: activeSettings == SettingsActions.completed
                ? activeStyle
                : defaultStyle,
          ),
        ),
      ],
      icon: Icon(Icons.settings),
    );
  }
}
