import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/who_are_you.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../wrapper.dart';

void main() {
  group(
    'WhoAreYou',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
        await firestore.collection('users').doc('memberOne').set({'name': 'John'});
        await firestore.collection('users').doc('memberTwo').set({'name': 'Doe'});
        var memberOne = firestore.collection('users').doc('memberOne');
        var memberTwo = firestore.collection('users').doc('memberTwo');
        await firestore.collection('groups').doc('group').set({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
          'admin': memberOne,
          'members': [memberOne, memberTwo]
        });
      });

      testWidgets('WhoAreYou has Who are you header', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: WhoAreYou(firestore: firestore, groupId: 'group', color: Colors.orange)));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('who_are_you');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('WhoAreYou has back button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: WhoAreYou(firestore: firestore, groupId: 'group', color: Colors.orange)));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('back');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('WhoAreYou has none of these text', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: WhoAreYou(firestore: firestore, groupId: 'group', color: Colors.orange)));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('none_of_these');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('WhoAreYou has join input field', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: WhoAreYou(firestore: firestore, groupId: 'group', color: Colors.orange)));
        await tester.pumpWidget(testWidget);
        final joinInputField = find.byKey(const Key('join_input_field'));
        expect(joinInputField, findsOneWidget);
      });

      testWidgets('WhoAreYou has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: WhoAreYou(firestore: firestore, groupId: 'group', color: Colors.orange)));
        await tester.pumpWidget(testWidget);
        final joinButton = find.byKey(const Key('join_button'));
        expect(joinButton, findsOneWidget);
      });

      testWidgets('WhoAreYou has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: WhoAreYou(firestore: firestore, groupId: 'group', color: Colors.orange)));
        await tester.pumpWidget(testWidget);
        final bottomNavigationFinder = find.byKey(const Key('bottom_navigation'));
        expect(bottomNavigationFinder, findsOneWidget);
      });
    },
  );
}
