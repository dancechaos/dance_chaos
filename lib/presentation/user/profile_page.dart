// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/app/core/localization.dart';
import 'package:dance_chaos/app/core/routes.dart';
import 'package:dance_chaos/app/entity/utility.dart';
import 'package:dance_chaos/containers/appbar/extra_actions_container.dart';
import 'package:dance_chaos/containers/appbar/profile_selector.dart';
import 'package:dance_chaos/containers/appbar/settings_selector.dart';
import 'package:dance_chaos/containers/tabs/tab_selector.dart';
import 'package:dance_chaos/containers/todo/filtered_todos.dart';
import 'package:dance_chaos/models/app_state.dart';
import 'package:dance_chaos/models/app_tab.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../localization.dart';
import 'dance_profile_list.dart';
import 'dance_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;

  ProfilePage({Key key, this.profile})
      : super(key: key ?? ArchSampleKeys.editProfileScreen);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String _photoUrl;
  Timestamp _birthdate;
  GeoPoint _location;

  void initState() {
    super.initState();

    _displayNameController.text = widget.profile?.displayName ?? '';
    _displayNameController.addListener(() {
      Store store = StoreProvider.of<AppState>(context, listen: false);
      if ((!_displayNameController.selection.isValid)
          && (_displayNameController.text != store.state.profile.displayName)) {
        _formKey.currentState.validate(); // Display any errors
        if (_displayNameController.text != '')
          store.dispatch(UpdateProfileAction(
              Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : widget.profile.id,
              displayName: _displayNameController.text,)
          ));
      }
    });

    _emailController.text = widget.profile?.email ?? '';
    _emailController.addListener(() {
      Store store = StoreProvider.of<AppState>(context, listen: false);
      if ((!_emailController.selection.isValid)
          && (_emailController.text != store.state.profile.email))
        store.dispatch(UpdateProfileAction(
            Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : widget.profile.id,
              email: _emailController.text,
            )));
    });

    _phoneNumberController.text = widget.profile?.phoneNumber ?? '';
    _phoneNumberController.addListener(() {
      Store store = StoreProvider.of<AppState>(context, listen: false);
      if ((!_phoneNumberController.selection.isValid)
          && (_phoneNumberController.text != store.state.profile.phoneNumber))
        store.dispatch(UpdateProfileAction(
          Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : widget.profile.id,
               phoneNumber: _phoneNumberController.text,
            )));
    });

    _birthdate = widget.profile?.birthdate;
    _birthdateController.text = widget.profile?.birthdate != null ? Utility.formatDate(_birthdate) : '';
    _birthdateController.addListener(() {
      Store store = StoreProvider.of<AppState>(context, listen: false);
      if ((!_birthdateController.selection.isValid)
          && (_birthdate != store.state.profile.birthdate))
        store.dispatch(UpdateProfileAction(
            Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : widget.profile.id,
              birthdate: _birthdate,
            )));
    });

    _photoUrl = widget.profile?.photoUrl;
//    url = 'https://graph.facebook.com/511051910/picture?type=small&width=72&height=72';

    subscription = StoreProvider.of<AppState>(context, listen: false).onChange.listen(render);
  }

  StreamSubscription<AppState> subscription;

  void render(AppState state) {
    if (!_displayNameController.selection.isValid)
      _displayNameController.text = state.profile.displayName;
    if (!_emailController.selection.isValid)
      _emailController.text = state.profile.email;
    if (!_phoneNumberController.selection.isValid)
      _phoneNumberController.text = state.profile.phoneNumber;
    if (!_birthdateController.selection.isValid)
      _birthdateController.text = state.profile.birthdate != null ? Utility.formatDate(state.profile.birthdate) : '';

    _formKey.currentState.validate(); // Display any errors

    setState(() {
      // print ('id: ${store.state.profile.id}');  // Show registration controls
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    Store store = StoreProvider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.editProfile,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _displayNameController,
                key: ArchSampleKeys.displayNameField,
                // autofocus: true,
                style: textTheme.headline5,
                decoration: InputDecoration(labelText: localizations.displayNameHint),
                validator: (value) {
                  return value.trim().isEmpty
                      ? localizations.emptyProfileError
                      : null;
                },
              ),
              TextFormField(
                controller: _emailController,
                key: ArchSampleKeys.emailField,
                style: textTheme.subtitle1,
                decoration: InputDecoration(labelText: localizations.emailHint),
                validator: (value) {
                  return value.trim().isEmpty && _phoneNumberController.text.isEmpty
                      ? localizations.emptyEmailPhoneError
                      : null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                key: ArchSampleKeys.phoneNumberField,
                style: textTheme.subtitle1,
                decoration: InputDecoration(labelText: localizations.phoneNumberHint),
                validator: (value) {
                  return value.trim().isEmpty && _emailController.text.isEmpty
                      ? localizations.emptyEmailPhoneError
                      : null;
                },
              ),
              TextFormField(
                controller: _birthdateController,
                key: ArchSampleKeys.birthdateField,
                style: textTheme.subtitle1,
                decoration: InputDecoration(labelText: localizations.birthdateHint),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _birthdate != null ? _birthdate.toDate() : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2021));
                  if (picked != null && picked != _birthdate?.toDate()) {
                    setState(() {
                      _birthdate = Timestamp.fromDate(picked);
                      _birthdateController.text = Utility.formatDate(_birthdate);
                    });
                  }
                },
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return localizations.emptyBirthdateError;
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // _lights = true;
                  });
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl) : AssetImage("assets/images/person.jpg"),
                      ),
                      ElevatedButton.icon(
                        label: Text(localizations.editImage),
                        icon:  Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => ProfilePage(profile: widget.profile)));
                        },
                      ),
                    ]
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // _lights = true;
                  });
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/person.jpg"),
                      ),
                      ElevatedButton.icon(
                        label: Text(localizations.editDanceProfile),
                        icon:  Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (_) => DanceProfileList(danceProfiles: widget.profile.danceProfileList)));
                        },
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key:
            ArchSampleKeys.saveProfileFab,
        tooltip: localizations.saveChanges,
        child: Icon(Icons.arrow_back),
        onPressed: () {
            Navigator.pop(context);
          }
        // },
      ),
    );
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _birthdateController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _displayNameController.dispose();

    subscription.cancel();

    super.dispose();
  }
}
