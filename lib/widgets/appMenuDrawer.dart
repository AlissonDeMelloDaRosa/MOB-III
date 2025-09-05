import 'package:flutter/material.dart';
import '../routes.dart';

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  void _go(BuildContext context, String route) {
    final current = ModalRoute.of(context)?.settings.name;
    if (current == route) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushReplacementNamed(context, route);
  }

  void _logoff(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com título e botão de logout lado a lado
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Meu App',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () => _logoff(context),
                      tooltip: 'Sair',
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Início'),
                    selected: current == AppRoutes.home,
                    onTap: () => _go(context, AppRoutes.home),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_alt_outlined),
                    title: const Text('Usuários'),
                    selected: current == AppRoutes.users,
                    onTap: () => _go(context, AppRoutes.users),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
