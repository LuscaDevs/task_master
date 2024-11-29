import 'package:flutter/material.dart';
import 'package:task_master/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // Instância do AuthService

  bool _obscureText = true;
  bool _isLoading = false;
  String _errorMessage = '';

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Obtém os dados do TextField
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Chama o método de login do AuthService
    bool success = await _authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Redireciona o usuário após o login bem-sucedido
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/tasks-list',
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _errorMessage =
            'Falha no login. Verifique suas credenciais e tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        // Adicionado para permitir rolagem
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              ClipOval(
                child: Image.asset(
                  'assets/images/Icon.jpeg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'TaskMaster',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Text(
                'Organize sua vida, uma tarefa por vez',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFf1f4f8),
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFf1f4f8),
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Entrar',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                ),
                onPressed: () {
                  Navigator.pushNamed(context,
                      '/reset-password'); // Navega para a tela de reset
                },
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(color: Color(0xFF4B39EF)),
                ),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('Não tem uma conta? '),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/register'); // Navega para a tela de registro
                  },
                  child: const Text(
                    'Registrar',
                    style: TextStyle(color: Color(0xFF4B39EF)),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
