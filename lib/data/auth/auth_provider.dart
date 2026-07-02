import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _currentUser;

  String? get currentUser => _currentUser;

  void login(String username) {
    _currentUser = username;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}