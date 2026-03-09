import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';
import '../logic/board_logic.dart';
import '../logic/score_storage.dart';
import '../models/tile.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc()
      : super(
          GameState(
            tiles: [],
            score: 0,
            bestScore: 0,
            gameOver: false,
          ),
        ) {
    on<StartGame>(_startGame);
    on<RestartGame>(_restartGame);
    on<LoadBestScore>(_loadBestScore);

    on<SwipeLeft>(_swipeLeft);
    on<SwipeRight>(_swipeRight);
    on<SwipeUp>(_swipeUp);
    on<SwipeDown>(_swipeDown);

    // Load persisted best score, then start the game.
    add(LoadBestScore());
  }

  Future<void> _loadBestScore(
      LoadBestScore event, Emitter<GameState> emit) async {
    final best = await ScoreStorage.loadBestScore();
    emit(state.copyWith(bestScore: best));
    add(StartGame());
  }

  void _startGame(StartGame event, Emitter<GameState> emit) {
    emit(state.copyWith(
      tiles: BoardLogic.initialTiles(),
      score: 0,
      gameOver: false,
    ));
  }

  void _restartGame(RestartGame event, Emitter<GameState> emit) {
    add(StartGame());
  }

  /// Applies a MoveResult: validates the move, emits the slide immediately,
  /// then waits for the animation to finish before spawning the new tile.
  Future<void> _applyMove(
      MoveResult result, Emitter<GameState> emit) async {
    if (BoardLogic.isUnchanged(state.tiles, result.tiles)) return;

    final movedTiles = result.tiles;
    final newScore = state.score + result.score;
    final newBest = newScore > state.bestScore ? newScore : state.bestScore;

    if (newBest > state.bestScore) ScoreStorage.saveBestScore(newBest);

    // 1. Emit the slide — tiles move to their new positions.
    emit(state.copyWith(
      tiles: movedTiles,
      score: newScore,
      bestScore: newBest,
    ));

    // 2. Wait for the AnimatedPositioned transition to finish (150 ms).
    await Future.delayed(const Duration(milliseconds: 150));

    // 3. Spawn a new tile and check game-over.
    final spawnedTiles = List<Tile>.from(movedTiles);
    BoardLogic.addRandomTile(spawnedTiles);
    final gameOver = BoardLogic.isGameOver(spawnedTiles);

    emit(state.copyWith(
      tiles: spawnedTiles,
      gameOver: gameOver,
    ));
  }

  Future<void> _swipeLeft(SwipeLeft event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveLeft(state.tiles), emit);

  Future<void> _swipeRight(SwipeRight event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveRight(state.tiles), emit);

  Future<void> _swipeUp(SwipeUp event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveUp(state.tiles), emit);

  Future<void> _swipeDown(SwipeDown event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveDown(state.tiles), emit);
}