import 'package:flutter/material.dart';
import 'package:login/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          // Exibe a inicial do nome do usuário, por exemplo
          child: Text(user.name.isNotEmpty ? user.name[0] : '?'),
        ),
        title: Text("teste"),
        subtitle: Text("teste@email"),
      ),
    );
  }
}
