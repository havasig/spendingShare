import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/create/create_group_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../wrapper.dart';

void main() {
  group(
    'Create group page',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
      });

      testWidgets('CreateGroupPage has create group header', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        final textFinder = find.text('create_group');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('CreateGroupPage has name input field', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        final nameInputField = find.byKey(const Key('group_name_input'));
        expect(nameInputField, findsOneWidget);
      });

      testWidgets('CreateGroupPage has select currency dropdown', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('select_currency_dropdown')), findsOneWidget);
      });

      testWidgets('CreateGroupPage default currency selected', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) => SpendingShareUser(
                  groups: [], categoryData: [], color: globals.colors['default']!, icon: globals.icons['default']!, currency: 'HUF')),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(createGroupChangeNotifier.currency, 'HUF');
      });

      testWidgets('CreateGroupPage has select color', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('select_color')), findsOneWidget);
      });

      testWidgets('CreateGroupPage default color selected', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) =>
                  SpendingShareUser(groups: [], categoryData: [], color: Colors.green, icon: globals.icons['default']!, currency: 'HUF')),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(createGroupChangeNotifier.color, Colors.green);
      });

      testWidgets('CreateGroupPage has select icon', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('select_icon')), findsOneWidget);
      });

      testWidgets('CreateGroupPage default icon selected', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
          Provider(
              create: (context) =>
                  SpendingShareUser(groups: [], categoryData: [], color: Colors.green, icon: Icons.directions_run, currency: 'HUF')),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(createGroupChangeNotifier.icon, Icons.directions_run);
      });

      testWidgets('CreateGroupPage has back button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) =>
                  SpendingShareUser(groups: [], categoryData: [], color: Colors.green, icon: Icons.directions_run, currency: 'HUF')),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.text('back'), findsOneWidget);
      });

      testWidgets('CreateGroupPage has next button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) =>
                  SpendingShareUser(groups: [], categoryData: [], color: Colors.green, icon: Icons.directions_run, currency: 'HUF')),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('next')), findsOneWidget);
      });

      testWidgets('CreateGroupPage has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          Provider(
              create: (context) =>
                  SpendingShareUser(groups: [], categoryData: [], color: Colors.green, icon: Icons.directions_run, currency: 'HUF')),
        ], child: CreateGroupPage(firestore: firestore)));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });
    },
  );
}
