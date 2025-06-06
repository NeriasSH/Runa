import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:runa/models/user_model.dart';
import 'package:runa/screens/gemini_chat_screen.dart';
import 'package:runa/screens/home_screen.dart';
import 'package:runa/screens/login_avatar_screen.dart';
import 'package:runa/screens/onboarding_screen.dart';
import 'package:runa/screens/trivia_game_screen.dart';
import 'package:runa/models/trivia_model.dart';
import 'package:runa/services/permission_service.dart';

// ---
// Pantalla si no hay permisos
class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({super.key}); // Added const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber, size: 50, color: Colors.orange),
            const SizedBox(height: 20),
            const Text('Permisos insuficientes'),
            ElevatedButton(
              onPressed: () =>
                  PermissionService.showPermissionDeniedDialog(context),
              child: const Text('Solicitar permisos'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica permisos antes de iniciar
  final hasPermissions = await PermissionService.requestNetworkPermissions();

  // Carga las variables de entorno ANTES de iniciar la app
  await dotenv.load(
    fileName: ".env",
  ); // Asegúrate de tener el archivo .env en la raíz

  runApp(RunaApp(hasPermissions: hasPermissions));
}

class RunaApp extends StatelessWidget {
  final bool hasPermissions;

  const RunaApp({super.key, required this.hasPermissions});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RUNA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      // Logic to show PermissionDeniedScreen or proceed with app routes
      home: hasPermissions
          ? OnboardingScreen()
          : const PermissionDeniedScreen(),
      routes:
          hasPermissions // Only define routes if permissions are granted
          ? {
              '/onboarding': (context) => OnboardingScreen(),
              '/login': (context) => LoginAvatarScreen(),
              '/home': (context) => HomeScreen(
                user: ModalRoute.of(context)!.settings.arguments as User,
              ),
              '/gemini-chat': (context) => GeminiChatScreen(),
              '/trivia': (context) => TriviaGameScreen(
                trivia: ModalRoute.of(context)!.settings.arguments as Trivia,
              ),
            }
          : {}, // Empty routes if permissions are denied
    );
  }
}
