import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screens
import 'screens/pass_screen.dart';
import 'screens/root_screen.dart';

//providers
import 'providers/data_list.dart';
import 'providers/auth.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => DataList()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RootScreen.id,
      routes: {
        RootScreen.id: (context) => const RootScreen(),
        PassScreen.id: (context) => const PassScreen(),
      },
    );
  }
}
