import 'package:flutter/material.dart';
import '../widgets/appMenuDrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      drawer: const AppMenuDrawer(),
      body: const Center(
        child: Text(
          'Bem-vindo! Use o menu lateral para navegar.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
