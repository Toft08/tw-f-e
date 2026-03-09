/// Represents one tile on the board.
/// [id] is stable across moves so AnimatedPositioned can track and animate it.
/// [isNew] is true on the frame the tile first appears, driving its scale-in animation.
/// [isMerged] is true on the frame two tiles merge, driving its pop animation.
class Tile {
  final int id;
  final int value;
  final int row;
  final int col;
  final bool isNew;
  final bool isMerged;

  const Tile({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.isNew = false,
    this.isMerged = false,
  });

  Tile copyWith({
    int? id,
    int? value,
    int? row,
    int? col,
    bool? isNew,
    bool? isMerged,
  }) {
    return Tile(
      id: id ?? this.id,
      value: value ?? this.value,
      row: row ?? this.row,
      col: col ?? this.col,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
    );
  }
}