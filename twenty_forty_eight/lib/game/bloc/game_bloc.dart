import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';
import '../logic/board_logic.dart';
import '../logic/score_storage.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc()
      : super(
          GameState(
            board: BoardLogic.emptyBoard(),
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

    // Load persisted best score immediately on creation
    add(LoadBestScore());
  }

  Future<void> _loadBestScore(
      LoadBestScore event, Emitter<GameState> emit) async {
    final best = await ScoreStorage.loadBestScore();
    emit(state.copyWith(bestScore: best));
  }

  void _startGame(StartGame event, Emitter<GameState> emit) {
    final board = BoardLogic.emptyBoard();

    /// add starting tiles
    BoardLogic.addRandomTile(board);
    BoardLogic.addRandomTile(board);
    BoardLogic.addRandomTile(board);

    emit(
      state.copyWith(
        board: board,
        score: 0,
        gameOver: false,
      ),
    );
  }

  void _restartGame(RestartGame event, Emitter<GameState> emit) {
    add(StartGame());
  }

  /// Shared helper: apply a move result, add a tile, update scores, emit.
  /// Skips the emit entirely if the board did not change (invalid move).
  void _applyMove(Map<String, dynamic> result, Emitter<GameState> emit) {
    final List<List<int>> newBoard = result["board"];
    final int gainedScore = result["score"];

    // Check whether the board actually changed
    bool changed = false;
    outer:
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (newBoard[r][c] != state.board[r][c]) {
          changed = true;
          break outer;
        }
      }
    }
    if (!changed) return;

    BoardLogic.addRandomTile(newBoard);

    final newScore = state.score + gainedScore;
    final newBest =
        newScore > state.bestScore ? newScore : state.bestScore;
    final gameOver = BoardLogic.isGameOver(newBoard);

    // Persist the best score if it improved
    if (newBest > state.bestScore) {
      ScoreStorage.saveBestScore(newBest);
    }

    emit(state.copyWith(
      board: newBoard,
      score: newScore,
      bestScore: newBest,
      gameOver: gameOver,
    ));
  }

  void _swipeLeft(SwipeLeft event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveLeft(state.board), emit);

  void _swipeRight(SwipeRight event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveRight(state.board), emit);

  void _swipeUp(SwipeUp event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveUp(state.board), emit);

  void _swipeDown(SwipeDown event, Emitter<GameState> emit) =>
      _applyMove(BoardLogic.moveDown(state.board), emit);
}