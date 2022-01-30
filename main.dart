import 'package:flutter/material.dart';
import 'screens/LoginScreen.dart';
import 'screens/TLDRScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money',

      initialRoute: '/login',
      routes: {
        '/tldr': (context) {return const TLDRScreen();},
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}
