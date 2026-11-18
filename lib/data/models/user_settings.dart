import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 1)
class UserSettings extends HiveObject {
  @HiveField(0)
  int focusDurationMinutes;

  @HiveField(1)
  int breakDurationMinutes;

  @HiveField(2)
  String aiPersonality; // 'zen', 'sergeant', 'partner'

  @HiveField(3)
  bool isGuardianEnabled;

  @HiveField(4)
  bool hasCompletedOnboarding;

  UserSettings({
    this.focusDurationMinutes = 25,
    this.breakDurationMinutes = 5,
    this.aiPersonality = 'zen',
    this.isGuardianEnabled = true,
    this.hasCompletedOnboarding = false,
  });
}
