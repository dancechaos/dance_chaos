import 'dart:async';

import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/app/core/keys.dart';
import 'package:dance_chaos/app/core/localization.dart';
import 'package:dance_chaos/app/entity/dances_entity.dart';
import 'package:dance_chaos/containers/tabs/app_loading.dart';
import 'package:dance_chaos/models/app_state.dart';
import 'package:dance_chaos/models/dance_profile.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/profile_actions.dart';
import 'package:dance_chaos/presentation/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:dance_chaos/app/entity/utility.dart';

import 'dance_profile_item.dart';

class DanceProfileList extends StatefulWidget {
  final Profile profile;
  final List<DanceProfile> danceProfiles;
  final Function(DanceProfile, String) onDropdownChanged;
  final Function(DanceProfile, RangeValues) onRangeChanged;
  final Function(DanceProfile, double) onLevelChanged;
  final Function(DanceProfile) onRemove;
  final Function(DanceProfile) onUndoRemove;

  DanceProfileList({
    Key key,
    @required this.profile,
    @required this.danceProfiles,
    @required this.onDropdownChanged,
    @required this.onRangeChanged,
    @required this.onLevelChanged,
    @required this.onRemove,
    @required this.onUndoRemove,
  }) : super(key: key);

  @override
  _DanceProfilePageState createState() => _DanceProfilePageState();

}

