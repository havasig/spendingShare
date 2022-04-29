import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/groups/join_page.dart';

import '../wrapper.dart';

void main() {
  group(
    'JoinPage',
    () {
      late FakeFirebaseFirestore firestore;

      setUpAll(() async {
        firestore = FakeFirebaseFirestore();
      });

      testWidgets('JoinPage has join group header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('join_group');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('JoinPage has back button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('back');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('JoinPage has no groups title', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('no_groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('JoinPage has paste code here text', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('paste_code_here');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('JoinPage has join input field', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final joinInputField = find.byKey(const Key('join_input_field'));
        expect(joinInputField, findsOneWidget);
      });

      testWidgets('JoinPage has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final joinButton = find.byKey(const Key('join_button'));
        expect(joinButton, findsOneWidget);
      });

      testWidgets('JoinPage has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(child: JoinPage(firestore: firestore, color: Colors.orange));
        await tester.pumpWidget(testWidget);
        final bottomNavigationFinder = find.byKey(const Key('bottom_navigation'));
        expect(bottomNavigationFinder, findsOneWidget);
      });
    },
  );
}
