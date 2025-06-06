import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:runa/models/user_model.dart';
import 'package:runa/screens/gemini_chat_screen.dart'; // Añadido
import 'package:runa/screens/home_screen.dart';
import 'package:runa/screens/login_avatar_screen.dart';
import 'package:runa/screens/onboarding_screen.dart';
import 'package:runa/screens/trivia_game_screen.dart'; // Añadido
import 'package:runa/models/trivia_model.dart'; // Añadido

void main() async {
  //AppTheme.setSystemUIOverlayStyle(isDarkMode: true);
  // Carga las variables de entorno ANTES de iniciar la app
  await dotenv.load(
    fileName: ".env",
  ); // Asegúrate de tener el archivo .env en la raíz
  runApp(const RunaApp());
}

class RunaApp extends StatelessWidget {
  const RunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RUNA', // Cambiado a mayúsculas para consistencia
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => LoginAvatarScreen(),
        '/home': (context) => HomeScreen(
          user: ModalRoute.of(context)!.settings.arguments as User,
        ),
        '/gemini-chat': (context) => GeminiChatScreen(), // Añadido
        '/trivia': (context) => TriviaGameScreen(
          // Añadido
          trivia: ModalRoute.of(context)!.settings.arguments as Trivia,
        ),
      },
    );
  }
}
