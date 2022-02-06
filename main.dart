import 'dart:io';

import 'package:flutter/material.dart';
import 'screens/LoginScreen.dart';
import 'screens/TLDRScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// This is me being lazy; don't use this in production and fix certificate issues
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money',
      initialRoute: '/login',
      routes: {
        '/tldr': (context) {
          return const TLDRScreen();
        },
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

Future main() async {
// This is me being lazy; don't use this in production and fix certificate issues
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load();
  runApp(const MyApp());
}
