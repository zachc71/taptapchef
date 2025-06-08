import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/game_state.dart';

/// Global provider for the [GameState] instance.
final gameStateProvider =
    ChangeNotifierProvider<GameState>((ref) => GameState());
