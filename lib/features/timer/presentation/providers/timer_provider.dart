import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowtime/data/models/focus_session.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isBreak;

  TimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    this.isBreak = false,
  });

  TimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    bool? isBreak,
  }) {
    return TimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
    );
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier();
});

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState(totalSeconds: 25 * 60, remainingSeconds: 25 * 60, isRunning: false));

  Timer? _timer;
  DateTime? _startTime;

  void startTimer() {
    if (state.isRunning) return;
    _startTime = DateTime.now();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _completeSession();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer({int minutes = 25}) {
    _timer?.cancel();
    state = TimerState(totalSeconds: minutes * 60, remainingSeconds: minutes * 60, isRunning: false);
  }

  void _completeSession() {
    _timer?.cancel();
    final session = FocusSession(
      startTime: _startTime ?? DateTime.now(),
      endTime: DateTime.now(),
      durationMinutes: state.totalSeconds ~/ 60,
      completed: true,
    );
    Hive.box('sessions').add(session);
    
    state = state.copyWith(isRunning: false, remainingSeconds: 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
