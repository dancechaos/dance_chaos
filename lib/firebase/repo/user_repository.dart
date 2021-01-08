// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/app/repo/user_entity.dart';
import 'package:dance_chaos/app/repo/user_repository.dart';
import 'package:dance_chaos/app/repo/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';

class FirebaseUserRepository implements UserRepository {
  static FirebaseAuth _auth;

  FirebaseUserRepository({FirebaseAuth auth}) {
    _auth = auth;
  }

  static FirebaseAuth auth() {
    if (_auth == null) {
      _auth = FirebaseAuth.instance;
    }
    return _auth;
  }

  int _retryCounter = 0;

  @override
  Future<void> initApp() async {
      await Firebase.initializeApp().timeout(Utility.timeoutDefault).catchError((error) {
        if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
          print('initApp Retry counter, $_retryCounter');
          return initApp();  // Retry
        }
        throw error;
      }).whenComplete(() {
        _retryCounter = 0;
        print('initApp success');
      });
  }

  @override
  Future<UserEntity> signIn({String user, String password}) async {
    UserCredential firebaseUser = user == null ? await _anonymousSignIn() :  await _signIn(user, password);
    return UserEntity(
      id: firebaseUser.user.uid,
      displayName: firebaseUser.user.displayName,
      photoUrl: firebaseUser.user.photoURL,
      phoneNumber: firebaseUser.user.phoneNumber,
      email: firebaseUser.user.email,
      isAnonymous: firebaseUser.user.isAnonymous,
      providerId:  firebaseUser.additionalUserInfo?.providerId,
    );
  }

  Future<UserCredential> _anonymousSignIn() async {
    return auth().signInAnonymously().timeout(Utility.timeoutDefault).catchError((error) {
      if ((!Utility.isTimeoutError(error)) || (_retryCounter++ >= Utility.retriesDefault))
        throw error;
      print('signInAnonymously Retry counter, $_retryCounter');
      return _anonymousSignIn();  // Retry
    }).then((firebaseUser){
      _retryCounter = 0;
      print('signInAnonymously success');
      return firebaseUser;
    });
  }

  Future<UserCredential> _signIn(String user, String password) async {
    return auth().signInWithEmailAndPassword(email: user, password: password).timeout(Utility.timeoutDefault).catchError((error) {
      if ((!Utility.isTimeoutError(error)) || (_retryCounter++ >= Utility.retriesDefault))
        throw error;
      print('_signIn Retry counter, $_retryCounter');
      return _signIn(user, password);  // Retry
    }).then((firebaseUser){
      _retryCounter = 0;
      print('signIn success');
      return firebaseUser;
    });
  }

  @override
  Stream<UserEntity> userChanges() {
    return convertUserStream(
      auth().userChanges(),
    );
  }

  // There's an easier way to do this... I just don't know how
  Stream<UserEntity> convertUserStream(Stream<User> source) async* {
    // Wait until a new chunk is available, then process it.
    await for (User user in source) {
      yield user == null ? null : UserEntity(
        id: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        email: user.email,
        isAnonymous: isUserAnonymous(user), // user.isAnonymous, Hack - isAnonymous is not correct
      );
    }
  }

  bool isUserAnonymous(User user) {
    return ((user.displayName == null || user.displayName == '')
        && (user.email == null || user.email == '')
        && (user.phoneNumber == null || user.phoneNumber == ''))
        || user.isAnonymous;
  }

  Location location;

  @override
  Future<GeoPoint> getCurrentLocation() async {
    if (location == null)
      location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    LocationData locationData = await location.getLocation();
    return GeoPoint(locationData.latitude, locationData.longitude);
  }

  @override
  Stream<GeoPoint> locationChanges() {
    return convertLocationStream(location.onLocationChanged);
  }
  // There's an easier way to do this... I just don't know how
  Stream<GeoPoint> convertLocationStream(Stream<LocationData> source) async* {
    // Wait until a new chunk is available, then process it.
    await for (LocationData locationData in source) {
      yield locationData == null ? null : GeoPoint(locationData.latitude, locationData.longitude);
    }
  }

}
