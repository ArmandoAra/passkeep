import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screens
import 'screens/pass_screen.dart';

//data
import 'data/data_list.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DataList()),
    ],
    child: const MyApp(),),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PassScreen(),
    );
  }
}