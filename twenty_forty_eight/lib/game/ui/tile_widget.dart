import 'package:flutter/material.dart';

class TileWidget extends StatefulWidget {
  final int value;

  /// True on the frame this tile first appears — drives a scale-in animation.
  final bool isNew;

  /// True on the frame two tiles merged into this one — drives a pop animation.
  final bool isMerged;

  /// The size of the tile in pixels, used to scale the font proportionally.
  final double tileSize;

  const TileWidget({
    super.key,
    required this.value,
    this.isNew = false,
    this.isMerged = false,
    required this.tileSize,
  });

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
    _play(widget.isNew, widget.isMerged);
  }

  @override
  void didUpdateWidget(TileWidget old) {
    super.didUpdateWidget(old);
    if (widget.isMerged && !old.isMerged) {
      _play(false, true);
    } else if (widget.isNew && !old.isNew) {
      _play(true, false);
    }
  }

  void _play(bool isNew, bool isMerged) {
    _ctrl.stop();
    if (isNew) {
      // Scale in: 0 → 1 with elastic overshoot.
      _ctrl.duration = const Duration(milliseconds: 250);
      _scale = Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
      _ctrl.forward(from: 0);
    } else if (isMerged) {
      // Pop: 1 → 1.25 → 1.
      _ctrl.duration = const Duration(milliseconds: 200);
      _scale = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 1.25,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 40,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.25,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 60,
        ),
      ]).animate(_ctrl);
      _ctrl.forward(from: 0);
    } else {
      // No animation — stay at full scale.
      _ctrl.duration = const Duration(milliseconds: 1);
      _scale = ConstantTween<double>(1.0).animate(_ctrl);
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.value) {
      case 2:
        return Colors.grey.shade300;
      case 4:
        return Colors.orange.shade200;
      case 8:
        return Colors.orange.shade400;
      case 16:
        return Colors.deepOrange.shade300;
      case 32:
        return Colors.deepOrange;
      case 64:
        return Colors.deepOrange.shade700;
      case 128:
        return Colors.amber.shade400;
      case 256:
        return Colors.amber.shade600;
      case 512:
        return Colors.amber.shade800;
      case 1024:
        return Colors.yellow.shade700;
      case 2048:
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int v = widget.value;
    // Scale font size proportionally with tile size
    // Base: 60px tile → 28px font for small numbers
    final baseFontSize = widget.tileSize * 0.45;
    final fontSize = v < 100
        ? baseFontSize
        : (v < 1000 ? baseFontSize * 0.8 : baseFontSize * 0.65);

    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: Container(
        decoration: BoxDecoration(
          color: _getColor(),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            '$v',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: v <= 4 ? Colors.brown.shade700 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
