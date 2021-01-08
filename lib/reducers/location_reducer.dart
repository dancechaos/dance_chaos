import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dance_chaos/actions/actions.dart';
import 'package:dance_chaos/models/location_info.dart';
import 'package:redux/redux.dart';

final locationReducer = combineReducers<LocationInfo>([
  TypedReducer<LocationInfo, ChangeLocationAction>(_changeLocationAction),
]);

LocationInfo _changeLocationAction(LocationInfo locationInfo, ChangeLocationAction action) {
    return LocationInfo(id: action.profile.id, location: action.location);
}
