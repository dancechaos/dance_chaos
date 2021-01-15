// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';

class ArchSampleKeys {
  // Home Screens
  static const homeScreen = Key('__homeScreen__');
  static const addTodoFab = Key('__addTodoFab__');
  static const snackbar = Key('__snackbar__');
  static Key snackbarAction(String id) => Key('__snackbar_action_${id}__');

  // Todos
  static const todoList = Key('__todoList__');
  static const todosLoading = Key('__todosLoading__');
  static final todoItem = (String id) => Key('TodoItem__$id');
  static final todoItemCheckbox =
      (String id) => Key('TodoItem__${id}__Checkbox');
  static final todoItemTask = (String id) => Key('TodoItem__${id}__Task');
  static final todoItemNote = (String id) => Key('TodoItem__${id}__Note');

  // DanceProfile
  static const danceProfileList = Key('__danceProfileList__');
  static const danceProfilesLoading = Key('__danceProfilesLoading__');
  static final danceProfileItem = (String id) => Key('DanceProfileItem__$id');
  static final danceProfileItemCheckbox = (String id) => Key('DanceProfileItem__${id}__Checkbox');
  static final danceProfileItemTask = (String id) => Key('DanceProfileItem__${id}__Task');
  static final danceProfileItemNote = (String id) => Key('DanceProfileItem__${id}__Note');

  // Tabs
  static const tabs = Key('__tabs__');
  static const todoTab = Key('__todoTab__');
  static const statsTab = Key('__statsTab__');
  static const mapsTab = Key('__mapsTab__');

  // Extra Actions
  static const extraActionsButton = Key('__extraActionsButton__');
  static const toggleAll = Key('__markAllDone__');
  static const clearCompleted = Key('__clearCompleted__');

  // Profile
  static const profileButton = Key('__profileButton__');
  static const signInProfile = Key('__signInProfile__');
  static const registerProfile = Key('__registerProfile__');
  static const signOutProfile = Key('__signOutProfile__');
  static const editProfile = Key('__editProfile__');
  // Filters
  static const trackingOff = Key('__trackingOff__');
  static const trackingWatching = Key('__trackingWatching__');
  static const trackingOn = Key('__trackingOn__');
  // Filters
  static const filterButton = Key('__filterButton__');

  // Settings
  static const settingsButton = Key('__settingsButton__');
  static const allSettings = Key('__allSettings__');
  static const activeSettings = Key('__activeSettings__');
  static const completedSettings = Key('__completedSettings__');

  // Stats
  static const statsCounter = Key('__statsCounter__');
  static const statsLoading = Key('__statsLoading__');
  static const statsNumActive = Key('__statsActiveItems__');
  static const statsNumCompleted = Key('__statsCompletedItems__');

  // Details Screen
  static const editTodoFab = Key('__editTodoFab__');
  static const deleteTodoButton = Key('__deleteTodoFab__');
  static const todoDetailsScreen = Key('__todoDetailsScreen__');
  static final detailsTodoItemCheckbox = Key('DetailsTodo__Checkbox');
  static final detailsTodoItemTask = Key('DetailsTodo__Task');
  static final detailsTodoItemNote = Key('DetailsTodo__Note');

  // Add Screen
  static const addTodoScreen = Key('__addTodoScreen__');
  static const saveNewTodo = Key('__saveNewTodo__');
  static const taskField = Key('__taskField__');
  static const noteField = Key('__noteField__');

  // Edit Screen
  static const editTodoScreen = Key('__editTodoScreen__');
  static const saveTodoFab = Key('__saveTodoFab__');
  static const registrationScreen = Key('__registrationScreen__');
  static const signInEmailField = Key('__signInEmailField__');
  static const signInPasswordField = Key('__signInPasswordField__');
  static const signInButton = Key('__signInButton__');

  static const editProfileScreen = Key('__editProfileScreen__');
  static const saveProfileFab = Key('__saveProfileFab__');
  static const saveNewProfile = Key('__saveNewProfile__');
  static const displayNameField = Key('__displayNameField__');
  static const photoUrlField = Key('__photoUrlField__');
  static const emailField = Key('__emailField__');
  static const phoneNumberField = Key('__phoneNumberField__');
  static const birthdateField = Key('__birthdateField__');
}
