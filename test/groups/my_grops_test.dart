import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';

import '../wrapper.dart';

void main() {
  group(
    'MyGroups with one group',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
        await firestore.collection('users').doc('currentuserid').set({'name': 'Doe'});
        var user = firestore.collection('users').doc('currentuserid');
        await firestore.collection('groups').add({'name': 'test group', 'icon': 'wallet', 'color': 'orange', 'admin': user});
      });

      testWidgets('MyGroups has my groups header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.text('my-groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.text('join');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has my group', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.text('test group');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has picked icon', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.byIcon(Icons.account_balance_wallet);
        expect(textFinder, findsOneWidget);
      });
    },
  );
  group(
    'MyGroups with two group',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
        await firestore.collection('users').doc('currentuserid').set({'name': 'Doe'});
        var user = firestore.collection('users').doc('currentuserid');
        await firestore.collection('groups').add({'name': 'test group', 'icon': 'wallet', 'color': 'orange', 'admin': user});
        await firestore.collection('groups').add({'name': 'test group 2', 'icon': 'sport', 'color': 'orange', 'admin': user});
      });

      testWidgets('MyGroups has my groups header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.text('my-groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.text('join');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has my groups', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final textFinder = find.text('test group');
        final textTwoFinder = find.text('test group 2');
        expect(textFinder, findsOneWidget);
        expect(textTwoFinder, findsOneWidget);
      });

      testWidgets('MyGroups has picked icons', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        await tester.pump();
        final iconFinder = find.byIcon(Icons.account_balance_wallet);
        final iconTwoFinder = find.byIcon(Icons.directions_run);
        expect(iconFinder, findsOneWidget);
        expect(iconTwoFinder, findsOneWidget);
      });
    },
  );
}
