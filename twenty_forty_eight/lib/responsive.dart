import 'package:flutter/material.dart';

/// Global responsive sizing utility that scales all UI elements proportionally
/// based on screen width. Reference width is 375 (standard phone width).
class Responsive {
  final double width;
  final double height;
  final double _scaleFactor;

  Responsive(BuildContext context)
    : width = MediaQuery.of(context).size.width,
      height = MediaQuery.of(context).size.height,
      // Cap scale factor at 1.5x to prevent excessive scaling on large screens
      _scaleFactor = (MediaQuery.of(context).size.width / 375).clamp(0.8, 1.5);

  /// Scale a value proportionally to screen width
  double scale(double size) => size * _scaleFactor;

  /// Font sizes
  double get titleSize => scale(42);
  double get scoreLabelSize => scale(12);
  double get scoreValueSize => scale(20);
  double get buttonTextSize => scale(14);
  double get dialogTitleSize => scale(20);
  double get dialogContentSize => scale(16);

  /// Spacing
  double get smallSpacing => scale(8);
  double get mediumSpacing => scale(16);
  double get largeSpacing => scale(20);
  double get extraLargeSpacing => scale(24);

  /// Padding
  EdgeInsets get scoreBoxPadding =>
      EdgeInsets.symmetric(horizontal: scale(24), vertical: scale(12));
  EdgeInsets get buttonPadding => EdgeInsets.symmetric(horizontal: scale(6));
  EdgeInsets get dialogPadding => EdgeInsets.all(scale(20));

  /// Border radius
  double get smallRadius => scale(6);
  double get mediumRadius => scale(8);
  double get largeRadius => scale(12);

  /// Icon sizes
  double get iconSize => scale(24);
  double get smallIconSize => scale(20);

  /// Get instance from context
  static Responsive of(BuildContext context) => Responsive(context);
}
