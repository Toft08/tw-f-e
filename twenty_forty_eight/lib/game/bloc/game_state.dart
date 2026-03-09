class GameState {
  final List<List<int>> board;
  final int score;
  final int bestScore;
  final bool gameOver;

  GameState({
    required this.board,
    required this.score,
    required this.bestScore,
    required this.gameOver,
  });

  GameState copyWith({
    List<List<int>>? board,
    int? score,
    int? bestScore,
    bool? gameOver,
  }) {
    return GameState(
      board: board ?? this.board,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      gameOver: gameOver ?? this.gameOver,
    );
  }
}