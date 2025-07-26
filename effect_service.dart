import 'package:taptapchef/models/game_state.dart';
import 'package:taptapchef/models/artifact.dart';

/// Centralized calculation service for game effects.
///
/// In addition to the existing multipliers, this version adds support for
/// golden meal mechanics via the [goldenMealChance] and
/// [goldenMealMultiplier] getters. These values can be tuned by assigning
/// appropriate `ArtifactEffectType` enums to artifacts (e.g.
/// `goldenMealChance` and `goldenMealMultiplier`).
class EffectService {
  final GameState gameState;

  EffectService(this.gameState);

  /// Currently equipped artifacts resolved from the [gameState].
  List<Artifact> get _equippedArtifacts {
    return gameState.equippedArtifactIds
        .where((id) => id != null)
        .map((id) => gameArtifacts[id!]!)
        .toList();
  }

  /// Calculates the final tap value from [baseValue] applying all artifact bonuses.
  double calculateTapValue(double baseValue) {
    double additiveBonus = 0;
    // Currently no additive tap bonuses exist. Placeholder for future additive effects.
    double valueAfterAdditive = baseValue + additiveBonus;

    double multiplicativeBonus = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.tapValueMultiplier ||
            effect.type == ArtifactEffectType.tapValueDebuff) {
          multiplicativeBonus *= effect.value;
        }
      }
    }
    return valueAfterAdditive * multiplicativeBonus;
  }

  /// Multiplier applied to staff hiring costs.
  double get staffCostMultiplier {
    double multiplier = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.staffCostMultiplier ||
            effect.type == ArtifactEffectType.purchaseCostMultiplier) {
          multiplier *= effect.value;
        }
      }
    }
    return multiplier;
  }

  /// Multiplier applied to staff speed values.
  double get staffSpeedMultiplier {
    double multiplier = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.staffSpeedMultiplier ||
            effect.type == ArtifactEffectType.staffEffectivenessDebuff) {
          multiplier *= effect.value;
        }
      }
    }
    return multiplier;
  }

  /// Multiplier applied to passive income taps per second.
  double get passiveIncomeMultiplier {
    double multiplier = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.passiveIncomeMultiplier) {
          multiplier *= effect.value;
        }
      }
    }
    return multiplier;
  }

  /// Multiplier applied to upgrade costs.
  double get upgradeCostMultiplier {
    double multiplier = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.upgradeCostMultiplier ||
            effect.type == ArtifactEffectType.purchaseCostMultiplier) {
          multiplier *= effect.value;
        }
      }
    }
    return multiplier;
  }

  /// Multiplier applied to offline earnings.
  double get offlineEarningsMultiplier {
    double multiplier = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.offlineEarningsMultiplier) {
          multiplier *= effect.value;
        }
      }
    }
    return multiplier;
  }

  /// The chance that a golden meal will spawn during a special event.
  ///
  /// Base spawn chance should be defined in the game logic; this getter
  /// contributes additive bonuses from equipped artifacts. For example,
  /// equipping an artifact with `goldenMealChance` of 0.005 would increase
  /// the spawn probability by 0.5 percentage points. The final spawn chance
  /// returned here can then be added to the base chance in the game controller.
  double get goldenMealChance {
    double additiveChance = 0.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.goldenMealChance) {
          additiveChance += effect.value;
        }
      }
    }
    return additiveChance;
  }

  /// The multiplier applied to golden meal rewards.
  ///
  /// Golden meals grant a large chunk of coins when tapped. This getter
  /// aggregates multiplicative bonuses from artifacts. If two artifacts each
  /// provide a 1.5× golden meal multiplier, the total becomes 2.25×.
  double get goldenMealMultiplier {
    double multiplier = 1.0;
    for (final artifact in _equippedArtifacts) {
      for (final effect in [artifact.bonus, artifact.drawback]) {
        if (effect.type == ArtifactEffectType.goldenMealMultiplier) {
          multiplier *= effect.value;
        }
      }
    }
    return multiplier;
  }
}