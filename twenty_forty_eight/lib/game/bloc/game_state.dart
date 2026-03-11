import '../models/tile.dart';

class GameState {
  final List<Tile> tiles;
  final int score;
  final int bestScore;
  final bool gameOver;
  final bool hasWon;
  final int gridSize;

  GameState({
    required this.tiles,
    required this.score,
    required this.bestScore,
    required this.gameOver,
    this.hasWon = false,
    this.gridSize = 4,
  });

  GameState copyWith({
    List<Tile>? tiles,
    int? score,
    int? bestScore,
    bool? gameOver,
    bool? hasWon,
    int? gridSize,
  }) {
    return GameState(
      tiles: tiles ?? this.tiles,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      gameOver: gameOver ?? this.gameOver,
      hasWon: hasWon ?? this.hasWon,
      gridSize: gridSize ?? this.gridSize,
    );
  }
}