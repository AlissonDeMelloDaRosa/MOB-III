import 'package:flutter/material.dart';
import 'package:login/pages/dogPage.dart';
import 'package:login/pages/settingsPage.dart';
import 'routes.dart';
import 'pages/loginPage.dart';
//import 'pages/homeDrawerPage.dart';
import 'pages/homePage.dart';
//import 'pages/homeTabBarPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.settings: (_) => const SettingsPage(),
        AppRoutes.dog: (_) => const DogPage(),
      },
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}
