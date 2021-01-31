// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos_data/app/core/keys.dart';
import 'package:dance_chaos_data/app/core/localization.dart';
import 'package:dance_chaos_data/models/profile.dart';
import 'package:dance_chaos_data/models/profile_actions.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class ProfileButton extends StatelessWidget {
  final PopupMenuItemSelected<ProfileAction> onSelected;
  final Profile profile;
  final bool visible;

  ProfileButton({this.onSelected, this.profile, this.visible, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Theme.of(context).accentColor);
    final button = _Button(
      profile: profile,
      onSelected: onSelected,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle,
    );

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: visible ? button : IgnorePointer(child: button),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.onSelected,
    @required this.profile,
    @required this.activeStyle,
    @required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<ProfileAction> onSelected;
  final Profile profile;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProfileAction>(
      key: ArchSampleKeys.profileButton,
      tooltip: ArchSampleLocalizations.of(context).profile,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => getPopupItems(context, profile),
      icon: Badge(
        //badgeContent: Text('3'),
        badgeColor: profile.getTrackingColor(),
        position: BadgePosition(start: 15, bottom: 17),
        child: Icon(Icons.person),
      ),
    );
  }

  List<PopupMenuEntry<ProfileAction>> getPopupItems(BuildContext context, Profile profile) {
    List<PopupMenuEntry<ProfileAction>> items;
    if (profile.isAnonymous)
      items =  [
//        PopupMenuDivider(),
        PopupMenuItem<ProfileAction>(
          key: ArchSampleKeys.signInProfile,
          value: ProfileAction.signIn,
          child: makeRow(ArchSampleLocalizations.of(context).signInProfile, Icons.login, defaultStyle, context),
        ),
        PopupMenuItem<ProfileAction>(
          key: ArchSampleKeys.registerProfile,
          value: ProfileAction.register,
          child: makeRow(ArchSampleLocalizations.of(context).registerProfile, Icons.app_registration, defaultStyle, context),
        ),
    ];
    else
      items = [
        PopupMenuItem<ProfileAction>(
          key: ArchSampleKeys.signOutProfile,
          value: ProfileAction.signOut,
          child: makeRow(ArchSampleLocalizations.of(context).signOutProfile, Icons.logout, defaultStyle, context),
        ),
        PopupMenuItem<ProfileAction>(
          key: ArchSampleKeys.editProfile,
          value: ProfileAction.editProfile,
          child: makeRow(ArchSampleLocalizations.of(context).editProfile, Icons.edit, defaultStyle, context),
        ),
      ];
    items.addAll(addTrackingState(context, profile));
    return items;
  }

  List<PopupMenuEntry<ProfileAction>> addTrackingState(BuildContext context, Profile profile) {
    return [
      PopupMenuDivider(),
      PopupMenuItem<ProfileAction>(
        key: ArchSampleKeys.trackingOff,
        value: ProfileAction.trackingOff,
        child: makeTrackingRow(ArchSampleLocalizations.of(context).trackingOff,
            profile.getTrackingColor(tracking: TrackingState.trackingOff, isAnonymous: profile.isAnonymous),
            profile.tracking == TrackingState.trackingOff ? activeStyle : defaultStyle,
            profile.tracking == TrackingState.trackingOff,
            context),
      ),
      PopupMenuItem<ProfileAction>(
        key: ArchSampleKeys.trackingWatching,
        value: ProfileAction.trackingWatching,
        child: makeTrackingRow(ArchSampleLocalizations.of(context).trackingWatching,
            profile.getTrackingColor(tracking: TrackingState.trackingWatching, isAnonymous: profile.isAnonymous),
            profile.tracking == TrackingState.trackingWatching ? activeStyle : defaultStyle,
            profile.tracking == TrackingState.trackingWatching,
            context),
      ),
      PopupMenuItem<ProfileAction>(
        key: ArchSampleKeys.trackingOn,
        value: ProfileAction.trackingOn,
        enabled: !profile.isAnonymous,
        child: makeTrackingRow(ArchSampleLocalizations.of(context).trackingOn,
            profile.getTrackingColor(tracking: TrackingState.trackingOn, isAnonymous: profile.isAnonymous),
            profile.isAnonymous ? null : profile.tracking == TrackingState.trackingOn ? activeStyle : defaultStyle,
            profile.tracking == TrackingState.trackingOn,
            context),
        ),
    ];
  }

  Row makeRow(String title, IconData icon, TextStyle style, BuildContext context) {
    return Row(
        children: [
          Icon(
            icon,
            color: style.color,
          ),
          Text(title, style: style)]
    );
  }

  Row makeTrackingRow(String title, Color badgeColor, TextStyle style, bool selected, BuildContext context) {
    return Row(
        children: [
          Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: style == null ? null : style.color),
          Badge(
            badgeColor: badgeColor,
            position: BadgePosition(start: 15, bottom: 17),
            child: Icon(Icons.person, color: style == null ? null : style.color),
          ),
          Text(title, style: style)]
    );
  }
}
