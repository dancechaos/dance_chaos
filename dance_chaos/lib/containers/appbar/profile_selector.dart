// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/app/core/routes.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:dance_chaos_data/models/profile.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:dance_chaos/presentation/appbar/profile_button.dart';
import 'package:dance_chaos/presentation/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

class ProfileSelector extends StatelessWidget {
  final bool visible;

  ProfileSelector({Key key, @required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return ProfileButton(
          visible: visible,
          profile: vm.activeProfile,
          onSelected: (profileAction) {
            switch (profileAction) {
              case ProfileAction.editProfile:
                Navigator.pushNamed(context, ArchSampleRoutes.profile);
                break;
                // case ProfileAction.signOut:
                // Behavior is executed below in the profile action
                // break;
              case ProfileAction.signIn:
                Navigator.pushNamed(context, ArchSampleRoutes.signIn);
                break;
              case ProfileAction.register:
                Navigator.pushNamed(context, ArchSampleRoutes.register);
                break;
              default:
                vm.onProfileAction(profileAction);
            }
          },
        );
      },
    );
  }
}

// Example code of how to sign in anonymously.
void _signInAnonymously(BuildContext context) async {
  try {
    // await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.signOut();
    final User user = (await FirebaseAuth.instance.signInAnonymously()).user;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("User signed out"),
    ));

    Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => HomeScreen()));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Failed to sign in Anonymously"),
    ));
  }
}

class _ViewModel {
  final Function(ProfileAction) onProfileAction;
  final Profile activeProfile;

  _ViewModel({
    @required this.onProfileAction,
    @required this.activeProfile,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      onProfileAction: (profileAction) {
        store.dispatch(ExecuteProfileAction(profileAction));
      },
      activeProfile: store.state.profile,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeProfile == other.activeProfile;

  @override
  int get hashCode => activeProfile.hashCode;
}
