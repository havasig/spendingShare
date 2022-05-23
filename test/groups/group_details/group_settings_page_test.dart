import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/ui/groups/settings/group_settings_page.dart';

import '../../wrapper.dart';

void main() {
  group(
    'Group settings page',
    () {
      late FakeFirebaseFirestore firestore;
      late MockFirebaseAuth auth;

      setUp(() async {
        final googleSignIn = MockGoogleSignIn();
        final signinAccount = await googleSignIn.signIn();
        final googleAuth = await signinAccount?.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        final user = MockUser(
          isAnonymous: false,
          uid: 'test_uid',
          email: 'test@email.com',
          displayName: 'Test',
        );
        auth = MockFirebaseAuth(mockUser: user);
        await auth.signInWithCredential(credential);

        firestore = FakeFirebaseFirestore();
        await firestore.collection('users').doc('currentuserid').set({
          'name': 'Doe',
          'userFirebaseId': 'test_uid',
          'groups': [firestore.collection('groups').doc('group')]
        });

        await firestore.collection('groups').doc('group').set({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
          'adminId': 'test_uid',
          'categories': [],
          'currency': 'HUF',
          'members': [],
          'transactions': [],
          'debts': []
        });
      });

      testWidgets('GroupSettingsPage has group settings header', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.text('group_settings'), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has back button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.text('back'), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has edit button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('edit_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has copy invite link button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('copy_invite_link_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has members button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('members_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has group statistics button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('group_statistics_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has categories button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('categories_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has leave text', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.text('if_you_leave'), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has delete text', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: true,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.text('cannot_leave'), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has leave button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('leave_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has delete button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: true,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('delete_button')), findsOneWidget);
      });

      testWidgets('GroupSettingsPage has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: GroupSettingsPage(
          firestore: firestore,
          groupData: GroupData(
            color: Colors.orange,
            groupId: 'group',
            icon: Icons.account_balance_wallet,
          ),
          isAdmin: false,
          groupName: 'test group',
        ));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });
    },
  );
}
