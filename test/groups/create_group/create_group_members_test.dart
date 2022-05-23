import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/create/create_group_members_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../wrapper.dart';

void main() {
  group(
    'Create group members page',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
      });

      testWidgets('CreateGroupMembersPage has members header', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setColor(Colors.orange);
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupMembersPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('members');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('CreateGroupMembersPage has back button', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setColor(Colors.orange);
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupMembersPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.text('back'), findsOneWidget);
      });

      testWidgets('CreateGroupMembersPage has bottom navigation', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setColor(Colors.orange);
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupMembersPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });

      testWidgets('CreateGroupMembersPage has type name input field', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setColor(Colors.orange);
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupMembersPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('add_member_input_field')), findsOneWidget);
      });

      testWidgets('CreateGroupMembersPage has add member button', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setColor(Colors.orange);
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupMembersPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('add_member_button')), findsOneWidget);
      });

      testWidgets('CreateGroupMembersPage has create group button', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setColor(Colors.orange);
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupMembersPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('create_group_button')), findsOneWidget);
      });
    },
  );
}
