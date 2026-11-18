import 'package:flutter_test/flutter_test.dart';
import 'package:flowtime/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flowtime/data/models/user_settings.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    Hive.registerAdapter(UserSettingsAdapter());
    await Hive.openBox('settings');
  });

  test('UserSettings initialization and update', () {
    final settings = UserSettings(aiPersonality: 'zen');
    final notifier = UserSettingsNotifier(settings);
    
    expect(notifier.state.aiPersonality, 'zen');
    
    notifier.updatePersonality('sergeant');
    expect(notifier.state.aiPersonality, 'sergeant');
    
    notifier.completeOnboarding();
    expect(notifier.state.hasCompletedOnboarding, true);
  });
}
