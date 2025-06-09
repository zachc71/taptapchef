import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/staff.dart';
import '../models/upgrade.dart';
import '../services/storage.dart';
import 'effect_engine.dart';
import '../models/artifact.dart';

class GameController extends ChangeNotifier {
  final GameState game;
  final StorageService _storage;
  late final EffectEngine effects;

  GameController({GameState? state, StorageService? storage})
      : game = state ?? GameState(),
        _storage = storage ?? StorageService() {
    effects = EffectEngine(game);
    upgrades = upgradesForTier(game.milestoneIndex);
  }

  late final Timer _timer;
  Timer? _specialTimer;

  int coins = 0;
  int perTap = 1;
  late List<Upgrade> upgrades;

  final Map<StaffType, int> hiredStaff = {};
  double _passiveProgress = 0;
  int _lastMilestoneIndex = 0;
  int get lastMilestoneIndex => _lastMilestoneIndex;
  double currentTPS = 0;

  bool ripMode = false;
  Color ripColor = Colors.transparent;
  double ripRotation = 0;
  Timer? ripTimer;

  bool adBoostActive = false;
  int adBoostSeconds = 0;
  Timer? adBoostTimer;

  int combo = 0;
  Timer? comboTimer;
  Timer? frenzyWarmupTimer;
  Timer? frenzyDurationTimer;
  static const int comboMax = 20;
  static const Duration comboTimeout = Duration(seconds: 3);

  bool frenzy = false;

  bool specialVisible = false;

  Future<OfflineLoadResult> load() async {
    final result = await _storage.loadGame(idleMultiplier: 0.000833);
    game.mealsServed = result.count;
    final adjustedEarned =
        effects.calculateOfflineEarnings(result.earned.toDouble()).toInt();
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
  }

  Future<void> save() async {
    await _storage.saveGame(game.mealsServed);
    await _storage.saveFranchiseData(game);
  }

  void cook() {
    _incrementCombo();
    for (int i = 0; i < perTap; i++) {
      game.cook();
    }
    final tapValue = effects.calculateFinalTapValue(perTap.toDouble());
    coins += (tapValue * currentMultiplier).toInt();
    _checkMilestone();
    notifyListeners();
    save();
  }

  void addCoins(int amount) {
    coins += amount;
    notifyListeners();
  }

  void purchase(Upgrade upgrade, int quantity) {
    if (quantity <= 0) return;
    final costPer = effects.calculateUpgradeCost(upgrade.cost.toDouble());
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
      final speed = effects.calculateStaffSpeed(staff.tapsPerSecond);
      tapsPerSecond += speed * qty;
    });
    tapsPerSecond = effects.calculatePassiveIncome(tapsPerSecond);
    _passiveProgress += tapsPerSecond;
    final int whole = _passiveProgress.floor();
    _passiveProgress -= whole;
    currentTPS = tapsPerSecond;
    if (whole > 0) {
      for (int i = 0; i < whole; i++) {
        game.cook();
      }
      final tapValue = effects.calculateFinalTapValue(perTap.toDouble());
      coins += (tapValue * whole).toInt();
    }
    _checkMilestone();
    notifyListeners();
  }

  void _checkMilestone() {
    if (_lastMilestoneIndex != game.milestoneIndex) {
      _lastMilestoneIndex = game.milestoneIndex;
      upgrades = upgradesForTier(game.milestoneIndex);
      notifyListeners();
    }
  }

  void hireStaff(StaffType type, int quantity) {
    final staff = staffOptions[type]!;
    final costPer = effects.calculateStaffCost(staff.cost.toDouble());
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
  }

  int get currentMultiplier {
    final base = frenzy ? 5 : 1 + (combo ~/ 2);
    return adBoostActive ? base * 2 : base;
  }

  void _incrementCombo() {
    comboTimer?.cancel();
    _updateComboAndFrenzy();
    comboTimer = Timer(comboTimeout, () {
      frenzyWarmupTimer?.cancel();
      combo = (combo - 2).clamp(0, comboMax);
      notifyListeners();
    });
  }

  void _updateComboAndFrenzy() {
    if (combo < comboMax) {
      combo += 1;
    }
    if (combo >= comboMax && !frenzy) {
      _startFrenzyWarmup();
    }
  }

  void _startFrenzyWarmup() {
    if (frenzy) return;
    frenzyWarmupTimer?.cancel();
    frenzyWarmupTimer = Timer(const Duration(seconds: 1), () {
      if (combo >= comboMax && !frenzy) {
        _startFrenzyMode();
      }
    });
  }

  void _startFrenzyMode() {
    if (frenzy) return;
    frenzyWarmupTimer?.cancel();
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

  Future<void> resetGame() async {
    await _storage.clear();
    game.resetProgress();
    game.prestige.points = 0;
    game.franchiseTokens = 0;
    game.locationSetIndex = 0;
    game.purchasedPrestigeUpgrades.clear();
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
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    ripTimer?.cancel();
    frenzyDurationTimer?.cancel();
    _specialTimer?.cancel();
    adBoostTimer?.cancel();
    save();
    super.dispose();
  }
}
