// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DanceProfileItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final DanceProfile danceProfile;

  DanceProfileItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.danceProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.danceProfileItem(danceProfile.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: ArchSampleKeys.danceProfileItemCheckbox(danceProfile.id),
          value: true, //todo.complete,
          onChanged: onCheckboxChanged,
        ),
        title: Hero(
          tag: '${danceProfile.id}__heroTag',
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'test', //todo.task,
              key: ArchSampleKeys.danceProfileItemTask(danceProfile.id),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        subtitle: Text(
          'test', //todo.note,
          key: ArchSampleKeys.danceProfileItemNote(danceProfile.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
