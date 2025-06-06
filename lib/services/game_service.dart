// services/game_service.dart
class GameService {
  int _points = 0;

  void addPoints(int points) => _points += points;
  int get points => _points;

  // Futuro: Guardar en Firebase/Firestore
}
