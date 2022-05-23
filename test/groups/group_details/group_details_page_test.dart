import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/details/group_details_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../wrapper.dart';

void main() {
  group(
    'Group details page',
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

      testWidgets('GroupDetails has group name header', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
              Provider(
                  create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
            ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('test group'), findsOneWidget);
      });

      testWidgets('GroupDetails has settings button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
              Provider(
                  create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
            ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('settings'), findsNWidgets(2));
      });

      testWidgets('GroupDetails has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });

      testWidgets('GroupDetails has members', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('members')), findsOneWidget);
      });

      testWidgets('GroupDetails has categories', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('categories')), findsOneWidget);
      });

      testWidgets('GroupDetails has debt list', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('debt_list')), findsOneWidget);
      });

      testWidgets('GroupDetails has transaction list', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('transaction_list')), findsOneWidget);
      });

      testWidgets('GroupDetails has statistics', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('statistics')), findsOneWidget);
      });

      testWidgets('GroupDetails has add transaction button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: MultiProvider(
                providers: [
                  Provider(
                      create: (context) => SpendingShareUser(
                        groups: [],
                        categoryData: [],
                        color: globals.colors['default']!,
                        icon: globals.icons['default']!,
                      )),
                ],
                child: GroupDetailsPage(
                  firestore: firestore,
                  groupId: 'group',
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('create_transaction_button')), findsOneWidget);
      });
    },
  );
}
