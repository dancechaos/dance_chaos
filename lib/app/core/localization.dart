// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'localizations/messages_all.dart';

class ArchSampleLocalizations {
  ArchSampleLocalizations(this.locale);

  final Locale locale;

  static Future<ArchSampleLocalizations> load(Locale locale) {
    return initializeMessages(locale.toString()).then((_) {
      return ArchSampleLocalizations(locale);
    });
  }

  static ArchSampleLocalizations of(BuildContext context) {
    return Localizations.of<ArchSampleLocalizations>(
        context, ArchSampleLocalizations);
  }

  String get todos => Intl.message(
    'Todos',
    name: 'todos',
    args: [],
    locale: locale.toString(),
  );

  String get stats => Intl.message(
        'Stats',
        name: 'stats',
        args: [],
        locale: locale.toString(),
      );

  String get maps => Intl.message(
    'Map',
    name: 'maps',
    args: [],
    locale: locale.toString(),
  );

  String get trackingOff => Intl.message(
        'Location tracking off',
        name: 'trackingOff',
        args: [],
        locale: locale.toString(),
      );

  String get trackingWatching => Intl.message(
        'Watch only location tracking on',
        name: 'trackingWatching',
        args: [],
        locale: locale.toString(),
      );

  String get trackingOn => Intl.message(
        'Dancer location tracking on',
        name: 'trackingOn',
        args: [],
        locale: locale.toString(),
      );

  String get signInProfile => Intl.message(
    'Sign in',
    name: 'signInProfile',
    args: [],
    locale: locale.toString(),
  );

  String get registerProfile => Intl.message(
    'Register',
    name: 'registerProfile',
    args: [],
    locale: locale.toString(),
  );

  String get signOutProfile => Intl.message(
    'Sign out',
    name: 'signOutProfile',
    args: [],
    locale: locale.toString(),
  );

  String get editProfile => Intl.message(
    'Edit profile',
    name: 'editProfile',
    args: [],
    locale: locale.toString(),
  );

  String get newTodoHint => Intl.message(
        'What needs to be done?',
        name: 'newTodoHint',
        args: [],
        locale: locale.toString(),
      );

  String get markAllComplete => Intl.message(
        'Mark all complete',
        name: 'markAllComplete',
        args: [],
        locale: locale.toString(),
      );

  String get markAllIncomplete => Intl.message(
        'Mark all incomplete',
        name: 'markAllIncomplete',
        args: [],
        locale: locale.toString(),
      );

  String get clearCompleted => Intl.message(
        'Clear completed',
        name: 'clearCompleted',
        args: [],
        locale: locale.toString(),
      );

  String get addTodo => Intl.message(
        'Add Todo',
        name: 'addTodo',
        args: [],
        locale: locale.toString(),
      );

  String get editTodo => Intl.message(
        'Edit Todo',
        name: 'editTodo',
        args: [],
        locale: locale.toString(),
      );

  String get addProfile => Intl.message(
    'Add Profile',
    name: 'addProfile',
    args: [],
    locale: locale.toString(),
  );

  String get displayNameHint => Intl.message(
    'Display name',
    name: 'displayNameHint',
    args: [],
    locale: locale.toString(),
  );

  String get waitingForData => Intl.message(
    '...Waiting for data',
    name: 'waitingForData',
    args: [],
    locale: locale.toString(),
  );

  String get photoUrlHint => Intl.message(
    'Photo URL',
    name: 'photoUrlHint',
    args: [],
    locale: locale.toString(),
  );

  String get emailHint => Intl.message(
    'Email address',
    name: 'emailHint',
    args: [],
    locale: locale.toString(),
  );

  String get phoneNumberHint => Intl.message(
    'Phone number',
    name: 'phoneNumberHint',
    args: [],
    locale: locale.toString(),
  );

  String get birthdateHint => Intl.message(
    'Birthdate (Private - will not be shared or displayed)',
    name: 'birthdateHint',
    args: [],
    locale: locale.toString(),
  );

  String get gender => Intl.message(
    'Gender (Private - will not be shared or displayed)',
    name: 'gender',
    args: [],
    locale: locale.toString(),
  );

  String get male => Intl.message(
    'Male',
    name: 'male',
    args: [],
    locale: locale.toString(),
  );

  String get female => Intl.message(
    'Female',
    name: 'female',
    args: [],
    locale: locale.toString(),
  );

  String get lead => Intl.message(
    'Lead',
    name: 'lead',
    args: [],
    locale: locale.toString(),
  );

  String get follow => Intl.message(
    'Follow',
    name: 'follow',
    args: [],
    locale: locale.toString(),
  );

  String get both => Intl.message(
    'Both',
    name: 'both',
    args: [],
    locale: locale.toString(),
  );

  String get emptyBirthdateError => Intl.message(
    'Birthdate must be entered',
    name: 'emptyBirthdateError',
    args: [],
    locale: locale.toString(),
  );

  String get emptyProfileError => Intl.message(
    'Please enter some text',
    name: 'emptyProfileError',
    args: [],
    locale: locale.toString(),
  );

