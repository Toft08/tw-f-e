import 'dart:math';

class BoardLogic {
  static const int size = 4;

  // create empty board
  static List<List<int>> emptyBoard() {
    return List.generate(size, (_) => List.generate(size, (_) => 0));
  }

  static void addRandomTile(List<List<int>> board) {
    List<List<int>> empty = [];

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (board[r][c] == 0) {
          empty.add([r, c]);
        }
      }
    }

    if (empty.isEmpty) return;

    final rand = Random();
    final pos = empty[rand.nextInt(empty.length)];

    board[pos[0]][pos[1]] = rand.nextBool() ? 2 : 4;
  }

  /// Handles merging for a single row when swiping left.
  /// Returns the updated row and score gained.
  static Map<String, dynamic> mergeRow(List<int> row) {
    int scoreGained = 0;

    /// Step 1: remove empty cells
    List<int> newRow = row.where((value) => value != 0).toList();

    /// Step 2: merge equal adjacent tiles (left to right)
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        scoreGained += newRow[i];
        newRow.removeAt(i + 1);
      }
    }

    /// Step 3: pad with zeros on the right
    while (newRow.length < size) {
      newRow.add(0);
    }

    return {"row": newRow, "score": scoreGained};
  }

  static List<int> reverse(List<int> row) => row.reversed.toList();

  static List<List<int>> transpose(List<List<int>> board) {
    List<List<int>> newBoard =
        List.generate(size, (_) => List.generate(size, (_) => 0));
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        newBoard[c][r] = board[r][c];
      }
    }
    return newBoard;
  }

  static Map<String, dynamic> moveLeft(List<List<int>> board) {
    int score = 0;
    List<List<int>> newBoard = [];
    for (var row in board) {
      var result = mergeRow(row);
      newBoard.add(result["row"] as List<int>);
      score += result["score"] as int;
    }
    return {"board": newBoard, "score": score};
  }

  static Map<String, dynamic> moveRight(List<List<int>> board) {
    int score = 0;
    List<List<int>> newBoard = [];
    for (var row in board) {
      var result = mergeRow(reverse(row));
      newBoard.add(reverse(result["row"] as List<int>));
      score += result["score"] as int;
    }
    return {"board": newBoard, "score": score};
  }

  /// Transpose → moveLeft → transpose back.
  static Map<String, dynamic> moveUp(List<List<int>> board) {
    final t = transpose(board);
    final result = moveLeft(t);
    return {"board": transpose(result["board"]), "score": result["score"]};
  }

  /// Transpose → moveRight → transpose back.
  static Map<String, dynamic> moveDown(List<List<int>> board) {
    final t = transpose(board);
    final result = moveRight(t);
    return {"board": transpose(result["board"]), "score": result["score"]};
  }

  /// Returns true when no empty cells remain and no adjacent tiles can merge.
  static bool isGameOver(List<List<int>> board) {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (board[r][c] == 0) return false;
      }
    }
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size - 1; c++) {
        if (board[r][c] == board[r][c + 1]) return false;
      }
    }
    for (int c = 0; c < size; c++) {
      for (int r = 0; r < size - 1; r++) {
        if (board[r][c] == board[r + 1][c]) return false;
      }
    }
    return true;
  }
}