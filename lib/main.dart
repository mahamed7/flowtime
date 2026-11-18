import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/focus_session.dart';
import 'data/models/user_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  Hive.registerAdapter(FocusSessionAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  
  // Open basic settings box
  await Hive.openBox('settings');
  await Hive.openBox('sessions');

  runApp(
    const ProviderScope(
      child: FlowTimeApp(),
    ),
  );
}

class FlowTimeApp extends StatelessWidget {
  const FlowTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FlowTime',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
