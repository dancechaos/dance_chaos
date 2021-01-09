// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/app/repo/utility.dart';
import 'package:dance_chaos/firebase/repo/user_repository.dart';
import 'package:dance_chaos/flutter_signin_button/button_builder.dart';
import 'package:dance_chaos/flutter_signin_button/button_list.dart';
import 'package:dance_chaos/flutter_signin_button/button_view.dart';
import 'package:dance_chaos/models/app_state.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:dance_chaos/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dance_chaos/app/core/localization.dart';
import 'package:redux/redux.dart';

import 'profile_page.dart';

/// Entrypoint example for registering via Email/Password.
class RegisterOrSignInPage extends StatefulWidget {
  final AuthScreenType authScreen;

  RegisterOrSignInPage({this.authScreen = AuthScreenType.signIn, Key key})
      : super(key: key ?? ArchSampleKeys.registrationScreen);

  @override
  State<StatefulWidget> createState() => _RegisterOrSignInPageState();
}

class _RegisterOrSignInPageState extends State<RegisterOrSignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool localRegistrationVisible = false;
  bool _registeringInProcess = false;
  bool _success;
  int _retryCounter = 0;
  StreamSubscription<AppState> _userSignInStateChangeSubscription;
  UserFilter _userFilter;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.authScreen == AuthScreenType.register ? localizations.registration : localizations.signInProfile),
      ),
      body: Form(
          key: _formKey,
          child: Card(
            child: Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.FacebookNew,
                        text: localizations.facebookRegistration,
                        onPressed: () async {
                          _signInWithFacebook();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.GoogleDark,
                        text: localizations.googleRegistration,
                        onPressed: () async {
                          _signInWithGoogle();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.Email,
                        text: widget.authScreen == AuthScreenType.register ? localizations.emailRegistration : localizations.emailSignIn,
                        onPressed: () async {
                          if (!localRegistrationVisible)
                          setState(() {
                            localRegistrationVisible = true;  // Show registration controls
                          }); else {
                          if (_formKey.currentState.validate()) {
                            _register();
                          }}
                        },
                      ),
                    ),
                    localRegistrationVisible ? TextFormField(
                      key: ArchSampleKeys.signInEmailField,
                      controller: _emailController,
                      decoration: InputDecoration(labelText: localizations.email),
                      onEditingComplete: validateFormAndSignIn,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return localizations.cantBeEmpty;
                        }
                        return null;
                      },
                    ) : Container(),  // Empty if hidden
                    localRegistrationVisible ? TextFormField(
                      key: ArchSampleKeys.signInPasswordField,
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: localizations.password),
                      onEditingComplete: validateFormAndSignIn,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return localizations.cantBeEmpty;
                        }
                        return null;
                      },
                      obscureText: true,
                    ) : Container(),  // Empty if hidden,
                    localRegistrationVisible ?
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: _registeringInProcess ? CircularProgressIndicator() : SignInButtonBuilder(
                        key: ArchSampleKeys.signInButton,
                        icon: Icons.person_add,
                        backgroundColor: Colors.blueGrey,
                        onPressed: validateFormAndSignIn,
                        text: widget.authScreen == AuthScreenType.register ? localizations.registerAccount : localizations.signInAccount,
                      ),
                    ) : Container(),  // Empty if hidden,
                    Container(
                      alignment: Alignment.center,
                      child: Text(_success == null
                          ? ''
                          : (_success
                              ? widget.authScreen == AuthScreenType.register ? localizations.registrationSuccessful : localizations.signInSuccessful
                              : widget.authScreen == AuthScreenType.register ? localizations.registrationFailed : localizations.signInFailed)),
                    )
                ],
              ),
            ),
          )
      ),
    );
  }

  void validateFormAndSignIn() async {
    {
      if (_formKey.currentState.validate()) {
        setState(() {
          _registeringInProcess = true;
        });
        widget.authScreen == AuthScreenType.register ?
        _register() :
        _signIn(_emailController.text, _passwordController.text);
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _userSignInStateChangeSubscription?.cancel();
    super.dispose();
  }

  // Example code for registration.
  Future<UserCredential> _register() async {
    await FirebaseUserRepository.auth()
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ).timeout(Utility.timeoutDefault).catchError((error) {
      if ((Utility.isTimeoutError(error)) && (_retryCounter++ <= Utility.retriesDefault)) {
        print('_register Retry counter, $_retryCounter');
        return _register();  // Retry
      }
      if (error is FirebaseAuthException && error.code == 'email-already-in-use') {
        FirebaseUserRepository.auth().signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ).timeout(Utility.timeoutDefault).catchError((error) {
          // Ignore error and fall through to error logic
          // Possible that they registered with Facebook or Google
        }).then((userCredential){
          return processSuccessfulSignIn(userCredential);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to register: $error"),
      ));
      setState(() {
        _success = null;
        _registeringInProcess = false;
      });
      return null;
    }).then((userCredential){
      return processSuccessfulSignIn(userCredential);
    });
    return null;  // Never
  }

  // Example code for registration.
  Future<void> _signIn(String email, String password) async {
    Store<AppState> store = StoreProvider.of<AppState>(context, listen: false);

    _userSignInStateChangeSubscription?.cancel();
    _userFilter = UserFilter(email: email, passwordHash: password.hashCode);
    _userSignInStateChangeSubscription = store.onChange.listen(userSignInStatusChange);

    setState(() {
      _success = null;
      _registeringInProcess = true;
    });
    store.dispatch(SignInAction(email: email, password: password));
  }

  void userSignInStatusChange(AppState state) {
    if (_userFilter != null
        && _userFilter.email == state.userInfo.email
        && _userFilter.passwordHash == state.userInfo.passwordHash) {
        // && _userFilter.email == _emailController.text
        // && _userFilter.passwordHash == _passwordController.text.hashCode) {
      switch (state.userInfo.userSignInStatus) {
        case UserSignInStatus.processing:
          setState(() {
            _success = null;
            _registeringInProcess = true;
          });
          break;
        case UserSignInStatus.signedIn:
          _retryCounter = 0;
          setState(() {
            _success = true;
            _registeringInProcess = false;
          });
          _userSignInStateChangeSubscription?.cancel();
          _userSignInStateChangeSubscription = null;
          Navigator.of(context).pop(); // Back to main screen
          break;
        case UserSignInStatus.error:
          _userSignInStateChangeSubscription?.cancel();
          _userSignInStateChangeSubscription = null;
          Exception error = state.userInfo.lastError;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to sign in: $error"),
          ));
          setState(() {
            _success = null;
            _registeringInProcess = false;
          });
          break;
        default:
          break;
      }
    }
}

  UserCredential processSuccessfulSignIn(UserCredential userCredential) {
    print('SignIn success $userCredential.user');
    _retryCounter = 0;
    if (userCredential?.user != null) {
      setState(() {
        _success = true;
        _registeringInProcess = false;
      });
      Profile profile = Profile.fromUser(userCredential.user);

      // Note: You are entering the profile screen without knowing if the profile was written
      // If becomes an issue, you may want to wait for a few seconds while listening for the update to complete:
      // subscription = StoreProvider.of<AppState>(context, listen: false).onChange.listen(render);

      Navigator.of(context).pop(); // Don't come back to this sign-in screen
      if (widget.authScreen == AuthScreenType.register)
        Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (_) => ProfilePage(profile: profile)));
    } else {
      _success = false;
    }
    return userCredential;
  }

  // Example code of how to sign in with Facebook.
  Future<UserCredential> _signInWithFacebook() async {
    try {
      final AuthCredential credential = FacebookAuthProvider.credential(
        _tokenController.text,
      );
      final UserCredential userCredential = (await FirebaseUserRepository.auth().signInWithCredential(
          credential));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign In ${userCredential.user.displayName} with Facebook"),
      ));

      return processSuccessfulSignIn(userCredential);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Facebook: $e"),
      ));
      return null;
    }
  }

  //Example code of how to sign in with Google.
  Future<UserCredential> _signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential =
        await FirebaseUserRepository.auth().signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential =
        await FirebaseUserRepository.auth().signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign In ${user.displayName} with Google"),
      ));
      return processSuccessfulSignIn(userCredential);
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: $e"),
      ));
      return null;
    }
  }

}