import 'dart:convert';
import 'package:vidwath_v_book/helpers/managers/shared_preference_manager.dart';

import '../../models/auth/user.dart';

class UserManager {
  static final UserManager _sharedInsatnce = UserManager._internal();
  factory UserManager() {
    return _sharedInsatnce;
  }

  UserManager._internal();
  static UserManager get instance => _sharedInsatnce;

  Future<bool> isUserAlreadyLoggedIn() async {
    bool isUserLoggedIn = await SharedPreferenceManager().getBoolValueFor("isUserLoggedIn");
    return isUserLoggedIn;
  }

  void setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferenceManager().setBoolValue("isUserLoggedIn", isLoggedIn);
  }


  void setUser(User user) async {
    String userString = jsonEncode(user.toJson());
    SharedPreferenceManager.instance.setValue("loggedInUser", userString);
  }


  Future<void> logOutUser() async {
    SharedPreferenceManager.instance.clearDefaults();
  }

  void setToken(String id) async {
    SharedPreferenceManager.instance.setValue("id", id);
  }


  Future<String> getToken() {
    return SharedPreferenceManager.instance.getValueFor("id");
  }


}