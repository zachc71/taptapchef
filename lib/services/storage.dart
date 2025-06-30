import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/staff.dart';

class GameLoadResult {
  final int count;
  final int milestoneIndex;
  GameLoadResult(this.count, this.milestoneIndex);
}

class PlayerData {
  final int coins;
  final int perTap;
  final Map<StaffType, int> staff;
  final Map<String, int> upgrades;
  final List<String> ownedArtifacts;
  final List<String?> equippedArtifacts;
  final bool tutorialComplete;

  PlayerData({
    required this.coins,
    required this.perTap,
    required this.staff,
    required this.upgrades,
    required this.ownedArtifacts,
    required this.equippedArtifacts,
    this.tutorialComplete = false,
  });
}

class StorageService {
  static const _keyCount = 'count';
  static const _keyMilestone = 'milestoneIndex';
  static const _keyTokens = 'franchiseTokens';
  static const _keyLocation = 'locationSetIndex';
  static const _keyUpgrades = 'purchasedPrestigeUpgrades';
  static const _keyCoins = 'coins';
  static const _keyPerTap = 'perTap';
  static const _keyStaff = 'hiredStaff';
  static const _keyOwnedUpgrades = 'ownedUpgrades';
  static const _keyOwnedArtifacts = 'ownedArtifacts';
  static const _keyEquippedArtifacts = 'equippedArtifacts';
  static const _keyTutorial = 'tutorialComplete';

  /// Saves the current count and milestone index to local storage.
  Future<void> saveGame(int count, int milestoneIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCount, count);
    await prefs.setInt(_keyMilestone, milestoneIndex);
  }

  Future<void> saveFranchiseData(GameState game) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTokens, game.franchiseTokens);
    await prefs.setInt(_keyLocation, game.locationSetIndex);
    await prefs.setString(
        _keyUpgrades, jsonEncode(game.purchasedPrestigeUpgrades));
  }

  Future<void> savePlayerData({
    required int coins,
    required int perTap,
    required Map<StaffType, int> staff,
    required Map<String, int> upgrades,
    required List<String> ownedArtifacts,
    required List<String?> equippedArtifacts,
    required bool tutorialComplete,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCoins, coins);
    await prefs.setInt(_keyPerTap, perTap);
    await prefs.setString(_keyStaff,
        jsonEncode(staff.map((k, v) => MapEntry(k.name, v))));
    await prefs.setString(_keyOwnedUpgrades, jsonEncode(upgrades));
    await prefs.setStringList(_keyOwnedArtifacts, ownedArtifacts);
    await prefs.setStringList(
        _keyEquippedArtifacts,
        equippedArtifacts.map((e) => e ?? '').toList());
    await prefs.setBool(_keyTutorial, tutorialComplete);
  }

  Future<void> loadFranchiseData(GameState game) async {
    final prefs = await SharedPreferences.getInstance();
    game.franchiseTokens = prefs.getInt(_keyTokens) ?? 0;
    game.locationSetIndex = prefs.getInt(_keyLocation) ?? 0;
    final upgradesString = prefs.getString(_keyUpgrades);
    if (upgradesString != null && upgradesString.isNotEmpty) {
      final decoded = jsonDecode(upgradesString) as Map<String, dynamic>;
      game.purchasedPrestigeUpgrades =
          decoded.map((key, value) => MapEntry(key, value as int));
    }
  }

  Future<PlayerData> loadPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    final coins = prefs.getInt(_keyCoins) ?? 0;
    final perTap = prefs.getInt(_keyPerTap) ?? 1;
    final staffStr = prefs.getString(_keyStaff);
    Map<StaffType, int> staff = {};
    if (staffStr != null && staffStr.isNotEmpty) {
      final decoded = jsonDecode(staffStr) as Map<String, dynamic>;
      staff = decoded.map((key, value) =>
          MapEntry(StaffType.values.firstWhere((e) => e.name == key),
              value as int));
    }
    final upgradeStr = prefs.getString(_keyOwnedUpgrades);
    Map<String, int> upgrades = {};
    if (upgradeStr != null && upgradeStr.isNotEmpty) {
      final decoded = jsonDecode(upgradeStr) as Map<String, dynamic>;
      upgrades = decoded.map((k, v) => MapEntry(k, v as int));
    }
    final ownedArtifacts =
        prefs.getStringList(_keyOwnedArtifacts) ?? <String>[];
    final equippedList = prefs.getStringList(_keyEquippedArtifacts) ?? <String>[];
    final equippedArtifacts =
        equippedList.map((e) => e.isEmpty ? null : e).toList();
    while (equippedArtifacts.length < 3) {
      equippedArtifacts.add(null);
    }
    final tutorialComplete = prefs.getBool(_keyTutorial) ?? false;
    return PlayerData(
        coins: coins,
        perTap: perTap,
        staff: staff,
        upgrades: upgrades,
        ownedArtifacts: ownedArtifacts,
        equippedArtifacts: equippedArtifacts,
        tutorialComplete: tutorialComplete);
  }

  /// Loads the saved count and milestone index from local storage.
  Future<GameLoadResult> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCount = prefs.getInt(_keyCount) ?? 0;
    final milestone = prefs.getInt(_keyMilestone) ?? 0;
    return GameLoadResult(savedCount, milestone);
  }

  /// Clears all saved progress so the game starts fresh.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear all persisted values to ensure a truly fresh start. This is
    // simpler and less error-prone than removing keys individually in case
    // new preferences are added later.
    await prefs.clear();
  }
}
