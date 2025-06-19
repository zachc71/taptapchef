import 'package:taptapchef/models/game_state.dart';
import 'package:taptapchef/models/artifact.dart';

/// Centralized calculation service for game effects.
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
    // Currently no additive tap bonuses exist but the loop remains for future use.
    for (final artifact in _equippedArtifacts) {
      // ignore: unused_local_variable
      for (final effect in [artifact.bonus, artifact.drawback]) {
        // placeholder for potential additive effects
        // if (effect.type == ArtifactEffectType.addFlatTapValue) {
        //   additiveBonus += effect.value;
        // }
      }
    }
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
}

