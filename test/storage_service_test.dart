import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptapchef/services/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loadGame restores saved values', () async {
    SharedPreferences.setMockInitialValues({
      'count': 42,
      'milestoneIndex': 3,
    });

    final service = StorageService();
    final result = await service.loadGame();

    expect(result.count, 42);
    expect(result.milestoneIndex, 3);
  });

  test('loadGame with no saved data returns zeros', () async {
    SharedPreferences.setMockInitialValues({});

    final service = StorageService();
    final result = await service.loadGame();

    expect(result.count, 0);
    expect(result.milestoneIndex, 0);
  });
}
