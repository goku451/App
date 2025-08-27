import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chats.dart';
import 'screens/chat_user.dart';
import 'screens/settings_screen.dart';
import 'screens/account_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/institutions_screen.dart';
import 'screens/publications.dart';
import 'screens/help_screen.dart';
import 'screens/security_privacy.dart';
import 'screens/account_recover.dart';
import 'screens/ResetPasswordScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('es'); // idioma inicial
  ThemeMode _themeMode = ThemeMode.light; // tema inicial

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartSys',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF41277A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF41277A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/register': (context) => RegisterScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/login': (context) => LoginScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/home': (context) => MyHomePage(
          title: 'SmartSys Dashboard',
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/settings': (context) => SettingsScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/account': (context) => AccountScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/edit-profile': (context) => EditProfileScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/chats': (context) => ChatsScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/chat_user': (context) => ChatUser(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
          idChat: 0,
          idUsuarioEmisor: 0,
          idUsuarioReceptor: 0,
          nombreUsuarioReceptor: '',
        ),
        '/calendar': (context) => CalendarScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/institutions': (context) => InstitutionsScreen(
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/publications': (context) => PublicationsScreen(
          idPlataforma: 3,
          onLocaleChange: setLocale,
          onThemeToggle: toggleTheme,
        ),
        '/help': (context) => const HelpScreen(),
        '/security-privacy': (context) => const SecurityPrivacyScreen(),
        '/account-recover': (context) => AccountRecoverScreen(),
        '/reset-password': (context) {
          final email = ModalRoute.of(context)!.settings.arguments as String;
          return ResetPasswordScreen(correoElectronico: email);
        },
      },
    );
  }
}
