import 'package:flutter/widgets.dart';
import 'package:drip_style/models/user_model.dart';
import 'package:drip_style/features/auth/controller/auth_controller.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthController _authMethods = AuthController();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}