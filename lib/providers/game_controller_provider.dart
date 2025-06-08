import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';

final gameControllerProvider =
    ChangeNotifierProvider<GameController>((ref) => GameController());
