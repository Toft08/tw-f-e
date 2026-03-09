import 'dart:math';
import '../models/tile.dart';

/// Result of a move: the updated tile list and score gained this move.
class MoveResult {
  final List<Tile> tiles;
  final int score;
  const MoveResult({required this.tiles, required this.score});
}

class BoardLogic {
  static const int size = 4;

  /// Auto-incrementing counter so every tile ever created has a unique id.
  static int _nextId = 0;
  static int _genId() => _nextId++;

  /// Creates the three (or four) starting tiles.
  static List<Tile> initialTiles() {
    final tiles = <Tile>[];
    addRandomTile(tiles);
    addRandomTile(tiles);
    addRandomTile(tiles);
    return tiles;
  }

  /// Adds one random tile (value 2 or 4) to an empty cell.
  static void addRandomTile(List<Tile> tiles) {
    final occupied = <String>{};
    for (final t in tiles) occupied.add('${t.row},${t.col}');

    final empty = <List<int>>[];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (!occupied.contains('$r,$c')) empty.add([r, c]);
      }
    }
    if (empty.isEmpty) return;

    final rand = Random();
    final pos = empty[rand.nextInt(empty.length)];
    tiles.add(Tile(
      id: _genId(),
      value: rand.nextBool() ? 2 : 4,
      row: pos[0],
      col: pos[1],
      isNew: true,
    ));
  }

  /// Merges a single row of tiles leftward.
  /// Returns the new tile list for that row and the score gained.
  static (List<Tile>, int) _mergeLeft(List<Tile> rowTiles) {
    // Sort by column ascending (left → right).
    final sorted = [...rowTiles]..sort((a, b) => a.col.compareTo(b.col));
    final result = <Tile>[];
    int score = 0;
    int targetCol = 0;
    int i = 0;

    while (i < sorted.length) {
      if (i + 1 < sorted.length && sorted[i].value == sorted[i + 1].value) {
        // Merge: keep the first tile's id, double its value, mark as merged.
        final merged = sorted[i].value * 2;
        score += merged;
        result.add(sorted[i].copyWith(
            value: merged, col: targetCol, isNew: false, isMerged: true));
        i += 2; // consumed two tiles
      } else {
        result.add(sorted[i].copyWith(col: targetCol, isNew: false, isMerged: false));
        i++;
      }
      targetCol++;
    }
    return (result, score);
  }

  static MoveResult moveLeft(List<Tile> tiles) {
    int score = 0;
    final result = <Tile>[];
    for (int r = 0; r < size; r++) {
      final (row, s) = _mergeLeft(tiles.where((t) => t.row == r).toList());
      result.addAll(row);
      score += s;
    }
    return MoveResult(tiles: result, score: score);
  }

  static MoveResult moveRight(List<Tile> tiles) {
    int score = 0;
    final result = <Tile>[];
    for (int r = 0; r < size; r++) {
      final rowTiles = tiles.where((t) => t.row == r).toList();
      // Mirror columns, merge left, mirror back.
      final mirrored = rowTiles.map((t) => t.copyWith(col: size - 1 - t.col)).toList();
      final (merged, s) = _mergeLeft(mirrored);
      result.addAll(merged.map((t) => t.copyWith(col: size - 1 - t.col)));
      score += s;
    }
    return MoveResult(tiles: result, score: score);
  }

  static MoveResult moveUp(List<Tile> tiles) {
    int score = 0;
    final result = <Tile>[];
    for (int c = 0; c < size; c++) {
      // Treat each column like a row: map row → col, merge left, map back.
      final colTiles = tiles.where((t) => t.col == c).toList();
      final asRow = colTiles.map((t) => t.copyWith(col: t.row)).toList();
      final (merged, s) = _mergeLeft(asRow);
      result.addAll(merged.map((t) => t.copyWith(row: t.col, col: c)));
      score += s;
    }
    return MoveResult(tiles: result, score: score);
  }

  static MoveResult moveDown(List<Tile> tiles) {
    int score = 0;
    final result = <Tile>[];
    for (int c = 0; c < size; c++) {
      final colTiles = tiles.where((t) => t.col == c).toList();
      // Mirror rows, merge left, mirror back.
      final mirrored = colTiles.map((t) => t.copyWith(col: size - 1 - t.row)).toList();
      final (merged, s) = _mergeLeft(mirrored);
      result.addAll(merged.map((t) => t.copyWith(row: size - 1 - t.col, col: c)));
      score += s;
    }
    return MoveResult(tiles: result, score: score);
  }

  /// Returns true when the move produced no change in tile positions or values.
  static bool isUnchanged(List<Tile> before, List<Tile> after) {
    if (before.length != after.length) return false;
    final beforeMap = {for (final t in before) t.id: t};
    for (final t in after) {
      final b = beforeMap[t.id];
      if (b == null || b.row != t.row || b.col != t.col || b.value != t.value) {
        return false;
      }
    }
    return true;
  }

  /// Returns true when the board has no empty cells and no adjacent equal tiles.
  static bool isGameOver(List<Tile> tiles) {
    if (tiles.length < size * size) return false;

    // Horizontal adjacency
    for (int r = 0; r < size; r++) {
      final row = tiles.where((t) => t.row == r).toList()
        ..sort((a, b) => a.col.compareTo(b.col));
      for (int i = 0; i < row.length - 1; i++) {
        if (row[i].value == row[i + 1].value) return false;
      }
    }

    // Vertical adjacency
    for (int c = 0; c < size; c++) {
      final col = tiles.where((t) => t.col == c).toList()
        ..sort((a, b) => a.row.compareTo(b.row));
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i].value == col[i + 1].value) return false;
      }
    }

    return true;
  }
}
