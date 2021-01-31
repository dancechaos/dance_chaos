// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

import '../utils.dart';
import 'test_screen.dart';

class RegisterOrSignInScreen extends TestScreen {
  final _registrationScreen = find.byValueKey('__registrationScreen__');
  // final _emailSignInButton = find.byIcon(Icons.email);
  final _emailSignInButton = find.byValueKey('Email');
  final _signInEmailField = find.byValueKey('__signInEmailField__');
  final _signInPasswordField = find.byValueKey('__signInPasswordField__');
  final _signInButton = find.byValueKey('__signInButton__');

  RegisterOrSignInScreen(FlutterDriver driver) : super(driver);

  @override
  Future<bool> isReady({Duration timeout}) =>
      widgetExists(driver, _registrationScreen, timeout: timeout);

  Future<RegisterOrSignInScreen> tapEmailSignInButton() async {
    await driver.tap(_emailSignInButton);
    return this;
  }

  Future<RegisterOrSignInScreen> enterSignInEmailField(String text) async {
    await driver.tap(_signInEmailField);
    await driver.enterText(text);
    return this;
  }

  Future<RegisterOrSignInScreen> enterSignInPasswordField(String text) async {
    await driver.tap(_signInPasswordField);
    await driver.enterText(text);
    return this;
  }

  Future<RegisterOrSignInScreen> tapSignInButton() async {
    await driver.tap(_signInButton);
    return this;
  }

}
