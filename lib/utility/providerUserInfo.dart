import 'package:flutter/material.dart';
import '../models/user.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfo? _user;

  UserInfo? get user => _user;

  void setUser(UserInfo user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
