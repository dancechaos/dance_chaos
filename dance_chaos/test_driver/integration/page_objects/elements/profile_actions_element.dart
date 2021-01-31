// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import '../screens/register_or_sign_in_screen.dart';
import 'test_element.dart';

class ProfileActionsElement extends TestElement {
  final _signInProfile = find.byValueKey('__signInProfile__');
  final _registerProfile = find.byValueKey('__registerProfile__');
  final _signOutProfile = find.byValueKey('__signOutProfile__');
  final _editProfile = find.byValueKey('__editProfile__');

  ProfileActionsElement(FlutterDriver driver) : super(driver);

  RegisterOrSignInScreen tapSignInProfile() {
    driver.tap(_signInProfile);

    return RegisterOrSignInScreen(driver);
  }


  Future<ProfileActionsElement> tapRegisterProfile() async {
    await driver.tap(_registerProfile);

    return this;
  }

  Future<ProfileActionsElement> tapSignOutProfile() async {
    await driver.tap(_signOutProfile);

    return this;
  }

  Future<ProfileActionsElement> tapEditProfile() async {
    await driver.tap(_editProfile);

    return this;
  }
}
