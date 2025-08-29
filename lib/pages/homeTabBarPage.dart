import 'package:flutter/material.dart';
import '../routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageCtrl = PageController();
  int _current = 0;
  late final String _username;

  final _titles = const ['Início', 'Buscar', 'Perfil'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    _username = (args['username'] ?? 'usuário').toString();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    setState(() => _current = index);
    _pageCtrl.jumpToPage(index);
  }

  void _openSettings() => Navigator.pushNamed(context, AppRoutes.settings);

  Future<void> _confirmLogout() async {
    final ok = await showDialog<bool>(
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
    if (ok == true) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_current]),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'logout') _confirmLogout();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 20,
                ),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageCtrl,
        physics:
            const NeverScrollableScrollPhysics(), // trava swipe; remova se quiser deslizar
        onPageChanged: (i) => setState(() => _current = i),
        children: [
          _HomeTab(username: _username),
          const _SearchTab(),
          const _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: _goTo,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// * --------- Abas ---------

class _HomeTab extends StatelessWidget {
  final String username;
  const _HomeTab({required this.username});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.star_border),
          title: const Text('Bem-vindo!'),
          subtitle: Text('Olá, $username — esta é a aba Início.'),
        ),
      ],
    );
  }
}

class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _doSearch() => setState(() => _query = _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Buscar',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _doSearch,
              ),
            ),
            onSubmitted: (_) => _doSearch(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _query.isEmpty
                ? const Center(child: Text('Digite para buscar...'))
                : ListView.builder(
                    itemCount: 5,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.search),
                      title: Text('Resultado ${i + 1} para "$_query"'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.person_outline, size: 72),
              SizedBox(height: 12),
              Text('Perfil do Usuário'),
              SizedBox(height: 8),
              Text('Conteúdo de exemplo da aba Perfil.'),
            ],
          ),
        ),
      ),
    );
  }
}
