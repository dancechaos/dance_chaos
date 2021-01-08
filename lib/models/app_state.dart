// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/user_info.dart';
import 'package:dance_chaos/models/settings_actions.dart';
import 'package:meta/meta.dart';

import 'location_info.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Todo> todos;
  final AppTab activeTab;
  final VisibilityFilter activeFilter;
  final SettingsActions settingsActions;
  final UserInfo userInfo;
  final Profile profile;
  final LocationInfo locationInfo;

  AppState({
    this.isLoading = false,
    this.todos = const [],
    this.activeTab = AppTab.todos,
    this.activeFilter = VisibilityFilter.all,
    this.settingsActions = SettingsActions.all,
    this.userInfo = UserInfo.noUserInfo,
    this.profile = Profile.noProfile,
    this.locationInfo,
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    bool isLoading,
    List<Todo> todos,
    AppTab activeTab,
    VisibilityFilter activeFilter,
    SettingsActions settingsActions,
    UserInfo userInfo,
    Profile profile,
    LocationInfo locationInfo,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      todos: todos ?? this.todos,
      activeTab: activeTab ?? this.activeTab,
      activeFilter: activeFilter ?? this.activeFilter,
      settingsActions: settingsActions ?? this.settingsActions,
      userInfo: userInfo ?? this.userInfo,
      profile: profile ?? this.profile,
      locationInfo: locationInfo ?? this.locationInfo,
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      todos.hashCode ^
      activeTab.hashCode ^
      activeFilter.hashCode ^
      settingsActions.hashCode ^
      userInfo.hashCode ^
      profile.hashCode ^
      locationInfo.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          todos == other.todos &&
          activeTab == other.activeTab &&
          activeFilter == other.activeFilter &&
          settingsActions == other.settingsActions &&
          userInfo == other.userInfo &&
          profile == other.profile &&
          locationInfo == other.locationInfo;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, todos: $todos, activeTab: $activeTab, activeFilter: $activeFilter, settingsActions: $settingsActions, profile: $profile, userInfo: $userInfo, locationInfo: $locationInfo}';
  }
}
