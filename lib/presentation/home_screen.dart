// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/app/core/localization.dart';
import 'package:dance_chaos/app/core/routes.dart';
import 'file:///C:/Users/don/workspace/github/dance_chaos/lib/containers/tabs/active_tab.dart';
import 'package:dance_chaos/containers/appbar/profile_selector.dart';
import 'package:dance_chaos/containers/appbar/settings_selector.dart';
import 'package:dance_chaos/containers/map/map_screen.dart';
import 'package:dance_chaos/containers/tabs/maps.dart';
import 'file:///C:/Users/don/workspace/github/dance_chaos/lib/containers/appbar/extra_actions_container.dart';
import 'file:///C:/Users/don/workspace/github/dance_chaos/lib/containers/appbar/filter_selector.dart';
import 'file:///C:/Users/don/workspace/github/dance_chaos/lib/containers/todo/filtered_todos.dart';
import 'package:dance_chaos/containers/tabs/stats.dart';
import 'file:///C:/Users/don/workspace/github/dance_chaos/lib/containers/tabs/tab_selector.dart';
import 'package:dance_chaos/localization.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);

  @override
  Widget build(BuildContext context) {
    return ActiveTab(
      builder: (BuildContext context, AppTab activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FirestoreReduxLocalizations.of(context).appTitle),
            actions: [
              ProfileSelector(visible: true),
              FilterSelector(visible: activeTab == AppTab.todos),
              ExtraActionsContainer(),
              SettingsSelector(visible: activeTab == AppTab.todos),
            ],
          ),
          body: activeTab == AppTab.todos ? FilteredTodos() : activeTab == AppTab.stats ? Stats() : Maps(),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: TabSelector(),
        );
      },
    );
  }
}
