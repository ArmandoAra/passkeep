import 'dart:collection'; //UnmodifiableListView
import 'dart:convert'; //json encode and decode
import 'package:uuid/uuid.dart'; //id generator
import 'package:flutter/services.dart'; // Clipboard
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; //secure storage

import 'package:flutter/foundation.dart'; //ChangeNotifier, DiagnosticableTreeMixin
import '../models/service.dart'; //Service model

class DataList with ChangeNotifier, DiagnosticableTreeMixin {
  final _storage = const FlutterSecureStorage();
  final _uuid = const Uuid();

  bool _isPassVisible = false;

  final String _id = '';
  String _newService = '';
  String _newPass = '';
  double _strength = 8.0;

  final List<Service> _services = [];

  String get id => _id;
  String get newService => _newService;
  String get newPass => _newPass;
  double get strength => _strength;
  List<Service> get services => _services;
  int get servicesLength => _services.length;
  bool get isPassVisible => _isPassVisible;

  UnmodifiableListView<Service> get servicesUnmodifiable =>
      UnmodifiableListView(_services);

  Future<void> readData() async {
    _services.clear();
    try {
      final Map<String, String> data = await _storage.readAll();

      if (data['services'] != null) {
        final List<dynamic> servicesList = jsonDecode(data['services']!);
        for (var service in servicesList) {
          _services.add(Service(
            name: service['service'],
            id: service['id'],
            password: service['password'],
            createdAt: service['createdAt'],
          ));
        }
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> saveData(String newService, String newPass) async {
    try {
      String? storedData = await _storage.read(key: 'services');

      List<Service> services = storedData != null
          ? (jsonDecode(storedData) as List)
              .map((data) => Service.fromJson(data))
              .toList()
          : [];

      final newServiceEntry = Service(
        id: _uuid.v4(),
        name: newService,
        password: newPass,
        createdAt: DateTime.now().toString().split(' ')[0],
      );

      services.add(newServiceEntry);

      await _storage.write(
          key: 'services',
          value: jsonEncode(services.map((s) => s.toJson()).toList()));
      readData();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving the data: $e');
      }
    }
  }

  void updateServiceById(String id) async {
    try {
      int index = _services.indexWhere((service) => service.id == id);

      if (index == -1) {
        if (kDebugMode) {
          print('Error: Service id $id not found');
        }
        return;
      }

      final updatedService = Service(
        name: _newService,
        id: id,
        password: _newPass,
        createdAt: DateTime.now().toString().split(' ')[0],
      );

      _services[index] = updatedService;

      String toSave =
          jsonEncode(_services.map((service) => service.toJson()).toList());

      await _storage.write(key: 'services', value: toSave);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error to update the service: $e');
      }
    }
  }

  void newServiceName(String value) {
    _newService = value;
    notifyListeners();
  }

  void newPassValue(String value) {
    _newPass = value;
    notifyListeners();
  }

  void getServiceById(String id) async {
    try {
      Service currentService =
          _services.firstWhere((service) => service.id == id);
      _newService = currentService.name;
      _newPass = currentService.password;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
    notifyListeners();
  }

  void resetProvider() {
    _newService = '';
    _newPass = '';
    notifyListeners();
  }

  void resetServices() {
    _services.clear();
    notifyListeners();
  }

  bool inputFilled() {
    return _newService.isNotEmpty && _newPass.length >= 8;
  }

  void deleteService(String id) async {
    int index = _services.indexWhere((service) => service.id == id);
    _services.removeAt(index);
    try {
      String toSave = jsonEncode(_services
          .map((service) => {
                'id': service.id,
                'service': service.name,
                'password': service.password,
                'createdAt': service.createdAt,
              })
          .toList());
      // await _storage.write(key: 'services', value: jsonEncode(toSave));
      await _storage.write(key: 'services', value: toSave);
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }

    notifyListeners();
  }

  void updateStrength(double value) {
    _strength = value;
    notifyListeners();
  }

  Future<void> copyToClipboard(String pass) async {
    try {
      await Clipboard.setData(ClipboardData(text: pass));
    } catch (e) {
      if (kDebugMode) {
        print('Failed to copy to clipboard: $e');
      }
    }
  }

  void togglePassVisibility() {
    _isPassVisible = !_isPassVisible;
    notifyListeners();
  }
}
