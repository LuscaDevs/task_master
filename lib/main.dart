// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:task_master/screens/auth/login_screen.dart';
import 'package:task_master/screens/auth/register_screen.dart';
import 'package:task_master/screens/auth/reset_password_screen.dart';
import 'package:task_master/screens/settings/settings_profile_screen.dart';
import 'package:task_master/screens/tasks/add_edit_task_screen.dart';
import 'package:task_master/screens/tasks/task_list_screen.dart';
import 'package:task_master/utils/theme_notifier.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'To-Do List App',
          theme: ThemeData(
            primaryColor: const Color(0xFF4B39EF),
            scaffoldBackgroundColor: const Color(0xFFf1f4f8),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B39EF),
              ),
              titleMedium: TextStyle(
                fontSize: 16,
                color: Color(0xFF57636c),
              ),
              titleSmall: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              labelSmall: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B39EF),
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: const Size(double.maxFinite, 60),
              ),
            ),
          ),
          darkTheme: ThemeData.dark(), // Defina o tema escuro
          themeMode: themeNotifier.themeMode, // Alterna entre claro e escuro
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/reset-password': (context) => ResetPasswordScreen(),
            '/tasks-list': (context) => const TaskListScreen(),
            '/tasks-add-edit': (context) => const AddEditTaskScreen(),
            '/settings-profile': (context) => const UserProfileScreen(),
          },
        );
      },
    );
  }
}