class _DanceProfilePageState extends State<DanceProfileList> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<DanceProfile> danceProfiles;

  PartnerRole _partnerRole;

  // @override
  // Widget build(BuildContext context) {
  //   return AppLoading(builder: (context, loading) {
  //     return loading
  //         ? LoadingIndicator(key: ArchSampleKeys.danceProfilesLoading)
  //         : _buildListView();
  //   });
  // }

  DancesEntity dancesEntity;

  @override
  void initState() {
    super.initState();
    Store store = StoreProvider.of<AppState>(context, listen: false);

    store.dispatch(UpdateDancesAction('en', 'US', onDancesUpdated));  // todo(don) i18n

    _partnerRole = store.state.profile.partnerRole;
    if (_partnerRole == null)
      _partnerRole = store.state.profile.gender == Gender.male ? PartnerRole.lead
        : store.state.profile.gender == Gender.female ? PartnerRole.follow : null;

    danceProfiles = widget.profile.danceProfileList;

    subscription = StoreProvider.of<AppState>(context, listen: false).onChange.listen(render);
  }

  StreamSubscription<AppState> subscription;

  @override
  void dispose() {
    // Clean up
    subscription.cancel();

    super.dispose();
  }

  void render(AppState appState) {
    if (danceProfiles.length != appState.profile.danceProfileList.length) {
      setState(() {
        danceProfiles = appState.profile.danceProfileList;
        // widget.danceProfiles = appState.profile.danceProfileList;
        // print ('id: ${store.state.profile.id}');  // Show registration controls
      });
    }
  }

  void dropdownChange(Profile profile, DanceProfile danceProfile, String code) {
    print('profile:  $danceProfile, code: $code');
  }

  void rangeChange(Profile profile, DanceProfile danceProfile,
      RangeValues rangeValues) {
    print('profile:  $danceProfile, rangeValues: $rangeValues');
    // widget.onRangeChanged(danceProfile, values);
    // setState(() {
    // _currentRangeValues = values;
    // });
  }

  onDancesUpdated(DancesEntity dancesEntity) {
//    final localizations = ArchSampleLocalizations.of(context);  // Note: I'm note sure why I can't call this here
    setState(() {
      if (dancesEntity.dances[''] == null) {  // Note: This should exist in the list (this code is here for safety)
        dancesEntity.dances[''] = '---Select Dance Style---';//localizations.selectDance;
      }
      this.dancesEntity = dancesEntity;
    });
  }

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

  Widget _buildListView() {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    Store store = StoreProvider.of<AppState>(context, listen: false);
    final Map<dynamic, dynamic> menuItemsMapLoading = {
      '': localizations.loading,
    };

    return
      ListView(
        children: <Widget>[

          Row(
            children: <Widget>[
              Flexible(child:
                ListTile(
                  horizontalTitleGap: 0,  //ListTileTheme.horizontalTitleGap,
                  title: Text(localizations.lead),
                  leading: Radio(
                    value: PartnerRole.lead,
                    groupValue: _partnerRole,
                    onChanged: (value) {
                      setState(() {
                        store.dispatch(UpdateProfileAction(
                            Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : store.state.profile.id,
                              partnerRole: _partnerRole = PartnerRole.lead,
                            )));
                      });
                    },
                  ),
                ),
              ),
              Flexible(
                child:  ListTile(
                  horizontalTitleGap: 0,  //ListTileTheme.horizontalTitleGap,
                  title: Text(localizations.follow),
                  leading: Radio(
                    value: PartnerRole.follow,
                    groupValue: _partnerRole,
                    onChanged: (value) {
                      setState(() {
                        store.dispatch(UpdateProfileAction(
                            Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : store.state.profile.id,
                              partnerRole: _partnerRole = PartnerRole.follow,
                            )));
                      });
                    },
                  ),
                ),
              ),
              Flexible(child:
              ListTile(
                horizontalTitleGap: 0,  //ListTileTheme.horizontalTitleGap,
                title: Text(localizations.both),
                leading: Radio(
                  value: PartnerRole.both,
                  groupValue: _partnerRole,
                  onChanged: (value) {
                    setState(() {
                      store.dispatch(UpdateProfileAction(
                          Profile(store.state.profile.id != Profile.noProfile.id ? store.state.profile.id : store.state.profile.id,
                            partnerRole: _partnerRole = PartnerRole.both,
                          )));
                    });
                  },
                ),
              ),
              ),
            ],
          ),

          ListView.builder(
            key: ArchSampleKeys.danceProfileList,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: danceProfiles.length,
            itemBuilder: (BuildContext context, int index) {
              final profile = widget.profile;
              final danceProfile = danceProfiles[index];

              return DanceProfileItem(
                key: ArchSampleKeys.danceProfileItemWidget(danceProfile.id),
                profile: profile,
                danceProfile: danceProfile,
                onDismissed: (direction) {
                  store.dispatch(DeleteDanceProfileAction(profile.id, [danceProfile.id]));
                },
                onTap: () => _onDanceProfileTap(context, danceProfile),
                onDropdownChanged: (danceCode) {
                  DanceProfile changedDanceProfile = danceProfile.copyWith(danceCode: danceCode);
                  store.dispatch(UpdateDanceProfileAction(profile.id, changedDanceProfile));
                },
                onRangeChanged: (rangeValues) {
                  DanceProfile changedDanceProfile = danceProfile.copyWith(range: Range(rangeValues.start.round().toInt(), rangeValues.end.round().toInt()));
                  store.dispatch(UpdateDanceProfileAction(profile.id, changedDanceProfile));
                },
                onLevelChanged: (level) {
                  DanceProfile changedDanceProfile = danceProfile.copyWith(level: level.round().toInt());
                  store.dispatch(UpdateDanceProfileAction(profile.id, changedDanceProfile));
                },
                menuItemsMap: dancesEntity?.dances ?? menuItemsMapLoading,
              );
            },
          ),

          ListView.builder(
            key: ArchSampleKeys.danceProfileAdd,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              final danceProfile = DanceProfile(id: '', danceCode: '');

              return DanceProfileItem(
                key: ArchSampleKeys.danceProfileItemWidget(DanceProfileItem.NO_DANCE_CODE),
                danceProfile: danceProfile,
                onDismissed: (direction) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Can't delete an empty item"),
                  ));
                },
                onTap: () => _onDanceProfileTap(context, danceProfile),
                onDropdownChanged: (danceCode) {
                  DanceProfile changedDanceProfile = DanceProfile(danceCode: danceCode);
                  store.dispatch(AddDanceProfileAction(widget.profile.id, changedDanceProfile));
                },
                onRangeChanged: (rangeValues) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Select dance before entering range"),
                  ));
                },
                onLevelChanged: (level) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Select dance before entering level"),
                  ));
                },
                menuItemsMap: dancesEntity?.dances ?? menuItemsMapLoading,
              );
            },
          ),


        ]
    );
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
