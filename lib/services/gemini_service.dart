// services/gemini_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:runa/models/trivia_model.dart';

class GeminiService {
  static const String _defaultModel = 'gemini-1.5-flash';
  GenerativeModel? _model;
  bool _isInitialized = false;

  GeminiService() {
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    try {
      final apiKey = await _getValidApiKey();
      _model = GenerativeModel(
        model: _defaultModel,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          maxOutputTokens: 2000,
          temperature: 0.7,
        ),
      );
      _isInitialized = true;
      print("✅ Gemini inicializado correctamente");
    } catch (e) {
      print("❌ Error inicializando Gemini: $e");
      throw Exception('Error inicializando Gemini: ${e.toString()}');
    }
  }

  Future<String> _getValidApiKey() async {
    // 1. Intenta cargar variables de entorno
    try {
      if (!dotenv.isInitialized) {
        await dotenv.load(fileName: ".env");
      }
    } catch (e) {
      print("⚠️ Warning: No se pudo cargar .env: ${e.toString()}");
    }

    // 2. Verifica la key de entorno primero
    final envKey = dotenv.env['GEMINI_API_KEY'];
    if (envKey != null && envKey.isNotEmpty && envKey.startsWith('AIza')) {
      print("✅ Usando API key desde .env");
      return envKey;
    }

    // 3. Key temporal para desarrollo (REEMPLAZA ESTA)
    const tempKey = 'TU_API_KEY_AQUI'; // 🔴 COLOCA TU API KEY AQUÍ

    if (tempKey != 'TU_API_KEY_AQUI' && tempKey.startsWith('AIza')) {
      print("⚠️ Warning: Usando API key temporal de desarrollo");
      return tempKey;
    }

    throw Exception('''
🔑 API Key no configurada correctamente.

PASOS PARA SOLUCIONARLO:

1. Ve a https://makersuite.google.com/app/apikey
2. Crea una nueva API key
3. Opción A - Archivo .env (RECOMENDADO):
   - Crea archivo .env en la raíz del proyecto
   - Añade: GEMINI_API_KEY=tu_api_key_aqui
   
4. Opción B - Temporal:
   - Reemplaza 'TU_API_KEY_AQUI' con tu key real
   - en la línea 49 de este archivo

❗ NUNCA subas tu API key a repositorios públicos
''');
  }

  Future<Trivia> generateTrivia(String topic) async {
    print("🎯 Generando trivia para: $topic");

    if (!_isInitialized) {
      print("🔄 Inicializando modelo...");
      await _initializeModel();
    }

    if (_model == null) {
      throw Exception("❌ Modelo Gemini no inicializado");
    }

    final prompt = _buildTriviaPrompt(topic);
    print("📝 Prompt enviado: ${prompt.substring(0, 100)}...");

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception("Respuesta vacía de Gemini");
      }

      final responseText = _cleanGeminiResponse(response.text!);
      print("📨 Respuesta recibida: ${responseText.substring(0, 200)}...");

      final trivia = _parseTriviaResponse(responseText);
      print("✅ Trivia generada exitosamente");
      return trivia;
    } catch (e) {
      print("❌ Error completo: $e");

      // Manejo específico de errores comunes
      if (e.toString().contains('API_KEY_INVALID')) {
        throw Exception(
          '🔑 API Key inválida. Verifica tu clave en Google AI Studio.',
        );
      } else if (e.toString().contains('quota')) {
        throw Exception(
          '📊 Cuota excedida. Espera un momento e intenta de nuevo.',
        );
      } else if (e.toString().contains('network')) {
        throw Exception('🌐 Error de conexión. Verifica tu internet.');
      }

      throw Exception('Error generando trivia para "$topic": ${e.toString()}');
    }
  }

  String _buildTriviaPrompt(String topic) {
    return """
Genera EXACTAMENTE 5 preguntas de trivia sobre "$topic" para estudiantes.

FORMATO JSON ESTRICTO (sin explicaciones adicionales):

{
  "topic": "$topic",
  "questions": [
    {
      "text": "Pregunta 1 sobre $topic",
      "options": [
        {"text": "Respuesta correcta", "isCorrect": true},
        {"text": "Respuesta incorrecta 1", "isCorrect": false},
        {"text": "Respuesta incorrecta 2", "isCorrect": false},
        {"text": "Respuesta incorrecta 3", "isCorrect": false}
      ]
    }
  ]
}

REGLAS:
- Exactamente 5 preguntas
- Cada pregunta tiene 4 opciones
- Solo 1 opción correcta por pregunta
- Preguntas educativas apropiadas para estudiantes
- NO agregues texto antes o después del JSON
- Respuestas en español
""";
  }

  String _cleanGeminiResponse(String response) {
    // Limpiar múltiples formatos de respuesta
    String cleaned = response
        .replaceAll('```json', '')
        .replaceAll('```JSON', '')
        .replaceAll('```', '')
        .trim();

    // Encontrar el JSON válido si hay texto extra
    int startIndex = cleaned.indexOf('{');
    int endIndex = cleaned.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      cleaned = cleaned.substring(startIndex, endIndex + 1);
    }

    return cleaned;
  }

  Trivia _parseTriviaResponse(String jsonString) {
    try {
      print("🔍 Parseando JSON: ${jsonString.substring(0, 100)}...");
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validar estructura básica
      if (!jsonMap.containsKey('topic') || !jsonMap.containsKey('questions')) {
        throw FormatException(
          'JSON no contiene campos requeridos (topic, questions)',
        );
      }

      final trivia = Trivia.fromJson(jsonMap);
      print(
        "✅ JSON parseado correctamente - ${trivia.questions.length} preguntas",
      );
      return trivia;
    } catch (e) {
      print("❌ Error parseando JSON: $e");
      print("📄 JSON problemático: $jsonString");

      // Trivia de respaldo si falla el parsing
      return _createFallbackTrivia(jsonString);
    }
  }

  Trivia _createFallbackTrivia(String originalTopic) {
    print("🔄 Creando trivia de respaldo");
    return Trivia(
      topic: "Trivia General",
      questions: [
        TriviaQuestion(
          text: "¿Cuál es la capital de Perú?",
          options: [
            TriviaOption(text: "Lima", isCorrect: true),
            TriviaOption(text: "Cusco", isCorrect: false),
            TriviaOption(text: "Arequipa", isCorrect: false),
            TriviaOption(text: "Trujillo", isCorrect: false),
          ],
        ),
      ],
    );
  }
}
