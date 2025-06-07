import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyCount = 'count';
  static const _keyTimestamp = 'timestamp';

  /// Saves the current count and timestamp to local storage.
  Future<void> saveGame(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCount, count);
    await prefs.setInt(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  /// Loads the saved count and applies idle earnings based on the time elapsed.
  /// [idleRate] determines how many meals are earned per second while offline.
  Future<int> loadGame({int idleRate = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCount = prefs.getInt(_keyCount) ?? 0;
    final timestamp = prefs.getInt(_keyTimestamp);
    int newCount = savedCount;

    if (timestamp != null) {
      final last = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final elapsed = DateTime.now().difference(last).inSeconds;
      newCount += elapsed * idleRate;
    }

    // Persist the updated count and timestamp so idle earnings aren't
    // repeatedly added on subsequent loads.
    await prefs.setInt(_keyCount, newCount);
    await prefs.setInt(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
    return newCount;
  }
}
