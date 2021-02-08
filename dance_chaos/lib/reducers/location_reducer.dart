import 'package:dance_chaos_data/actions/actions.dart';
import 'package:dance_chaos_data/models/location_info.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final locationReducer = combineReducers<LocationInfo>([
  TypedReducer<LocationInfo, ChangeLocationAction>(_changeLocationAction),
]);

LocationInfo _changeLocationAction(LocationInfo locationInfo, ChangeLocationAction action) {
    return LocationInfo(id: action.profile.id,
        displayName: action.profile.displayName,
        location: action.location,
        timestamp: Timestamp.now(),
        danceProfile: action.profile.danceProfileMap());
}
