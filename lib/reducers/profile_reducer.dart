// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:redux/redux.dart';

final profileReducer = combineReducers<Profile>([
  TypedReducer<Profile, ProfileChangedAction>(_profileChangedAction),
  TypedReducer<Profile, ExecuteProfileAction>(_executeProfileAction),
  TypedReducer<Profile, UpdateProfileAction>(_updateProfileAction),
  TypedReducer<Profile, LoadDanceProfilesAction>(_setLoadedDanceProfiles),
]);

Profile _profileChangedAction(Profile profile, ProfileChangedAction action) {
  return action.profile ?? Profile.noProfile;
}

Profile _executeProfileAction(Profile profile, ExecuteProfileAction action) {
  TrackingState tracking = Profile.trackingActionToState(action.profileAction);
  return tracking == null ? profile : profile.copyWith(tracking: tracking);
}

Profile _updateProfileAction(Profile profile, UpdateProfileAction action) {
  return action.updatedProfile == null ? profile : profile.copyWith(
      id: action.updatedProfile.id,
      displayName: action.updatedProfile.displayName,
      photoUrl: action.updatedProfile.photoUrl,
      email: action.updatedProfile.email,
      phoneNumber: action.updatedProfile.phoneNumber,
      isAnonymous: action.updatedProfile.isAnonymous,
      birthdate: action.updatedProfile.birthdate,
      location: action.updatedProfile.homeLocation,
      tracking: action.updatedProfile.tracking,
  );
}
Profile _setLoadedDanceProfiles(Profile profile, LoadDanceProfilesAction action) {
  return action.danceProfiles == null ? profile : profile.copyWith(
    danceProfileList: action.danceProfiles,
  );
}
