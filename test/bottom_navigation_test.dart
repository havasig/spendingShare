import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';

import 'wrapper.dart';

void main() {
  group(
    'BottomNavigation',
    () {
      late FakeFirebaseFirestore firestore;

      setUp(() async {
        firestore = FakeFirebaseFirestore();
      });

      testWidgets('BottomNavigation has statistics', (WidgetTester tester) async {
        var testWidget = testableWidget(child: SpendingShareBottomNavigationBar(firestore: firestore, selectedIndex: 0));
        await tester.pumpWidget(testWidget);
        expect(find.text('statistics'), findsOneWidget);
        expect(find.byIcon(Icons.bar_chart), findsOneWidget);
      });

      testWidgets('BottomNavigation has groups', (WidgetTester tester) async {
        var testWidget = testableWidget(child: SpendingShareBottomNavigationBar(firestore: firestore, selectedIndex: 0));
        await tester.pumpWidget(testWidget);
        expect(find.text('groups'), findsOneWidget);
        expect(find.byIcon(Icons.group), findsOneWidget);
      });

      testWidgets('BottomNavigation has settings', (WidgetTester tester) async {
        var testWidget = testableWidget(child: SpendingShareBottomNavigationBar(firestore: firestore, selectedIndex: 0));
        await tester.pumpWidget(testWidget);
        expect(find.text('settings'), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('BottomNavigation has profile', (WidgetTester tester) async {
        var testWidget = testableWidget(child: SpendingShareBottomNavigationBar(firestore: firestore, selectedIndex: 0));
        await tester.pumpWidget(testWidget);
        expect(find.text('profile'), findsOneWidget);
        expect(find.byIcon(Icons.account_circle), findsOneWidget);
      });
    },
  );
}
