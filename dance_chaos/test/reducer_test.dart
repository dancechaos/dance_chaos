// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/models/models.dart';
import 'package:dance_chaos/reducers/app_state_reducer.dart';
import 'package:dance_chaos_data/selectors/selectors.dart';
import 'package:redux/redux.dart';
import 'package:test/test.dart';

void main() {
  group('State Reducer', () {
    test('should load todos into store', () {
      final todo1 = Todo(note: 'a');
      final todo2 = Todo(note: 'b');
      final todo3 = Todo(note: 'c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
      );

      expect(todosSelector(store.state), []);

      store.dispatch(LoadTodosAction(todos));

      expect(todosSelector(store.state), todos);
    });

    test('should update the VisibilityFilter', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(activeFilter: VisibilityFilter.active),
      );

      store.dispatch(UpdateFilterAction(VisibilityFilter.completed));

      expect(store.state.activeFilter, VisibilityFilter.completed);
    });

    test('should update the AppTab', () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState(activeTab: AppTab.todos),
      );

      store.dispatch(UpdateTabAction(AppTab.stats));

      expect(store.state.activeTab, AppTab.stats);
    });
  });
}
