// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/app/core/keys.dart';
import 'package:dance_chaos_data/app/core/localization.dart';
import 'package:dance_chaos_data/app/core/routes.dart';
import 'package:dance_chaos/containers/appbar/extra_actions_container.dart';
import 'package:dance_chaos/containers/appbar/filter_selector.dart';
import 'package:dance_chaos/containers/appbar/profile_selector.dart';
import 'package:dance_chaos/containers/appbar/settings_selector.dart';
import 'package:dance_chaos/containers/tabs/active_tab.dart';
import 'package:dance_chaos/containers/tabs/maps.dart';
import 'package:dance_chaos/containers/tabs/stats.dart';
import 'package:dance_chaos/containers/tabs/tab_selector.dart';
import 'package:dance_chaos/containers/todo/filtered_todos.dart';
import 'package:dance_chaos/localization.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:flutter/material.dart';

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
