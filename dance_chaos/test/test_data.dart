import 'package:dance_chaos/app/entity/profile_entity.dart';
import 'package:dance_chaos/app/entity/todo_entity.dart';
import 'package:dance_chaos/app/entity/user_entity.dart';
import 'package:dance_chaos/models/profile.dart';
import 'package:dance_chaos/models/todo.dart';

class TestData {
  static String email = 'don@donandann.com';
  static String password = 'password';
  static String anonProfileId = '500';
  static UserEntity anonUserEntity = UserEntity(id: anonProfileId, isAnonymous: true);
  static ProfileEntity anonProfileEntity = ProfileEntity(id: anonProfileId, isAnonymous: true);
  static String profileId = '1000';
  static UserEntity userEntity = UserEntity(id: profileId, email: TestData.email, isAnonymous: false);
  static Profile profile = Profile(profileId, email: TestData.email, isAnonymous: false);
  static ProfileEntity profileEntity = ProfileEntity(id: profileId, email: TestData.email, isAnonymous: false);
  static TodoEntity todoEntity = TodoEntity(task: 'A', id: '1', note: '2', complete: false);
  static Duration durationFiveSeconds = Duration(seconds: 5);
  static Todo todo = Todo(task: 'A', id: '1', note: '2', complete: false);
}