import 'package:flutter_test/flutter_test.dart';
import 'package:twenty_forty_eight/game/logic/board_logic.dart';
import 'package:twenty_forty_eight/game/models/tile.dart';

void main() {
  group('BoardLogic - Initial Setup', () {
    test('initialTiles creates 3 or 4 tiles', () {
      // Run multiple times to test randomness
      final counts = <int>{};
      for (int i = 0; i < 50; i++) {
        final tiles = BoardLogic.initialTiles(4);
        counts.add(tiles.length);
        expect(tiles.length, greaterThanOrEqualTo(3));
        expect(tiles.length, lessThanOrEqualTo(4));
      }
      // Verify we got both 3 and 4 at least once (probability check)
      expect(
        counts,
        containsAll([3, 4]),
        reason: 'Should randomly generate both 3 and 4 tiles',
      );
    });

    test('initial tiles have values 2 or 4', () {
      final tiles = BoardLogic.initialTiles(4);
      for (final tile in tiles) {
        expect([2, 4], contains(tile.value));
      }
    });

    test('initial tiles are in valid positions', () {
      final tiles = BoardLogic.initialTiles(4);
      for (final tile in tiles) {
        expect(tile.row, greaterThanOrEqualTo(0));
        expect(tile.row, lessThan(4));
        expect(tile.col, greaterThanOrEqualTo(0));
        expect(tile.col, lessThan(4));
      }
    });

    test('initial tiles occupy unique positions', () {
      final tiles = BoardLogic.initialTiles(4);
      final positions = tiles.map((t) => '${t.row},${t.col}').toSet();
      expect(
        positions.length,
        equals(tiles.length),
        reason: 'All tiles should be in unique positions',
      );
    });
  });

  group('BoardLogic - Tile Movement', () {
    test('moveLeft combines matching tiles', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 0, col: 1),
      ];
      final result = BoardLogic.moveLeft(tiles, 4);

      expect(result.tiles.length, equals(1));
      expect(result.tiles[0].value, equals(4));
      expect(result.tiles[0].col, equals(0));
      expect(result.score, equals(4));
    });

    test('moveLeft slides tiles to the left edge', () {
      final tiles = [Tile(id: 1, value: 2, row: 0, col: 2)];
      final result = BoardLogic.moveLeft(tiles, 4);

      expect(result.tiles[0].col, equals(0));
      expect(result.score, equals(0));
    });

    test('moveLeft does not combine non-adjacent tiles', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 4, row: 0, col: 1),
        Tile(id: 3, value: 2, row: 0, col: 2),
      ];
      final result = BoardLogic.moveLeft(tiles, 4);

      expect(result.tiles.length, equals(3));
      expect(result.score, equals(0));
    });

    test('moveLeft combines only one pair per move', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 0, col: 1),
        Tile(id: 3, value: 4, row: 0, col: 2),
      ];
      final result = BoardLogic.moveLeft(tiles, 4);

      expect(result.tiles.length, equals(2));
      expect(result.tiles[0].value, equals(4)); // merged
      expect(result.tiles[1].value, equals(4)); // separate
      expect(result.score, equals(4));
    });

    test('moveRight works correctly', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 0, col: 1),
      ];
      final result = BoardLogic.moveRight(tiles, 4);

      expect(result.tiles.length, equals(1));
      expect(result.tiles[0].value, equals(4));
      expect(result.tiles[0].col, equals(3)); // at the right edge
      expect(result.score, equals(4));
    });

    test('moveUp combines matching tiles', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 1, col: 0),
      ];
      final result = BoardLogic.moveUp(tiles, 4);

      expect(result.tiles.length, equals(1));
      expect(result.tiles[0].value, equals(4));
      expect(result.tiles[0].row, equals(0)); // at the top
      expect(result.score, equals(4));
    });

    test('moveDown combines matching tiles', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 1, col: 0),
      ];
      final result = BoardLogic.moveDown(tiles, 4);

      expect(result.tiles.length, equals(1));
      expect(result.tiles[0].value, equals(4));
      expect(result.tiles[0].row, equals(3)); // at the bottom
      expect(result.score, equals(4));
    });
  });

  group('BoardLogic - Score Calculation', () {
    test('score increases by merged tile value', () {
      final tiles = [
        Tile(id: 1, value: 8, row: 0, col: 0),
        Tile(id: 2, value: 8, row: 0, col: 1),
      ];
      final result = BoardLogic.moveLeft(tiles, 4);

      expect(result.score, equals(16));
      expect(result.tiles[0].value, equals(16));
    });

    test('multiple merges accumulate score', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 0, col: 1),
        Tile(id: 3, value: 4, row: 1, col: 0),
        Tile(id: 4, value: 4, row: 1, col: 1),
      ];
      final result = BoardLogic.moveLeft(tiles, 4);

      expect(result.score, equals(12)); // 4 + 8
    });
  });

  group('BoardLogic - Move Validation', () {
    test('isUnchanged detects no movement', () {
      final before = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 4, row: 0, col: 1),
      ];
      final after = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 4, row: 0, col: 1),
      ];

      expect(BoardLogic.isUnchanged(before, after), isTrue);
    });

    test('isUnchanged detects position changes', () {
      final before = [Tile(id: 1, value: 2, row: 0, col: 1)];
      final after = [Tile(id: 1, value: 2, row: 0, col: 0)];

      expect(BoardLogic.isUnchanged(before, after), isFalse);
    });

    test('isUnchanged detects value changes', () {
      final before = [Tile(id: 1, value: 2, row: 0, col: 0)];
      final after = [Tile(id: 1, value: 4, row: 0, col: 0)];

      expect(BoardLogic.isUnchanged(before, after), isFalse);
    });
  });

  group('BoardLogic - Game Over Detection', () {
    test('isGameOver returns false when board has empty cells', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 4, row: 0, col: 1),
      ];

      expect(BoardLogic.isGameOver(tiles, 4), isFalse);
    });

    test(
      'isGameOver returns false when adjacent tiles can merge horizontally',
      () {
        final tiles = [
          Tile(id: 1, value: 2, row: 0, col: 0),
          Tile(id: 2, value: 2, row: 0, col: 1),
          Tile(id: 3, value: 4, row: 0, col: 2),
          Tile(id: 4, value: 8, row: 0, col: 3),
          Tile(id: 5, value: 16, row: 1, col: 0),
          Tile(id: 6, value: 32, row: 1, col: 1),
          Tile(id: 7, value: 64, row: 1, col: 2),
          Tile(id: 8, value: 128, row: 1, col: 3),
          Tile(id: 9, value: 256, row: 2, col: 0),
          Tile(id: 10, value: 512, row: 2, col: 1),
          Tile(id: 11, value: 1024, row: 2, col: 2),
          Tile(id: 12, value: 2048, row: 2, col: 3),
          Tile(id: 13, value: 4, row: 3, col: 0),
          Tile(id: 14, value: 8, row: 3, col: 1),
          Tile(id: 15, value: 16, row: 3, col: 2),
          Tile(id: 16, value: 32, row: 3, col: 3),
        ];

        expect(BoardLogic.isGameOver(tiles, 4), isFalse);
      },
    );

    test(
      'isGameOver returns false when adjacent tiles can merge vertically',
      () {
        final tiles = [
          Tile(id: 1, value: 2, row: 0, col: 0),
          Tile(id: 2, value: 4, row: 0, col: 1),
          Tile(id: 3, value: 8, row: 0, col: 2),
          Tile(id: 4, value: 16, row: 0, col: 3),
          Tile(id: 5, value: 2, row: 1, col: 0),
          Tile(id: 6, value: 32, row: 1, col: 1),
          Tile(id: 7, value: 64, row: 1, col: 2),
          Tile(id: 8, value: 128, row: 1, col: 3),
          Tile(id: 9, value: 256, row: 2, col: 0),
          Tile(id: 10, value: 512, row: 2, col: 1),
          Tile(id: 11, value: 1024, row: 2, col: 2),
          Tile(id: 12, value: 2048, row: 2, col: 3),
          Tile(id: 13, value: 4, row: 3, col: 0),
          Tile(id: 14, value: 8, row: 3, col: 1),
          Tile(id: 15, value: 16, row: 3, col: 2),
          Tile(id: 16, value: 32, row: 3, col: 3),
        ];

        expect(BoardLogic.isGameOver(tiles, 4), isFalse);
      },
    );

    test('isGameOver returns true when no moves are possible', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 4, row: 0, col: 1),
        Tile(id: 3, value: 8, row: 0, col: 2),
        Tile(id: 4, value: 16, row: 0, col: 3),
        Tile(id: 5, value: 32, row: 1, col: 0),
        Tile(id: 6, value: 64, row: 1, col: 1),
        Tile(id: 7, value: 128, row: 1, col: 2),
        Tile(id: 8, value: 256, row: 1, col: 3),
        Tile(id: 9, value: 512, row: 2, col: 0),
        Tile(id: 10, value: 1024, row: 2, col: 1),
        Tile(id: 11, value: 2048, row: 2, col: 2),
        Tile(id: 12, value: 4, row: 2, col: 3),
        Tile(id: 13, value: 8, row: 3, col: 0),
        Tile(id: 14, value: 16, row: 3, col: 1),
        Tile(id: 15, value: 32, row: 3, col: 2),
        Tile(id: 16, value: 64, row: 3, col: 3),
      ];

      expect(BoardLogic.isGameOver(tiles, 4), isTrue);
    });
  });

  group('BoardLogic - Random Tile Generation', () {
    test('addRandomTile adds a tile to an empty spot', () {
      final tiles = <Tile>[];
      BoardLogic.addRandomTile(tiles, 4);

      expect(tiles.length, equals(1));
      expect([2, 4], contains(tiles[0].value));
    });

    test('addRandomTile does nothing when board is full', () {
      final tiles = List.generate(
        16,
        (i) => Tile(id: i, value: 2, row: i ~/ 4, col: i % 4),
      );
      final originalLength = tiles.length;

      BoardLogic.addRandomTile(tiles, 4);

      expect(tiles.length, equals(originalLength));
    });

    test('addRandomTile creates tiles with isNew flag', () {
      final tiles = <Tile>[];
      BoardLogic.addRandomTile(tiles, 4);

      expect(tiles[0].isNew, isTrue);
    });
  });

  group('BoardLogic - Different Grid Sizes', () {
    test('works with 5x5 grid', () {
      final tiles = BoardLogic.initialTiles(5);
      expect(tiles.length, greaterThanOrEqualTo(3));
      expect(tiles.length, lessThanOrEqualTo(4));

      for (final tile in tiles) {
        expect(tile.row, lessThan(5));
        expect(tile.col, lessThan(5));
      }
    });

    test('works with 6x6 grid', () {
      final tiles = BoardLogic.initialTiles(6);
      expect(tiles.length, greaterThanOrEqualTo(3));
      expect(tiles.length, lessThanOrEqualTo(4));

      for (final tile in tiles) {
        expect(tile.row, lessThan(6));
        expect(tile.col, lessThan(6));
      }
    });

    test('move operations work on different grid sizes', () {
      final tiles = [
        Tile(id: 1, value: 2, row: 0, col: 0),
        Tile(id: 2, value: 2, row: 0, col: 1),
      ];

      final result5x5 = BoardLogic.moveRight(tiles, 5);
      expect(result5x5.tiles[0].col, equals(4)); // right edge of 5x5

      final result6x6 = BoardLogic.moveRight(tiles, 6);
      expect(result6x6.tiles[0].col, equals(5)); // right edge of 6x6
    });
  });
}
