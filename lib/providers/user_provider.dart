import 'package:e_commerce_app_user/auth_method.dart';
import 'package:e_commerce_app_user/models/user_model.dart';

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late UserModel _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _user;
  static List<UserModel> userList = [];
  List<UserModel> get getUsers {
    return userList;
  }

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  List<UserModel> searchQuerySeller(String searchText) {
    List<UserModel> _searchList = userList
        .where(
          (element) => element.name.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return _searchList;
  }
}
