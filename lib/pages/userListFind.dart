import 'package:flutter/material.dart';
import 'package:login/routes.dart';
import 'package:login/services/userService.dart';
import 'package:login/widgets/appMenuDrawer.dart';
import '../models/user.dart';
import 'userFormPage.dart';

class UserListPage extends StatefulWidget {
  final UserService service;
  const UserListPage({super.key, required this.service});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<User>> _future;

  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = widget.service.getUsers();
    });
  }

  Future<void> _goToEdit(User u) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => UserFormPage(service: widget.service, initial: u),
      ),
    );
    if (changed == true) _reload();
  }

  Widget _userCard(User u) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _goToEdit(u),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'user-avatar-${u.id}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: (u.avatar.isNotEmpty)
                      ? NetworkImage(u.avatar)
                      : null,
                  child: u.avatar.isEmpty ? const Icon(Icons.person) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    u.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(u.email),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários')),
      drawer: const AppMenuDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.userNew).then((changed) {
              if (changed == true) _reload();
            }),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Novo'),
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
              onChanged: (text) => setState(() => _query = text.trim()),
              onSubmitted: (text) => setState(() => _query = text.trim()),
            ),
          ),

          // Lista
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => _reload(),
              child: FutureBuilder<List<User>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline, size: 48),
                              const SizedBox(height: 8),
                              Text('Erro ao carregar: ${snapshot.error}'),
                              const SizedBox(height: 8),
                              FilledButton.icon(
                                onPressed: _reload,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  var users = snapshot.data ?? [];

                  if (_query.isNotEmpty) {
                    users = users
                        .where(
                          (u) => u.name.toLowerCase().contains(
                            _query.toLowerCase(),
                          ),
                        )
                        .toList();
                  }

                  if (users.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 120),
                        Center(child: Text('Nenhum usuário encontrado')),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, i) => _userCard(users[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
