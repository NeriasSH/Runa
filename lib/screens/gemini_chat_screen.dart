import 'package:flutter/material.dart';
import 'package:runa/models/trivia_model.dart';
import 'package:runa/screens/trivia_game_screen.dart';
import 'package:runa/services/gemini_service.dart';

class GeminiChatScreen extends StatefulWidget {
  @override
  _GeminiChatScreenState createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "¡Hola! Soy Gemini. ¿Sobre qué tema quieres jugar hoy? (Ej: Historia, Ciencia)",
    );
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: false));
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty || _isLoading) return;

    // Mensaje del usuario
    final String userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _messageController.clear();
      _isLoading = true;
    });

    try {
      // Generar trivia con Gemini
      final Trivia trivia = await _geminiService.generateTrivia(userMessage);

      // Navegar a la pantalla de trivia
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TriviaGameScreen(trivia: trivia),
        ),
      );
    } catch (e) {
      _addBotMessage("Oops, hubo un error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generar Trivia"), elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Escribe un tema...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
