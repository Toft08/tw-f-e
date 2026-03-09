import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import 'tile_widget.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  /// Size of each tile in logical pixels.
  static const double tileSize = 76.0;

  /// Gap between tiles (and around the grid).
  static const double gap = 8.0;

  /// Total board width/height.
  static const double boardSize = 4 * tileSize + 5 * gap;

  static double _left(int col) => gap + col * (tileSize + gap);
  static double _top(int row) => gap + row * (tileSize + gap);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              context.read<GameBloc>().add(SwipeLeft());
            } else {
              context.read<GameBloc>().add(SwipeRight());
            }
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              context.read<GameBloc>().add(SwipeUp());
            } else {
              context.read<GameBloc>().add(SwipeDown());
            }
          },
          child: Container(
            width: boardSize,
            height: boardSize,
            decoration: BoxDecoration(
              color: const Color(0xFFBBADA0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Empty cell backgrounds
                ...List.generate(16, (i) {
                  final row = i ~/ 4;
                  final col = i % 4;
                  return Positioned(
                    left: _left(col),
                    top: _top(row),
                    width: tileSize,
                    height: tileSize,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCDC1B4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                }),

                // Tiles — keyed by stable id so AnimatedPositioned
                // interpolates each tile's position across moves.
                ...state.tiles.map((tile) {
                  return AnimatedPositioned(
                    key: ValueKey(tile.id),
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    left: _left(tile.col),
                    top: _top(tile.row),
                    width: tileSize,
                    height: tileSize,
                    child: TileWidget(
                      value: tile.value,
                      isNew: tile.isNew,
                      isMerged: tile.isMerged,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}