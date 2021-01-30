// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/entity/dances_entity.dart';
import 'package:dance_chaos/app/entity/user_entity.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:dance_chaos/models/settings_actions.dart';
import 'package:dance_chaos/models/visibility_filter.dart';

class ClearCompletedAction {}

class ToggleAllAction {
  ToggleAllAction();

  @override
  String toString() {
    return 'ToggleAllAction{}';
  }
}

class LoadTodosAction {
  final List<Todo> todos;

  LoadTodosAction(this.todos);

  @override
  String toString() {
    return 'LoadTodosAction{todos: $todos}';
  }
}

class UpdateTodoAction {
  final String id;
  final Todo updatedTodo;

  UpdateTodoAction(this.id, this.updatedTodo);

  @override
  String toString() {
    return 'UpdateTodoAction{id: $id, updatedTodo: $updatedTodo}';
  }
}

class DeleteTodoAction {
  final String id;

  DeleteTodoAction(this.id);

  @override
  String toString() {
    return 'DeleteTodoAction{id: $id}';
  }
}

class AddNewTodoAction {
  final Todo todo;

  AddNewTodoAction(this.todo);

  @override
  String toString() {
    return 'AddTodoAction{todo: $todo}';
  }
}

class LoadDanceProfilesAction {
  final List<DanceProfile> danceProfiles;

  LoadDanceProfilesAction(this.danceProfiles);

  @override
  String toString() {
    return 'LoadDanceProfilesAction{todos: $danceProfiles}';
  }
}

class AddDanceProfileAction {
  final String profileId;
  final DanceProfile updatedDanceProfile;

  AddDanceProfileAction(this.profileId, this.updatedDanceProfile);

  @override
  String toString() {
    return 'AddDanceProfileAction{profileId: $profileId, danceProfile: $updatedDanceProfile}';
  }
}

class UpdateDanceProfileAction {
  final String profileId;
  final DanceProfile updatedDanceProfile;

  UpdateDanceProfileAction(this.profileId, this.updatedDanceProfile);

  @override
  String toString() {
    return 'UpdateDanceProfileAction{profileId: $profileId, danceProfile: $updatedDanceProfile}';
  }
}

class ExecuteProfileAction {
  final ProfileAction profileAction;

  ExecuteProfileAction(this.profileAction);

  @override
  String toString() {
    return 'ExecuteProfileAction{profileAction: $profileAction}';
  }
}

class UpdateProfileAction {
  final Profile updatedProfile;

  UpdateProfileAction(this.updatedProfile);

  @override
  String toString() {
    return 'UpdateProfileAction{updatedProfile: $updatedProfile}';
  }
}

typedef void OnDancesUpdated(DancesEntity dancesEntity);

class UpdateDancesAction {
  final String languageCode;
  final String countryCode;
  final OnDancesUpdated onDancesUpdated;

  UpdateDancesAction(this.languageCode, this.countryCode, this.onDancesUpdated);

  @override
  String toString() {
    return 'UpdateDancesAction{}';
  }
}

class UpdateUserSignInStatusAction {
  final String id;
  final String email;
  final UserSignInStatus userSignInStatus;
  final String credential;
  final String phone;
  final int passwordHash;
  final Exception error;

  UpdateUserSignInStatusAction({this.id, this.email, this.userSignInStatus, this.error, this.credential, this.phone, this.passwordHash});

  @override
  String toString() {
    return 'UpdateUserSignInStatusAction{id: $id, email: $email, userSignInStatus: $userSignInStatus, error: $error, credential: $credential, phone: $phone}';
  }
}

class ProfileChangedAction {
  final Profile profile;

  ProfileChangedAction(this.profile);

  @override
  String toString() {
    return 'LoadProfileAction{todos: $profile}';
  }
}

class InitAppAction {
  @override
  String toString() {
    return 'InitAppAction{}';
  }
}

class UserChangedAction {
  final UserEntity userEntity;

  UserChangedAction(this.userEntity);

  @override
  String toString() {
    return 'UserChangeAction{newUserEntity: $userEntity}';
  }
}

class ChangeLocationAction {
  final Profile profile;
  final GeoPoint location;

  ChangeLocationAction(this.profile, this.location);

  @override
  String toString() {
    return 'ChangeLocationAction{profile: $profile,  geoPoint: $location}';
  }
}

class ListenForMapChangesAction {
  final Function onMapChange;

  ListenForMapChangesAction(this.onMapChange);
}

class SetRadiusAction {
  final double radiusKm;

  SetRadiusAction(this.radiusKm);
}

class SignInAction {
  final String email;
  final String password;
  final String credential;
  final String phone;

  SignInAction({this.email, this.password, this.credential, this.phone});

  @override
  String toString() {
    return 'SignInAction{}';
  }
}

class SyncProfileToUserAction {
  final UserEntity userEntity;

  SyncProfileToUserAction(this.userEntity);

  @override
  String toString() {
    return 'SyncProfileToUserAction{}';
  }
}

class ConnectToDataSourceAction {
  @override
  String toString() {
    return 'ConnectToDataSourceAction{}';
  }
}

class UpdateFilterAction {
  final VisibilityFilter newFilter;

  UpdateFilterAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateFilterAction{newFilter: $newFilter}';
  }
}

class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{newTab: $newTab}';
  }
}

class UpdateSettingsAction {
  final SettingsActions newFilter;

  UpdateSettingsAction(this.newFilter);

  @override
  String toString() {
    return 'UpdateSettingsAction{newFilter: $newFilter}';
  }
}
