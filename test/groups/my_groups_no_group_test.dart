import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';

import '../wrapper.dart';

void main() {
  group(
    'MyGroups without data',
    () {
      late FakeFirebaseFirestore firestore;

      setUpAll(() async {
        firestore = FakeFirebaseFirestore();
      });

      testWidgets('MyGroups has my groups header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('my-groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has no groups title', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('no-groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has you are not member text', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('you-are-not-member');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has paste code here text', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('paste-code-here');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has join input field', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final joinInputField = find.byKey(const Key('join_input_field'));
        expect(joinInputField, findsOneWidget);
      });

      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final joinButton = find.byKey(const Key('join_button'));
        expect(joinButton, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final bottomNavigationFinder = find.byKey(const Key('bottom_navigation'));
        expect(bottomNavigationFinder, findsOneWidget);
      });
    },
  );
}
