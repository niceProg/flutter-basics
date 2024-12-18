import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_basics/main.dart';

void main() {
  testWidgets('SplashScreen shows and navigates to HomePage', (WidgetTester tester) async {
    // Build the SplashScreen widget
    await tester.pumpWidget(MyApp());

    // Verify SplashScreen is displayed
    expect(find.text('Widget Basics App'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate waiting for 3 seconds
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Verify HomePage is displayed
    expect(find.text('Welcome to the Home Page!'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('HomePage displays all widgets correctly', (WidgetTester tester) async {
    // Build the HomePage widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(),
      ),
    );

    // Verify title text is displayed
    expect(find.text('Welcome to the Home Page!'), findsOneWidget);

    // Verify image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify "I Love Flutter" row is displayed
    expect(find.text('I Love Flutter'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // Verify ElevatedButton is displayed
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Simulate button press and check Snackbar
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Allow Snackbar to show
    expect(find.text('Button Pressed'), findsOneWidget);
  });
}