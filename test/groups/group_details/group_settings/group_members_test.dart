
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/settings/group_edit_page.dart';
import 'package:spending_share/ui/groups/settings/group_settings_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../../wrapper.dart';

void main() {
  /* TODO group members test (no need, same as create group members page)
  group(
    'Group edit page',
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

      testWidgets('GroupEditPage has edit group header', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.setCurrencyNoNotify('HUF');
        createGroupChangeNotifier.setCurrency('HUF');
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
            ], child: GroupEditPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        expect(find.text('edit_group'), findsOneWidget);
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
  );*/
}
