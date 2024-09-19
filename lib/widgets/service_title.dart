import 'package:flutter/material.dart';

class ServiceTitle extends StatelessWidget {

  final String serviceName;
  final String password;
  final DateTime createdAt;
  // Hacer que copie el password al portapapeles
  final Function onLongPress;


  const ServiceTitle({
    super.key,
    required this.serviceName,
    required this.password,
    required this.createdAt,
    required this.onLongPress,
  });


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        onLongPress();
      },
      title: Text(
        serviceName,
      ),
      subtitle: Text(
        password,
      ),
      trailing: Text(
        createdAt.toString(),
      ),
    );
  }
}