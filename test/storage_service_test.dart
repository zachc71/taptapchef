import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptapchef/services/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loadGame applies idle earnings', () async {
    final now = DateTime.now();
    SharedPreferences.setMockInitialValues({
      'count': 100,
      'timestamp': now.subtract(const Duration(seconds: 10)).millisecondsSinceEpoch,
    });

    final service = StorageService();
    final result = await service.loadGame(idleMultiplier: 1.0);

    expect(result.earned, 10);
    expect(result.count, 110);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('count'), 110);
  });

  test('loadGame with no saved data returns zeros', () async {
    SharedPreferences.setMockInitialValues({});

    final service = StorageService();
    final result = await service.loadGame(idleMultiplier: 1.0);

    expect(result.earned, 0);
    expect(result.count, 0);
  });
}
