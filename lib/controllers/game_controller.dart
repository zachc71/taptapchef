import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/staff.dart';
import '../models/upgrade.dart';
import '../services/storage.dart';
import '../models/artifact.dart';
import '../services/effect_service.dart';

class GameController extends ChangeNotifier {
  final GameState game;
  final StorageService _storage;
  late final EffectService effectService;

  GameController({GameState? state, StorageService? storage})
      : game = state ?? GameState(),
        _storage = storage ?? StorageService() {
    effectService = EffectService(game);
    upgrades = upgradesForTier(game.milestoneIndex);
  }

  late final Timer _timer;
  Timer? _specialTimer;
  Timer? _autosaveTimer;
  static const Duration autosaveInterval = Duration(seconds: 5);

  int coins = 0;
  int perTap = 1;
  late List<Upgrade> upgrades;

  bool tutorialComplete = false;

  final Map<StaffType, int> hiredStaff = {};
  double _passiveProgress = 0;
  int _lastMilestoneIndex = 0;
  int get lastMilestoneIndex => _lastMilestoneIndex;
  double currentTPS = 0;

  /// Current passive income per second in coins.
  double get idleIncomePerSecond {
    final tapValue = effectService.calculateTapValue(perTap.toDouble());
    return currentTPS * tapValue;
  }

  bool ripMode = false;
  Color ripColor = Colors.transparent;
  double ripRotation = 0;
  Timer? ripTimer;

  bool adBoostActive = false;
  int adBoostSeconds = 0;
  Timer? adBoostTimer;

  int combo = 0;
  Timer? comboTimer;
  Timer? frenzyDurationTimer;
  static const int comboMax = 30;
  static const Duration comboTimeout = Duration(seconds: 1);

  bool frenzy = false;

  bool specialVisible = false;

  bool get anyPurchasesAffordable {
    if (upgrades.any((u) => coins >= u.cost)) {
      return true;
    }
    final availableStaff = staffByTier[game.milestoneIndex] ?? {};
    for (final s in availableStaff.values) {
      if (coins >= s.cost) return true;
    }
    return false;
  }

