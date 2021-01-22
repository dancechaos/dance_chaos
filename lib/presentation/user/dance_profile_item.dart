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
  final ValueChanged<String> onCheckboxChanged;
  final DanceProfile danceProfile;

  DanceProfileItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.danceProfile,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    String danceCode = danceProfile.danceCode;
    if (menuItemsMap[danceProfile.danceCode] == null) {
      danceCode = '';
    }

    return Dismissible(
      key: ArchSampleKeys.danceProfileItem(danceProfile.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: DropdownButton<String>(
          value: danceCode,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: textTheme.headline5,
          underline: Container(
            height: 2,
            color: textTheme.headline5.decorationColor,
          ),
          onChanged: onCheckboxChanged,
          items: dropdownMenuItems(),
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

  List<DropdownMenuItem<String>> dropdownMenuItems() {
    List<DropdownMenuItem<String>> dropdownMenuItems = List.empty(growable: true);
    menuItemsMap.forEach((key, value) {
      dropdownMenuItems.add(DropdownMenuItem(
        value: key,
        child: Text(value)
      ));
    });
    return dropdownMenuItems;
  }

  final Map<String, String> menuItemsMap = {
    '': '---Select Dance Style---',
    'IC': 'Cha Cha - International',
    'IW': 'Waltz - International',
    'AC': 'Cha Cha - American',
    'AW': 'Waltz - American',
  };
}
