// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos_data/app/entity/profile_entity.dart';
import 'package:dance_chaos_data/app/entity/todo_entity.dart';
import 'package:dance_chaos_data/app/entity/user_entity.dart';
import 'package:dance_chaos_data/firebase/repo/reactive_todos_repository.dart';
import 'package:dance_chaos_data/firebase/repo/firestore_profile_repository.dart';
import 'package:dance_chaos_data/firebase/repo/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('FirebaseUserRepository', () {
    test('should log the user in anonymously', () async {
      final auth = MockFirebaseAuth();
      final repository = FirestoreUserRepository(auth: auth);

      when(auth.signInAnonymously())
          .thenAnswer((_) => Future.value(MockAuthResult()));

      final entity = await repository.signIn();

      expect(entity, TypeMatcher<UserEntity>());
    });
  });

  group('FirebaseReactiveTodosRepository', () {
    test('should send todos to firestore', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final profileRepo = FirestoreProfileRepository(firestore: firestore);
      final profile = ProfileEntity(id: '1000', displayName: 'Test User');
      final repository = FirestoreReactiveTodosRepository();
      final todo = TodoEntity(task: 'A', id: '1', note: '', complete: true);

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.doc(todo.id)).thenReturn(document);

      repository.addNewTodo(profile.id, todo);

      verify(document.set(todo.toJson()));
    });

    test('should update todos on firestore', () {
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final document = MockDocumentReference();
      final profileRepo = FirestoreProfileRepository(firestore: firestore);
      final profile = ProfileEntity(id: '1000', displayName: 'Test User');
      final repository = FirestoreReactiveTodosRepository();
      final todo = TodoEntity(task: 'A', id: '1', note: '', complete: true);

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.doc(todo.id)).thenReturn(document);

      repository.updateTodo(profile.id, todo);

      verify(document.update(todo.toJson()));
    });

    test('should listen for updates to the collection', () {
      final todo = TodoEntity(task: 'A', id: '1', note: '', complete: true);
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final snapshot = MockQuerySnapshot();
      final snapshots = Stream.fromIterable([snapshot]);
      final document = MockDocumentSnapshot(todo.toJson());
      final profileRepo = FirestoreProfileRepository(firestore: firestore);
      final profile = ProfileEntity(id: '1000', displayName: 'Test User');
      final repository = FirestoreReactiveTodosRepository();

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.snapshots()).thenAnswer((_) => snapshots);
      when(snapshot.docs).thenReturn([document]);
      when(document.id).thenReturn(todo.id);

      expect(repository.todos(profile.id), emits([todo]));
    });

    test('should delete todos on firestore', () async {
      final todoA = 'A';
      final todoB = 'B';
      final firestore = MockFirestore();
      final collection = MockCollectionReference();
      final documentA = MockDocumentReference();
      final documentB = MockDocumentReference();
      final profileRepo = FirestoreProfileRepository(firestore: firestore);
      final profile = ProfileEntity(id: '1000', displayName: 'Test User');
      final repository = FirestoreReactiveTodosRepository();

      when(firestore.collection(FirestoreReactiveTodosRepository.path))
          .thenReturn(collection);
      when(collection.doc(todoA)).thenReturn(documentA);
      when(collection.doc(todoB)).thenReturn(documentB);
      when(documentA.delete()).thenAnswer((_) => Future.value());
      when(documentB.delete()).thenAnswer((_) => Future.value());

      await repository.deleteTodo(profile.id, [todoA, todoB]);

      verify(documentA.delete());
      verify(documentB.delete());
    });
  });
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentSnapshot extends Mock implements QueryDocumentSnapshot {
  final Map<String, dynamic> _data;

  MockDocumentSnapshot([this._data]);

  @override
  Map<String, dynamic> data() {
    return _data;
  }

  @override
  dynamic operator [](dynamic key) => _data[key];
}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockAuthResult extends Mock implements UserCredential {
  @override
  final user = MockFirebaseUser();
}

class MockFirebaseUser extends Mock implements User {}
