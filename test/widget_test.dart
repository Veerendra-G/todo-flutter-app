import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FlowDo App loads and displays header', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TodoProvider()),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
        ),
      ),
    );

    // Allow async load to complete
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Title & FAB exist
    expect(find.text('FlowDo'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
  });
}
