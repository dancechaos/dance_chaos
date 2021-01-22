import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/app/core/localization.dart';
import 'package:dance_chaos/containers/tabs/app_loading.dart';
import 'package:dance_chaos/models/app_state.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/presentation/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'dance_profile_item.dart';

enum PartnerRole {
  lead, follow, both
}

class DanceProfileList extends StatefulWidget {
  final List<DanceProfile> danceProfiles;
  final Function(DanceProfile, String) onCheckboxChanged;
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
  _DanceProfilePageState createState() => _DanceProfilePageState();
}

class _DanceProfilePageState extends State<DanceProfileList> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // @override
  // Widget build(BuildContext context) {
  //   return AppLoading(builder: (context, loading) {
  //     return loading
  //         ? LoadingIndicator(key: ArchSampleKeys.danceProfilesLoading)
  //         : _buildListView();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    Store store = StoreProvider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editDanceProfile),
      ),
      body: AppLoading(builder: (context, loading) {
        return loading
            ? LoadingIndicator(key: ArchSampleKeys.danceProfilesLoading)
            : _buildListView();
      }),
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

  ListView _buildListView() {
    return ListView.builder(
      key: ArchSampleKeys.danceProfileList,
      itemCount: widget.danceProfiles.length,
      itemBuilder: (BuildContext context, int index) {
        final danceProfile = widget.danceProfiles[index];

        return DanceProfileItem(
          danceProfile: danceProfile,
          onDismissed: (direction) {
            _removeDanceProfile(context, danceProfile);
          },
          onTap: () => _onDanceProfileTap(context, danceProfile),
          onCheckboxChanged: (complete) {
            widget.onCheckboxChanged(danceProfile, complete);
          },
        );
      },
    );
  }

  void _removeDanceProfile(BuildContext context, DanceProfile danceProfile) {
    widget.onRemove(danceProfile);

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
