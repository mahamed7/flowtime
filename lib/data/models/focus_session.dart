import 'package:hive/hive.dart';

part 'focus_session.g.dart';

@HiveType(typeId: 0)
class FocusSession extends HiveObject {
  @HiveField(0)
  final DateTime startTime;

  @HiveField(1)
  final DateTime endTime;

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  final int distractionCount;

  @HiveField(4)
  final String? taskName;

  @HiveField(5)
  final bool completed;

  FocusSession({
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.distractionCount = 0,
    this.taskName,
    this.completed = true,
  });
}
