import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import 'tile_widget.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  /// Gap between tiles (and around the grid).
  static const double gap = 8.0;

  /// Margin around the board to prevent edge touching.
  static const double boardMargin = 16.0;

  /// Tile size derived from the board pixel size and grid dimension.
  static double _tileSize(double boardPixels, int gridSize) =>
      (boardPixels - (gridSize + 1) * gap) / gridSize;

  static double _left(double tileSize, int col) => gap + col * (tileSize + gap);
  static double _top(double tileSize, int row) => gap + row * (tileSize + gap);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final gridSize = state.gridSize;

        return LayoutBuilder(
          builder: (context, constraints) {
            // Use full available width minus margins for maximum responsiveness.
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 600.0; // Fallback for infinite constraints
            final boardPixels = (availableWidth - (boardMargin * 2)).clamp(
              200.0,
              double.infinity,
            );
            final tileSize = _tileSize(boardPixels, gridSize);

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
                width: boardPixels,
                height: boardPixels,
                decoration: BoxDecoration(
                  color: const Color(0xFFBBADA0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Empty cell backgrounds
                    ...List.generate(gridSize * gridSize, (i) {
                      final row = i ~/ gridSize;
                      final col = i % gridSize;
                      return Positioned(
                        left: _left(tileSize, col),
                        top: _top(tileSize, row),
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
                        left: _left(tileSize, tile.col),
                        top: _top(tileSize, tile.row),
                        width: tileSize,
                        height: tileSize,
                        child: TileWidget(
                          value: tile.value,
                          isNew: tile.isNew,
                          isMerged: tile.isMerged,
                          tileSize: tileSize,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
