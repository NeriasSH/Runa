import 'package:flutter/material.dart';
import 'package:runa/models/user_model.dart'; // Lo crearemos después

class LoginAvatarScreen extends StatefulWidget {
  @override
  _LoginAvatarScreenState createState() => _LoginAvatarScreenState();
}

class _LoginAvatarScreenState extends State<LoginAvatarScreen> {
  final TextEditingController _usernameController = TextEditingController();
  int _selectedAvatarIndex = 0;
  final List<String> _avatars = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
    'assets/avatars/avatar6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elige tu avatar'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para el nombre
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 30),
            // Selección de avatar
            Text('Selecciona tu avatar:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: List.generate(_avatars.length, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedAvatarIndex = index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedAvatarIndex == index
                            ? Colors.blue
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(_avatars[index]),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            // Botón de confirmación
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Ingresa un nombre!')),
                  );
                  return;
                }
                final user = User(
                  name: _usernameController.text.trim(),
                  avatarPath: _avatars[_selectedAvatarIndex],
                  points: 0,
                );
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: user,
                );
              },
              child: Text('Continuar', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
