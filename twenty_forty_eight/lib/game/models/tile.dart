/* Represents one tile
  Should be immutable */
class Tile {
  final int value;
  final int row;
  final int col;

  Tile({
    required this.value,
    required this.row,
    required this.col,
  });

  Tile copyWith({
    int? value,
    int? row,
    int? col,
  }) {
    return Tile(
    value: value ?? this.value,
    row: row ?? this.row,
    col: col ?? this.col,
    );
  }
}