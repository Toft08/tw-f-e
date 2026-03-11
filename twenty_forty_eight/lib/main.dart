import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game/bloc/game_bloc.dart';
import 'game/bloc/game_event.dart';
import 'game/bloc/game_state.dart';
import 'game/ui/board_widget.dart';
import 'responsive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: BlocProvider(create: (_) => GameBloc(), child: const GamePage()),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "2048",
          style: TextStyle(
            color: const Color(0xFFBBADA0),
            fontSize: r.titleSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: BlocListener<GameBloc, GameState>(
        listenWhen: (prev, curr) =>
            (!prev.gameOver && curr.gameOver) || (!prev.hasWon && curr.hasWon),
        listener: (context, state) {
          if (state.hasWon && !state.gameOver) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: Text(
                  "🎉 You Win!",
                  style: TextStyle(fontSize: r.dialogTitleSize),
                ),
                content: Text(
                  "You reached 2048!\nScore: ${state.score}",
                  style: TextStyle(fontSize: r.dialogContentSize),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Keep Playing"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<GameBloc>().add(RestartGame());
                    },
                    child: const Text("New Game"),
                  ),
                ],
              ),
            );
          } else if (state.gameOver) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: Text(
                  "Game Over",
                  style: TextStyle(fontSize: r.dialogTitleSize),
                ),
                content: Text(
                  "Final score: ${state.score}",
                  style: TextStyle(fontSize: r.dialogContentSize),
                ),
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
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    kToolbarHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<GameBloc, GameState>(
                    builder: (context, state) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ScoreBox(
                          label: "SCORE",
                          value: state.score,
                          responsive: r,
                        ),
                        _ScoreBox(
                          label: "BEST ${state.gridSize}×${state.gridSize}",
                          value: state.bestScore,
                          responsive: r,
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<GameBloc>().add(RestartGame()),
                          child: Icon(Icons.refresh_outlined, size: r.iconSize),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: r.largeSpacing),
                  BlocBuilder<GameBloc, GameState>(
                    builder: (context, state) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [4, 5, 6].map((size) {
                        final active = state.gridSize == size;
                        return Padding(
                          padding: r.buttonPadding,
                          child: FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              backgroundColor: active
                                  ? const Color(0xFFBBADA0)
                                  : const Color(0xFFEDE0D4),
                              foregroundColor: active
                                  ? Colors.white
                                  : const Color(0xFF776E65),
                              textStyle: TextStyle(fontSize: r.buttonTextSize),
                            ),
                            onPressed: active
                                ? null
                                : () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                          'Switch grid size?',
                                          style: TextStyle(
                                            fontSize: r.dialogTitleSize,
                                          ),
                                        ),
                                        content: Text(
                                          'Your current game will be lost.\nSwitch to $size×$size?',
                                          style: TextStyle(
                                            fontSize: r.dialogContentSize,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              context,
                                            ).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Switch'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmed == true && context.mounted) {
                                      context.read<GameBloc>().add(
                                        ChangeGridSize(size),
                                      );
                                    }
                                  },
                            child: Text('$size×$size'),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: r.mediumSpacing),
                  const BoardWidget(),
                  SizedBox(height: r.largeSpacing),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreBox extends StatelessWidget {
  final String label;
  final int value;
  final Responsive responsive;

  const _ScoreBox({
    required this.label,
    required this.value,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    final r = responsive;
    return Container(
      padding: r.scoreBoxPadding,
      decoration: BoxDecoration(
        color: const Color(0xFFCDC1B4),
        borderRadius: BorderRadius.circular(r.mediumRadius),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: r.scoreLabelSize,
            ),
          ),
          Text(
            "$value",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: r.scoreValueSize,
            ),
          ),
        ],
      ),
    );
  }
}
