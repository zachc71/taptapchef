import '../models/artifact.dart';
import '../models/game_state.dart';

class EffectEngine {
  final GameState game;

  EffectEngine(this.game);

  Iterable<Artifact> get _equipped sync* {
    for (final id in game.equippedArtifactIds) {
      if (id != null && gameArtifacts.containsKey(id)) {
        yield gameArtifacts[id]!;
      }
    }
  }

  double calculateFinalTapValue(double baseValue) {
    double value = baseValue;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        switch (effect.type) {
          case ArtifactEffectType.tapValueMultiplier:
          case ArtifactEffectType.tapValueDebuff:
            value *= effect.value;
            break;
          default:
            break;
        }
      }
    }
    return value;
  }

  double calculateStaffCost(double baseCost) {
    double value = baseCost;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.staffCostMultiplier ||
            effect.type == ArtifactEffectType.purchaseCostMultiplier) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  double calculateUpgradeCost(double baseCost) {
    double value = baseCost;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.upgradeCostMultiplier ||
            effect.type == ArtifactEffectType.purchaseCostMultiplier) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  double calculateStaffSpeed(double baseSpeed) {
    double value = baseSpeed;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.staffSpeedMultiplier ||
            effect.type == ArtifactEffectType.staffEffectivenessDebuff) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  double calculatePassiveIncome(double baseIncome) {
    double value = baseIncome;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.passiveIncomeMultiplier) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  double calculateOfflineEarnings(double base) {
    double value = base;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.offlineEarningsMultiplier) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  double calculateEventReward(double baseReward) {
    double value = baseReward;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.eventRewardMultiplier) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  double adjustGoldenMealChance(double baseChance) {
    double chance = baseChance;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.goldenMealChance) {
          chance += effect.value;
        }
      }
    }
    return chance;
  }

  double calculateGoldenMealReward(double baseReward) {
    double value = baseReward;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.goldenMealMultiplier) {
          value *= effect.value;
        }
      }
    }
    return value;
  }

  int totalFreePurchases() {
    int total = 0;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.firstPurchasesFree) {
          total += effect.value.toInt();
        }
      }
    }
    return total;
  }

  double calculateTapPassiveSeconds(double baseSeconds) {
    double seconds = baseSeconds;
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.tapTriggerPassiveSeconds) {
          seconds += effect.value;
        }
      }
    }
    return seconds;
  }

  bool get singleStaffTypeOnly {
    for (final art in _equipped) {
      for (final effect in [art.bonus, art.drawback]) {
        if (effect.type == ArtifactEffectType.singleStaffTypeOnly) {
          return true;
        }
      }
    }
    return false;
  }
}
