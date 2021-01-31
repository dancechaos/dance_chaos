import 'package:dance_chaos/actions/actions.dart';
import 'package:redux/redux.dart';
import 'package:dance_chaos/models/user_info.dart';

final userReducer = combineReducers<UserInfo>([
  TypedReducer<UserInfo, UpdateUserSignInStatusAction>(_updateUserSignInStatusAction),
]);

UserInfo _updateUserSignInStatusAction(UserInfo userInfo, UpdateUserSignInStatusAction action) {
  return UserInfo == null ? userInfo : userInfo.copyWith(
    id: action.id,
    email: action.email,
    userSignInStatus: action.userSignInStatus,
    credential: action.credential,
    phone: action.phone,
    passwordHash: action.passwordHash,
    lastError: action.error,
  );
}
