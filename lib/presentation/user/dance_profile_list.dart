import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/containers/tabs/app_loading.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/presentation/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dance_profile_item.dart';

class DanceProfileList extends StatelessWidget {
  final List<DanceProfile> danceProfiles;
  final Function(DanceProfile, bool) onCheckboxChanged;
  final Function(DanceProfile) onRemove;
  final Function(DanceProfile) onUndoRemove;

  DanceProfileList({
    Key key,
    @required this.danceProfiles,
    @required this.onCheckboxChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLoading(builder: (context, loading) {
      return loading
          ? LoadingIndicator(key: ArchSampleKeys.danceProfilesLoading)
          : _buildListView();
    });
  }

  ListView _buildListView() {
    return ListView.builder(
      key: ArchSampleKeys.danceProfileList,
      itemCount: danceProfiles.length,
      itemBuilder: (BuildContext context, int index) {
        final danceProfile = danceProfiles[index];

        return DanceProfileItem(
          danceProfile: danceProfile,
          onDismissed: (direction) {
            _removeDanceProfile(context, danceProfile);
          },
          onTap: () => _onDanceProfileTap(context, danceProfile),
          onCheckboxChanged: (complete) {
            onCheckboxChanged(danceProfile, complete);
          },
        );
      },
    );
  }

  void _removeDanceProfile(BuildContext context, DanceProfile danceProfile) {
    onRemove(danceProfile);

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Text(
    //       ArchSampleLocalizations.of(context).danceProfileDeleted(danceProfile.task),
    //       maxLines: 1,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //     action: SnackBarAction(
    //       label: ArchSampleLocalizations.of(context).undo,
    //       onPressed: () => onUndoRemove(danceProfile),
    //     )));
  }

  void _onDanceProfileTap(BuildContext context, DanceProfile danceProfile) {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(
    //   builder: (_) => DanceProfileDetails(id: danceProfile.id),
    // ))
    //     .then((removedDanceProfile) {
    //   if (removedDanceProfile != null) {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         key: ArchSampleKeys.snackbar,
    //         duration: Duration(seconds: 2),
    //         content: Text(
    //           ArchSampleLocalizations.of(context).danceProfileDeleted(danceProfile.task),
    //           maxLines: 1,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //         action: SnackBarAction(
    //           label: ArchSampleLocalizations.of(context).undo,
    //           onPressed: () {
    //             onUndoRemove(danceProfile);
    //           },
    //         )));
    //   }
    // });
  }
}
