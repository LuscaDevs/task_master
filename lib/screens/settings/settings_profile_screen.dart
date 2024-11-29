import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master/services/auth_service.dart';
import 'package:task_master/utils/theme_notifier.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String? _userEmail; // Variável para armazenar o email do usuário
  String? _userName; // Variável para armazenar o email do usuário
  final AuthService _authService = AuthService(); // Instância do AuthService

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // Carrega o email ao inicializar a tela
  }

  // Função para carregar o email do usuário logado
  void _loadUserEmail() {
    final user = _authService.getCurrentUser(); // Obtém o usuário logado
    setState(() {
      _userEmail = user?.email; // Atribui o email à variável
      _userName = user?.displayName; // Atribui o nome à variável
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[800] // Cor de fundo mais clara no tema escuro
          : Theme.of(context)
              .scaffoldBackgroundColor, // Usa a cor de fundo do tema

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com imagem e avatar circular
          Stack(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 160.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1434394354979-a235cd36269d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fG1vdW50YWluc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                    ), // Imagem da internet
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 30.0, // Ajusta a posição do ícone de volta
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Voltar para a tela anterior
                  },
                ),
              ),
              const Positioned(
                top: 40.0, // Posiciona o avatar
                left: 24.0,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  child: ClipOval(child: Icon(Icons.account_circle_outlined)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Espaço entre o avatar e o texto
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              _userName ?? 'Carregando nome...',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(
              _userEmail ??
                  'Carregando email...', // Mostra o email do usuário logado
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Opções da conta
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                const SectionTitle(title: 'Sua conta'),
                buildListTile(
                  context,
                  icon: Icons.account_circle_outlined,
                  title: 'Editar perfil',
                  onTap: () {
                    // Ação de editar perfil
                  },
                ),
                buildListTile(
                  context,
                  icon: Icons.notifications_none,
                  title: 'Configurações de notificação',
                  onTap: () {
                    // Ação de configurar notificações
                  },
                ),
                const SizedBox(height: 30),
                const SectionTitle(title: 'Configurações do app'),
                buildListTile(
                  context,
                  icon: Icons.sunny,
                  title: 'Alterar tema',
                  onTap: () {
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .toggleTheme();
                  },
                ),
                buildListTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Suporte',
                  onTap: () {
                    // Ação de suporte
                  },
                ),
                buildListTile(
                  context,
                  icon: Icons.privacy_tip_rounded,
                  title: 'Termos de Serviço',
                  onTap: () {
                    // Ação para abrir os termos de serviço
                  },
                ),
                const SizedBox(height: 30),
                // Botão de sair
                TextButton(
                  onPressed: () async {
                    // Chama o método de logout no AuthService
                    await _authService.logout();

                    // Navega de volta para a tela de login e remove todas as telas anteriores da pilha
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    'Sair',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir os itens da lista com ícones e textos
  Widget buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      color: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        minTileHeight: 55,
        leading: Icon(icon),
        title: Text(title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF57636c))),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
