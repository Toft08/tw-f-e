import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game/bloc/game_bloc.dart';
import 'game/bloc/game_event.dart';
import 'game/bloc/game_state.dart';
import 'game/ui/board_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: BlocProvider(
        create: (_) => GameBloc()..add(StartGame()),
        child: const GamePage(),
      ),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "2048",
          style: TextStyle(
            color: Color(0xFFBBADA0),
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: BlocListener<GameBloc, GameState>(
        listenWhen: (prev, curr) => !prev.gameOver && curr.gameOver,
        listener: (context, state) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("Game Over"),
              content: Text("Final score: ${state.score}"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<GameBloc>().add(RestartGame());
                  },
                  child: const Text("Play Again"),
                ),
              ],
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<GameBloc, GameState>(
                builder: (context, state) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ScoreBox(label: "SCORE", value: state.score),
                    _ScoreBox(label: "BEST", value: state.bestScore),
                    ElevatedButton(
                      onPressed: () => context.read<GameBloc>().add(RestartGame()),
                      child: const Icon(Icons.refresh_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const BoardWidget(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int value;

  const _ScoreBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFCDC1B4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12)),
          Text("$value",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}