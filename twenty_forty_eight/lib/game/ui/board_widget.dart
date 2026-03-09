import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_state.dart';
import '../bloc/game_event.dart';
import 'tile_widget.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 16,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) {
              final row = index ~/ 4;
              final col = index % 4;

              final value = state.board[row][col];

              return TileWidget(value: value);
            },
          ),
        );
      },
    );
  }
}