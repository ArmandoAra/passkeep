import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isAuth = false;

  bool get isAuth => _isAuth;

  void login() {
    _isAuth = true;
    notifyListeners();
  }

  void logout() {
    _isAuth = false;
    notifyListeners();
  }
}
