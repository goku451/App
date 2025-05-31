import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chats.dart';        // Chats
import 'screens/settings_screen.dart';    // Configuración y privacidad
import 'screens/account_screen.dart';     // Mi cuenta
import 'screens/edit_profile_screen.dart'; // Editar perfil
import 'screens/calendar_screen.dart';
import 'screens/institutions_screen.dart';

// Main entry point for the application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSys',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF41277A)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(title: 'SmartSys Dashboard'),
        '/settings': (context) => const SettingsScreen(),        // Configuración y privacidad
        '/account': (context) => const AccountScreen(),          // Mi cuenta
        '/edit-profile': (context) => const EditProfileScreen(), // Editar perfil
        '/chats': (context) => const ChatsScreen(),
        '/calendar': (context) => const CalendarScreen(), 
        '/institutions': (context) => const InstitutionsScreen(),
      },
    );
  }
}