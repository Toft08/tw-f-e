import '../models/tile.dart';

class GameState {
  final List<Tile> tiles;
  final int score;
  final int bestScore;
  final bool gameOver;

  GameState({
    required this.tiles,
    required this.score,
    required this.bestScore,
    required this.gameOver,
  });

  GameState copyWith({
    List<Tile>? tiles,
    int? score,
    int? bestScore,
    bool? gameOver,
  }) {
    return GameState(
      tiles: tiles ?? this.tiles,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      gameOver: gameOver ?? this.gameOver,
    );
  }
}