  Future<OfflineLoadResult> load() async {
    final result = await _storage.loadGame(idleMultiplier: 0.000833);
    final player = await _storage.loadPlayerData();
    coins = player.coins;
    perTap = player.perTap;
    tutorialComplete = player.tutorialComplete;
    hiredStaff
      ..clear()
      ..addAll(player.staff);
    for (final u in upgrades) {
      u.owned = player.upgrades[u.name] ?? 0;
    }
    game.ownedArtifactIds = List.from(player.ownedArtifacts);
    game.equippedArtifactIds = List.from(player.equippedArtifacts);
    game.mealsServed = result.count;
    final adjustedEarned =
        (result.earned * effectService.offlineEarningsMultiplier).toInt();
    coins += adjustedEarned;
    _lastMilestoneIndex = game.milestoneIndex;
    await _storage.loadFranchiseData(game);
    notifyListeners();
    return OfflineLoadResult(result.count, adjustedEarned);
  }

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tickPassive());
    _specialTimer =
        Timer.periodic(const Duration(seconds: 20), (_) => _spawnSpecial());
    _autosaveTimer =
        Timer.periodic(autosaveInterval, (_) => save());
  }

  Future<void> save() async {
    await _storage.saveGame(game.mealsServed);
    await _storage.saveFranchiseData(game);
    await _storage.savePlayerData(
      coins: coins,
      perTap: perTap,
      staff: hiredStaff,
      upgrades: {for (final u in upgrades) u.name: u.owned},
      ownedArtifacts: game.ownedArtifactIds,
      equippedArtifacts: game.equippedArtifactIds,
      tutorialComplete: tutorialComplete,
    );
  }

  void cook() {
    _incrementCombo();
    for (int i = 0; i < perTap; i++) {
      game.cook();
    }
    final tapValue = effectService.calculateTapValue(perTap.toDouble());
    coins += (tapValue * currentMultiplier).toInt();
    _checkMilestone();
    notifyListeners();
  }

  void addCoins(int amount) {
    coins += amount;
    notifyListeners();
  }

  void purchase(Upgrade upgrade, int quantity) {
    if (quantity <= 0) return;
    final costPer = upgrade.cost.toDouble() * effectService.upgradeCostMultiplier;
    final int totalCost = (costPer * quantity).ceil();
    if (coins >= totalCost) {
      coins -= totalCost;
      perTap += upgrade.effect * quantity;
      upgrade.owned += quantity;
      notifyListeners();
    }
  }

  void _tickPassive() {
    double tapsPerSecond = 0;
    hiredStaff.forEach((type, qty) {
      final staff = staffOptions[type]!;
      final speed = staff.tapsPerSecond * effectService.staffSpeedMultiplier;
      tapsPerSecond += speed * qty;
    });
    tapsPerSecond *= effectService.passiveIncomeMultiplier;
    _passiveProgress += tapsPerSecond;
    final int whole = _passiveProgress.floor();
    _passiveProgress -= whole;
    currentTPS = tapsPerSecond;
    if (whole > 0) {
      for (int i = 0; i < whole; i++) {
        game.cook();
      }
      final tapValue = effectService.calculateTapValue(perTap.toDouble());
      coins += (tapValue * whole).toInt();
    }
    _checkMilestone();
    notifyListeners();
  }

  void _checkMilestone() {
    if (_lastMilestoneIndex != game.milestoneIndex) {
      _lastMilestoneIndex = game.milestoneIndex;
      upgrades = upgradesForTier(game.milestoneIndex);
    }
  }

  void hireStaff(StaffType type, int quantity) {
    final staff = staffOptions[type]!;
    final costPer = staff.cost.toDouble() * effectService.staffCostMultiplier;
    final int totalCost = (costPer * quantity).ceil();
    if (coins >= totalCost) {
      coins -= totalCost;
      hiredStaff[type] = (hiredStaff[type] ?? 0) + quantity;
      notifyListeners();
    }
  }

  void _spawnSpecial() {
    if (specialVisible) return;
    if (Random().nextDouble() < 0.5) {
      specialVisible = true;
      Timer(const Duration(seconds: 10), () {
        specialVisible = false;
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void hideSpecial() {
    specialVisible = false;
    notifyListeners();
  }

  Future<void> rewardSpecial(int taps) async {
    coins += taps * 10;
    if (Random().nextDouble() < 0.1) {
      final available = gameArtifacts.keys
          .where((id) => !game.ownedArtifactIds.contains(id))
          .toList();
      if (available.isNotEmpty) {
        final id = available[Random().nextInt(available.length)];
        game.ownedArtifactIds.add(id);
      }
    }
    notifyListeners();
    await save();
  }

  int get currentMultiplier {
    final base = frenzy ? 5 : 1 + (combo ~/ 2);
    return adBoostActive ? base * 2 : base;
  }

  void _incrementCombo() {
    comboTimer?.cancel();
    _updateComboAndFrenzy();
    comboTimer = Timer.periodic(comboTimeout, (timer) {
      if (frenzy) {
        timer.cancel();
        comboTimer = null;
        return;
      }
      if (combo > 0) {
        combo -= 1;
        notifyListeners();
      } else {
        timer.cancel();
        comboTimer = null;
      }
    });
  }

  void _updateComboAndFrenzy() {
    if (combo < comboMax) {
      combo += 1;
    }
    if (combo >= comboMax && !frenzy) {
      _startFrenzyMode();
    }
  }

  void _startFrenzyMode() {
    if (frenzy) return;
    frenzyDurationTimer?.cancel();
    frenzy = true;
    combo = comboMax;
    notifyListeners();
    frenzyDurationTimer = Timer(const Duration(seconds: 5), () {
      frenzy = false;
      combo = 0;
      notifyListeners();
    });
  }

  void startRipMode() {
    if (ripMode) return;
    ripMode = true;
    ripColor = Colors.green;
    ripRotation = (Random().nextDouble() - 0.5) * 0.2;
    ripTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      ripRotation = (Random().nextDouble() - 0.5) * 0.2;
      notifyListeners();
    });
    Timer(const Duration(seconds: 8), () {
      ripTimer?.cancel();
      ripTimer = null;
      ripMode = false;
      notifyListeners();
    });
  }

  void startAdBoost() {
    adBoostTimer?.cancel();
    adBoostActive = true;
    adBoostSeconds = 300;
    notifyListeners();
    adBoostTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (adBoostSeconds <= 1) {
        timer.cancel();
        adBoostActive = false;
        adBoostSeconds = 0;
        notifyListeners();
      } else {
        adBoostSeconds--;
        notifyListeners();
      }
    });
  }

  Future<bool> watchAd() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  /// Franchise the current restaurant. Resets coins, staff and upgrades while
  /// awarding a random artifact. Prestige points and franchise tokens are
  /// preserved via [GameState.prestigeUp].
  Future<void> franchise() async {
    if (!game.atFinalMilestone) return;
    game.prestigeUp();

    final available = gameArtifacts.keys
        .where((id) => !game.ownedArtifactIds.contains(id))
        .toList();
    if (available.isNotEmpty) {
      final id = available[Random().nextInt(available.length)];
      game.ownedArtifactIds.add(id);
    }

    coins = 0;
    perTap = 1;
    upgrades = upgradesForTier(game.milestoneIndex);
    hiredStaff.clear();
    _passiveProgress = 0;
    _lastMilestoneIndex = game.milestoneIndex;
    currentTPS = 0;
    tutorialComplete = false;

    // Reset temporary gameplay state
    specialVisible = false;
    combo = 0;
    frenzy = false;
    adBoostActive = false;
    adBoostSeconds = 0;
    ripMode = false;

    // Cancel any running timers associated with these states
    comboTimer?.cancel();
    comboTimer = null;
    frenzyDurationTimer?.cancel();
    frenzyDurationTimer = null;
    adBoostTimer?.cancel();
    adBoostTimer = null;
    ripTimer?.cancel();
    ripTimer = null;

    notifyListeners();
    await save();
  }

  Future<void> resetGame() async {
    await _storage.clear();
    game.resetProgress();
    game.prestige.points = 0;
    game.franchiseTokens = 0;
    game.locationSetIndex = 0;
    game.purchasedPrestigeUpgrades.clear();
    game.ownedArtifactIds.clear();
    game.equippedArtifactIds = [null, null, null];
    coins = 0;
    perTap = 1;
    upgrades = upgradesForTier(game.milestoneIndex);
    for (final p in game.prestige.upgrades) {
      p.purchased = false;
    }
    hiredStaff.clear();
    _passiveProgress = 0;
    _lastMilestoneIndex = 0;
    currentTPS = 0;
    tutorialComplete = false;
    // Reset temporary gameplay state
    specialVisible = false;
    combo = 0;
    frenzy = false;
    adBoostActive = false;
    adBoostSeconds = 0;
    ripMode = false;

    // Cancel any running timers associated with these states
    comboTimer?.cancel();
    comboTimer = null;
    frenzyDurationTimer?.cancel();
    frenzyDurationTimer = null;
    adBoostTimer?.cancel();
    adBoostTimer = null;
    ripTimer?.cancel();
    ripTimer = null;
    notifyListeners();
    await save();
  }

  @override
  void dispose() {
    _timer.cancel();
    ripTimer?.cancel();
    frenzyDurationTimer?.cancel();
    _specialTimer?.cancel();
    _autosaveTimer?.cancel();
    adBoostTimer?.cancel();
    save();
    super.dispose();
  }
}
