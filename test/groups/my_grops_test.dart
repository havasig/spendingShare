import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/groups/my_groups.dart';

import '../wrapper.dart';

void main() {
  group(
    'MyGroups with one group',
    () {
      late FakeFirebaseFirestore firestore;

      setUpAll(() async {
        firestore = FakeFirebaseFirestore();
      });

      setUp(() async {
        await firestore.collection('groups').add({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
        });
      });

      /* TODO igy kell tesztelni a create-t
      firebase.assertSucceeds(app.firestore().collection("public").doc("test-document").get());

       */

      testWidgets('MyGroups has my groups header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('my-groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('join');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has my group', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('test group');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has picked icon', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.byIcon(Icons.account_balance_wallet);
        expect(textFinder, findsOneWidget);
      });
    },
  );
  group(
    'MyGroups with two group',
    () {
      late FakeFirebaseFirestore firestore;

      setUpAll(() async {
        firestore = FakeFirebaseFirestore();
      });

      setUp(() async {
        await firestore.collection('groups').add({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
        });
        await firestore.collection('groups').add({
          'name': 'test group two',
          'icon': 'sport',
          'color': 'green',
        });
      });

      testWidgets('MyGroups has my groups header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('my-groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('join');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has my groups', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('test group');
        final textTwoFinder = find.text('test group two');
        expect(textFinder, findsOneWidget);
        expect(textTwoFinder, findsOneWidget);
      });

      testWidgets('MyGroups has picked icons', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final iconFinder = find.byIcon(Icons.account_balance_wallet);
        final iconTwoFinder = find.byIcon(Icons.directions_run);
        expect(iconFinder, findsOneWidget);
        expect(iconTwoFinder, findsOneWidget);
      });
    },
  );
}
