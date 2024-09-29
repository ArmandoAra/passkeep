import 'dart:collection';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/foundation.dart';
import '../models/service.dart';

//La clase DataList extiende de ChangeNotifier y DiagnosticableTreeMixin
class DataList with ChangeNotifier, DiagnosticableTreeMixin {
  final _storage = const FlutterSecureStorage();
  final _uuid = const Uuid();

  final List<Service> _services = [];
  final String _id = '';
  String _newService = '';
  String _newPass = '';
  double _strength = 8.0;
  bool _isPassVisible = false;

  String get id => _id;
  String get newService => _newService;
  String get newPass => _newPass;
  double get strength => _strength;
  List<Service> get services => _services;
  int get servicesLength => _services.length;
  bool get isPassVisible => _isPassVisible;

  UnmodifiableListView<Service> get servicesUnmodifiable =>
      UnmodifiableListView(_services);

  Future<void> saveData(String id, String newService, String newPass) async {
    try {
      // Obtiene los datos almacenados previamente
      String? storedData = await _storage.read(key: 'services');
      List<dynamic> _services =
          storedData != null ? jsonDecode(storedData) : [];

      // Actualiza el servicio en la lista
      int index = _services.indexWhere((service) => service['id'] == id);

      if (index == -1) {
        _services.add({
          'id': _uuid.v4(),
          'service': newService,
          'password': newPass,
          'createdAt': DateTime.now().toString().split(' ')[0],
        });
      } else {
        _services[index] = {
          'id': id,
          'service': newService,
          'password': newPass,
          'createdAt': DateTime.now().toString().split(' ')[0],
        };
      }

      // Guarda nuevamente la lista completa en el almacenamiento
      await _storage.write(key: 'services', value: jsonEncode(_services));
      readData();
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }

  Future<void> readData() async {
    _services.clear();
    //remove all

    try {
      final Map<String, String> data =
          await _storage.readAll(); // Leer todos los datos
      if (data.isNotEmpty) {
        // Asumiendo que tienes una lista de servicios almacenada en una clave específica
        final String? servicesJson =
            data['services']; // Cambia 'services' a la clave adecuada
        if (servicesJson != null) {
          final List<dynamic> servicesList = jsonDecode(servicesJson);
          servicesList.forEach((service) {
            _services.add(Service(
              name: service['service'],
              id: service['id'],
              password: service['password'],
              createdAt: service['createdAt'],
            ));
          });
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteData() async {
    await _storage.deleteAll();
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
      print('Error: $e');
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

  void updateServiceById(String id) async {
    try {
      int index = _services.indexWhere((service) => service.id == id);
      _services[index] = Service(
        name: _newService,
        id: id,
        password: _newPass,
        createdAt: DateTime.now().toString().split(' ')[0],
      );
      String toSave = jsonEncode(_services
          .map((service) => {
                'id': service.id,
                'service': service.name,
                'password': service.password,
                'createdAt': service.createdAt,
              })
          .toList());
      await _storage.write(key: 'services', value: toSave);
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
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
      print('Error: $e');
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
      print('Copied to clipboard');
    } catch (e) {
      print('Failed to copy to clipboard: $e');
    }
  }

  void togglePassVisibility() {
    _isPassVisible = !_isPassVisible;
    notifyListeners();
  }
}
