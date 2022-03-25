import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/groups/who_are_you.dart';

import '../wrapper.dart';

void main() {
  group(
    'WhoAreYou',
    () {
      late FakeFirebaseFirestore firestore;
      late Stream<QuerySnapshot<Map<String, dynamic>>> group;

      setUpAll(() async {
        firestore = FakeFirebaseFirestore();
      });


      setUp(() async {
        await firestore.collection('groups').add({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
          //TODO add member list and group id
        });
        group = firestore.collection('groups').where('name', isEqualTo: 'adminokTalalkozoja').snapshots();
      });

      testWidgets('WhoAreYou has Who are you header', (WidgetTester tester) async {
        var testWidget = testableWidget(child: WhoAreYou(firestore: firestore, group: group));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('who-are-you');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('WhoAreYou has back button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: WhoAreYou(firestore: firestore, group: group));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('back');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('WhoAreYou has none of these text', (WidgetTester tester) async {
        var testWidget = testableWidget(child: WhoAreYou(firestore: firestore, group: group));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('none-of-these');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('WhoAreYou has join input field', (WidgetTester tester) async {
        var testWidget = testableWidget(child: WhoAreYou(firestore: firestore, group: group));
        await tester.pumpWidget(testWidget);
        final joinInputField = find.byKey(const Key('join_input_field'));
        expect(joinInputField, findsOneWidget);
      });

      testWidgets('WhoAreYou has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: WhoAreYou(firestore: firestore, group: group));
        await tester.pumpWidget(testWidget);
        final joinButton = find.byKey(const Key('join_button'));
        expect(joinButton, findsOneWidget);
      });

      testWidgets('WhoAreYou has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(child: WhoAreYou(firestore: firestore, group: group));
        await tester.pumpWidget(testWidget);
        final bottomNavigationFinder = find.byKey(const Key('bottom_navigation'));
        expect(bottomNavigationFinder, findsOneWidget);
      });
    },
  );
}
