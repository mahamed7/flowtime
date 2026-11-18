import 'package:flutter_test/flutter_test.dart';
import 'package:flowtime/features/timer/presentation/providers/timer_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() {
  // Setup Hive for testing
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    await Hive.openBox('sessions');
  });

  test('Timer initialization', () {
    final notifier = TimerNotifier();
    expect(notifier.state.remainingSeconds, 25 * 60);
    expect(notifier.state.isRunning, false);
  });

  test('Timer start/pause/reset', () {
    final notifier = TimerNotifier();
    
    notifier.startTimer();
    expect(notifier.state.isRunning, true);
    
    notifier.pauseTimer();
    expect(notifier.state.isRunning, false);
    
    notifier.resetTimer(minutes: 10);
    expect(notifier.state.totalSeconds, 10 * 60);
    expect(notifier.state.remainingSeconds, 10 * 60);
  });
}
