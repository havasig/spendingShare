import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/settings/settings_page.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../wrapper.dart';

void main() {
  group(
    'Settings page test',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
      });

      testWidgets('SettingsPage has settings header', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('settings'), findsNWidgets(2));
      });

      testWidgets('SettingsPage has default currency dropdown', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('default_currency_dropdown')), findsOneWidget);
      });

      testWidgets('SettingsPage has default language dropdown', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('default_language_dropdown')), findsOneWidget);
      });

      testWidgets('SettingsPage has default color selector', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('default_color_selector')), findsOneWidget);
      });

      testWidgets('SettingsPage has default icon selector', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('default_icon_selector')), findsOneWidget);
      });

      testWidgets('SettingsPage has add category button', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('create_category_data_fab')), findsOneWidget);
      });

      testWidgets('SettingsPage has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
          child: MultiProvider(providers: [
            ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
            Provider(
              create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                  currency: 'HUF',
                  language: 'EN'),
            ),
          ], child: SettingsPage(firestore: firestore)),
        );
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });
    },

    //TODO test already created categories, test popup
  );
}
