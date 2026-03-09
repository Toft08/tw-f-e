import 'package:shared_preferences/shared_preferences.dart';

/// Persists the best score across app sessions.
class ScoreStorage {
  static const String _key = 'best_score';

  /// Returns the stored best score, or 0 if none has been saved yet.
  static Future<int> loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  /// Saves [score] as the new best score.
  static Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, score);
  }
}
