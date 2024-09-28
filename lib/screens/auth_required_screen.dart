import 'package:flutter/material.dart';

class AuthRequiredScreen extends StatelessWidget {
  static const String id = 'auth_required';
  const AuthRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You need to be authenticated to access this app',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
