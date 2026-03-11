import 'package:shared_preferences/shared_preferences.dart';

/// Persists the best score per grid size across app sessions.
class ScoreStorage {
  static String _key(int gridSize) => 'best_score_$gridSize';

  /// Returns the stored best score for [gridSize], or 0 if none saved yet.
  static Future<int> loadBestScore(int gridSize) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key(gridSize)) ?? 0;
  }

  /// Saves [score] as the new best score for [gridSize].
  static Future<void> saveBestScore(int gridSize, int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key(gridSize), score);
  }
}
