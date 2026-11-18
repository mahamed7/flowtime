import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flowtime/data/models/user_settings.dart';
import 'package:flowtime/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flowtime/features/timer/presentation/screens/timer_screen.dart';

/// True once the user has finished onboarding (read from the Hive settings box).
bool _hasCompletedOnboarding() {
  if (!Hive.isBoxOpen('settings')) return false;
  final settings = Hive.box('settings').get('user_settings');
  return settings is UserSettings && settings.hasCompletedOnboarding;
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  // Returning users skip onboarding and land straight on the timer.
  redirect: (BuildContext context, GoRouterState state) {
    if (state.matchedLocation == '/onboarding' && _hasCompletedOnboarding()) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const TimerScreen(),
    ),
  ],
);
