import 'package:shared_preferences/shared_preferences.dart';

class OfflineLoadResult {
  final int count;
  final int earned;
  OfflineLoadResult(this.count, this.earned);
}

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
  /// [idleMultiplier] determines how many meals are earned per second while offline.
  Future<OfflineLoadResult> loadGame({double idleMultiplier = 1.0}) async {
    final prefs = await SharedPreferences.getInstance();
    final savedCount = prefs.getInt(_keyCount) ?? 0;
    final timestamp = prefs.getInt(_keyTimestamp);
    int newCount = savedCount;
    int earned = 0;

    if (timestamp != null) {
      final last = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final elapsed = DateTime.now().difference(last).inSeconds;
      earned = (elapsed * idleMultiplier).floor();
      newCount += earned;
    }

    // Persist the updated count and timestamp so idle earnings aren't
    // repeatedly added on subsequent loads.
    await prefs.setInt(_keyCount, newCount);
    await prefs.setInt(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
    return OfflineLoadResult(newCount, earned);
  }

  /// Clears all saved progress so the game starts fresh.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCount);
    await prefs.remove(_keyTimestamp);
  }
}
