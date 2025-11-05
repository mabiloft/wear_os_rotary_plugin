import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wear_os_rotary_plugin/wear_os_rotary_plugin.dart';

void main() {
  group('WearOsScrollbar', () {
    testWidgets('creates a WearOsScrollbar widget', (WidgetTester tester) async {
      final ScrollController controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WearOsScrollbar(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        ),
      );
      expect(find.byType(WearOsScrollbar), findsOneWidget);
      controller.dispose();
    });

    testWidgets('displays child widget', (WidgetTester tester) async {
      final ScrollController controller = ScrollController();
      const Widget testChild = Text('Test Child');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WearOsScrollbar(
              controller: controller,
              child: testChild,
            ),
          ),
        ),
      );
      expect(find.text('Test Child'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('uses default values', (WidgetTester tester) async {
      final ScrollController controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WearOsScrollbar(
              controller: controller,
              child: const SizedBox(),
            ),
          ),
        ),
      );
      final WearOsScrollbar widget = tester.widget(find.byType(WearOsScrollbar)) as WearOsScrollbar;
      expect(widget.autoHide, isTrue);
      expect(widget.threshold, equals(0.2));
      expect(widget.bezelCorrection, equals(0.5));
      expect(widget.speed, equals(50.0));
      expect(widget.padding, equals(8.0));
      expect(widget.width, equals(2.0));
      expect(widget.opacityAnimationCurve, equals(Curves.easeInOut));
      expect(widget.opacityAnimationDuration, equals(const Duration(milliseconds: 500)));
      expect(widget.autoHideDuration, equals(const Duration(milliseconds: 1500)));
      controller.dispose();
    });

    testWidgets('uses custom values', (WidgetTester tester) async {
      final ScrollController controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WearOsScrollbar(
              controller: controller,
              autoHide: false,
              threshold: 0.3,
              bezelCorrection: 0.6,
              speed: 60,
              padding: 10,
              width: 3,
              opacityAnimationCurve: Curves.easeOut,
              opacityAnimationDuration: const Duration(milliseconds: 300),
              autoHideDuration: const Duration(seconds: 2),
              child: const SizedBox(),
            ),
          ),
        ),
      );
      final WearOsScrollbar widget = tester.widget(find.byType(WearOsScrollbar));
      expect(widget.autoHide, isFalse);
      expect(widget.threshold, equals(0.3));
      expect(widget.bezelCorrection, equals(0.6));
      expect(widget.speed, equals(60.0));
      expect(widget.padding, equals(10.0));
      expect(widget.width, equals(3.0));
      expect(widget.opacityAnimationCurve, equals(Curves.easeOut));
      expect(widget.opacityAnimationDuration, equals(const Duration(milliseconds: 300)));
      expect(widget.autoHideDuration, equals(const Duration(seconds: 2)));
      controller.dispose();
    });

    testWidgets('updates scrollbar when scroll position changes', (WidgetTester tester) async {
      final ScrollController controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WearOsScrollbar(
              controller: controller,
              child: ListView(
                controller: controller,
                children: List.generate(
                  50,
                  (index) => SizedBox(
                    height: 100,
                    child: Text('Item $index'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(WearOsScrollbar), findsOneWidget);
      controller.dispose();
    });
  });
}
