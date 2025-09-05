import 'package:flutter/material.dart';
import 'package:login/pages/settingsPage.dart';
import 'package:login/pages/userFormPage.dart';
import 'package:login/pages/userListPage.dart';
import 'package:login/services/userService.dart';
import 'routes.dart';
import 'pages/loginPage.dart';
import 'pages/homePage.dart';
//import 'pages/homeTabBarPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();

    return MaterialApp(
      title: 'Crud Users',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.login:
            return MaterialPageRoute(
              settings: const RouteSettings(name: AppRoutes.login),
              builder: (_) => const LoginPage(),
            );
          case AppRoutes.home:
            return MaterialPageRoute(
              settings: const RouteSettings(name: AppRoutes.home),
              builder: (_) => const HomePage(),
            );
          case AppRoutes.users:
            return MaterialPageRoute(
              settings: const RouteSettings(name: AppRoutes.users),
              builder: (_) => UserListPage(service: userService),
            );
          case AppRoutes.userNew:
            return MaterialPageRoute(
              settings: const RouteSettings(name: AppRoutes.userNew),
              builder: (_) => UserFormPage(service: userService),
            );
          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
  }
}
