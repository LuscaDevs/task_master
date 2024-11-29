// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Método para Login com Email e Senha
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  // Método para Registrar com Email e Senha
  Future<bool> register(
      String email, String password, String displayName) async {
    try {
      // Cria o usuário com email e senha
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Pega o usuário recém-criado
      User? user = userCredential.user;

      // Atualiza o perfil do usuário para incluir o displayName
      if (user != null) {
        await user.updateProfile(displayName: displayName);
        await user.reload(); // Recarrega os dados para aplicar a atualização
      }

      return true;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }

  // Método para Login com Google
  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // O login foi cancelado pelo usuário
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Erro no login com Google: $e');
      return false;
    }
  }

  // Método para Redefinir Senha
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Erro ao redefinir senha: $e');
      return false;
    }
  }

  // Método para Sair
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Erro ao sair: $e');
    }
  }

  // Método para Obter Usuário Atual
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
