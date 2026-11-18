import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flowtime/main.dart';
import 'package:flowtime/data/models/focus_session.dart';
import 'package:flowtime/data/models/user_settings.dart';

void main() {
  // The app reads its settings from Hive on start-up, so give the test a
  // throwaway Hive directory with the same boxes main() opens.
  setUpAll(() async {
    Hive.init(Directory.systemTemp.createTempSync('flowtime_test').path);
    Hive.registerAdapter(FocusSessionAdapter());
    Hive.registerAdapter(UserSettingsAdapter());
    await Hive.openBox('settings');
    await Hive.openBox('sessions');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('First launch shows the onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FlowTimeApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Master Your Flow'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
