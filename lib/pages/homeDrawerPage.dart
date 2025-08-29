import 'package:flutter/material.dart';
import '../routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) {
    // Remove todo o histórico e volta ao login
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirm == true) _logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final username = (args['username'] ?? 'usuário').toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: _AppDrawer(
        username: username,
        onLogout: () => _confirmLogout(context),
      ),
      body: Center(
        child: Text(
          'Olá, $username!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  const _AppDrawer({required this.username, required this.onLogout});

  String get _initials {
    final parts = username.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              accountName: Text(username),
              accountEmail: const Text(''),
              currentAccountPicture: CircleAvatar(child: Text(_initials)),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações (demo)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Cachorro'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dog);
                ScaffoldMessenger.of(context);
              },
            ),
            const Spacer(),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
