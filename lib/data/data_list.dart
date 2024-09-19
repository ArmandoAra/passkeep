import 'dart:collection';

import 'package:flutter/foundation.dart';
import '../models/service.dart';

//La clase DataList extiende de ChangeNotifier y DiagnosticableTreeMixin
class DataList with ChangeNotifier, DiagnosticableTreeMixin {
  final List<Service> _services = [];
  String _newService = '';
  String _newPass = '';
  double _strength = 8.0;

  String get newService => _newService;
  String get newPass => _newPass;
  double get strength => _strength;
  List<Service> get services => _services;
  int get servicesLength => _services.length;


  void newServiceName(String value) {
    _newService = value;
    notifyListeners();
  }

  void newPassValue(String value) {
    _newPass = value;
    notifyListeners();
  }

  void resetProvider() {
    _newService = '';
    _newPass = '';
    notifyListeners();
  }

  bool inputFilled() {
    return _newService.isNotEmpty && _newPass.length >= 8;
  }

  UnmodifiableListView<Service> get servicesUnmodifiable => UnmodifiableListView(_services);

  void addService(String newService, String newPass) {
    _services.add(Service(name: newService, password: newPass, createdAt: DateTime.now()));
    notifyListeners();
  }

  void deleteService(Service service) {
    _services.remove(service);
    notifyListeners();
  }

  void updateStrength(double value) {
    _strength = value;
    notifyListeners();
  }
  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('services', servicesLength));
  }
}


