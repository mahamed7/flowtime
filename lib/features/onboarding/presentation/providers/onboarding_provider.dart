import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flowtime/data/models/user_settings.dart';

final userSettingsProvider = StateNotifierProvider<UserSettingsNotifier, UserSettings>((ref) {
  final box = Hive.box('settings');
  final settings = box.get('user_settings', defaultValue: UserSettings()) as UserSettings;
  return UserSettingsNotifier(settings);
});

class UserSettingsNotifier extends StateNotifier<UserSettings> {
  UserSettingsNotifier(super.state);

  void updatePersonality(String personality) {
    state = UserSettings(
      focusDurationMinutes: state.focusDurationMinutes,
      breakDurationMinutes: state.breakDurationMinutes,
      aiPersonality: personality,
      isGuardianEnabled: state.isGuardianEnabled,
      hasCompletedOnboarding: state.hasCompletedOnboarding,
    );
    _save();
  }

  void completeOnboarding() {
    state = UserSettings(
      focusDurationMinutes: state.focusDurationMinutes,
      breakDurationMinutes: state.breakDurationMinutes,
      aiPersonality: state.aiPersonality,
      isGuardianEnabled: state.isGuardianEnabled,
      hasCompletedOnboarding: true,
    );
    _save();
  }

  Future<void> _save() async {
    final box = Hive.box('settings');
    await box.put('user_settings', state);
  }
}