  String get emptyEmailPhoneError => Intl.message(
    'Both email and phone cannot be empty',
    name: 'emptyEmailPhoneError',
    args: [],
    locale: locale.toString(),
  );

  String get editImage => Intl.message(
    'Change image',
    name: 'editImage',
    args: [],
    locale: locale.toString(),
  );

  String get editDanceProfile => Intl.message(
    'Edit Dance Profile',
    name: 'editDanceProfile',
    args: [],
    locale: locale.toString(),
  );

  String get registration => Intl.message(
    'Registration',
    name: 'registration',
    args: [],
    locale: locale.toString(),
  );

  String get facebookRegistration => Intl.message(
    'Facebook sign-in',
    name: 'facebookRegistration',
    args: [],
    locale: locale.toString(),
  );

  String get googleRegistration => Intl.message(
    'Google sign-in',
    name: 'googleRegistration',
    args: [],
    locale: locale.toString(),
  );

  String get emailRegistration => Intl.message(
    'Dance Chaos Registration',
    name: 'emailRegistration',
    args: [],
    locale: locale.toString(),
  );

  String get emailSignIn => Intl.message(
    'Dance Chaos Sign In',
    name: 'emailSignIn',
    args: [],
    locale: locale.toString(),
  );

  String get registerAccount => Intl.message(
    'Register account',
    name: 'registerAccount',
    args: [],
    locale: locale.toString(),
  );

  String get signInAccount => Intl.message(
    'Sign in account',
    name: 'signInAccount',
    args: [],
    locale: locale.toString(),
  );

  String get registrationSuccessful => Intl.message(
    'Registration successful',
    name: 'registrationSuccessful',
    args: [],
    locale: locale.toString(),
  );

  String get signInSuccessful => Intl.message(
    'Sign in successful',
    name: 'signInSuccessful',
    args: [],
    locale: locale.toString(),
  );

  String get registrationFailed => Intl.message(
    'Registration failed',
    name: 'registrationFailed',
    args: [],
    locale: locale.toString(),
  );

  String get signInFailed => Intl.message(
    'Sign in failed',
    name: 'signInFailed',
    args: [],
    locale: locale.toString(),
  );

  String get email => Intl.message(
    'Email',
    name: 'email',
    args: [],
    locale: locale.toString(),
  );

  String get password => Intl.message(
    'Password',
    name: 'password',
    args: [],
    locale: locale.toString(),
  );

  String get cantBeEmpty => Intl.message(
    'Please enter some text',
    name: 'cantBeEmpty',
    args: [],
    locale: locale.toString(),
  );

  String get saveChanges => Intl.message(
        'Save changes',
        name: 'saveChanges',
        args: [],
        locale: locale.toString(),
      );

  String get filterTodos => Intl.message(
    'Filter Todos',
    name: 'filterTodos',
    args: [],
    locale: locale.toString(),
  );

  String get profile => Intl.message(
    'Profile',
    name: 'profile',
    args: [],
    locale: locale.toString(),
  );

  String get settingsTodos => Intl.message(
    'Settings Todos',
    name: 'settingsTodos',
    args: [],
    locale: locale.toString(),
  );

  String get deleteTodo => Intl.message(
        'Delete Todo',
        name: 'deleteTodo',
        args: [],
        locale: locale.toString(),
      );

  String get todoDetails => Intl.message(
        'Todo Details',
        name: 'todoDetails',
        args: [],
        locale: locale.toString(),
      );

  String get emptyTodoError => Intl.message(
        'Please enter some text',
        name: 'emptyTodoError',
        args: [],
        locale: locale.toString(),
      );

  String get notesHint => Intl.message(
        'Additional Notes...',
        name: 'notesHint',
        args: [],
        locale: locale.toString(),
      );

  String get completedTodos => Intl.message(
        'Completed Todos',
        name: 'completedTodos',
        args: [],
        locale: locale.toString(),
      );

  String get activeTodos => Intl.message(
        'Active Todos',
        name: 'activeTodos',
        args: [],
        locale: locale.toString(),
      );

  String todoDeleted(String task) => Intl.message(
        'Deleted "$task"',
        name: 'todoDeleted',
        args: [task],
        locale: locale.toString(),
      );

  String get undo => Intl.message(
        'Undo',
        name: 'undo',
        args: [],
        locale: locale.toString(),
      );

  String get deleteTodoConfirmation => Intl.message(
        'Delete this todo?',
        name: 'deleteTodoConfirmation',
        args: [],
        locale: locale.toString(),
      );

  String get delete => Intl.message(
        'Delete',
        name: 'delete',
        args: [],
        locale: locale.toString(),
      );

  String get cancel => Intl.message(
        'Cancel',
        name: 'cancel',
        args: [],
        locale: locale.toString(),
      );
}

class ArchSampleLocalizationsDelegate
    extends LocalizationsDelegate<ArchSampleLocalizations> {
  @override
  Future<ArchSampleLocalizations> load(Locale locale) =>
      ArchSampleLocalizations.load(locale);

  @override
  bool shouldReload(ArchSampleLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
