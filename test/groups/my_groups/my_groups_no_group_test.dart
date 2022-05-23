import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../wrapper.dart';

void main() {
  group(
    'MyGroups without data',
    () {
      late FakeFirebaseFirestore firestore;
      late MockFirebaseAuth auth;

      setUp(() async {
        // Mock sign in with Google.
        final googleSignIn = MockGoogleSignIn();
        final signinAccount = await googleSignIn.signIn();
        final googleAuth = await signinAccount?.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        // Sign in.
        final user = MockUser(
          isAnonymous: false,
          uid: 'test_uid',
          email: 'test@email.com',
          displayName: 'Test',
        );
        auth = MockFirebaseAuth(mockUser: user);
        await auth.signInWithCredential(credential);

        firestore = FakeFirebaseFirestore();
      });

      testWidgets('MyGroups has my groups header', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final textFinder = find.text('my_groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has no groups title', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final textFinder = find.text('no_groups');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has you are not member text', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final textFinder = find.text('you_are_not_a_member');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has paste code here text', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final textFinder = find.text('paste_code_here');
        expect(textFinder, findsOneWidget);
      });

      testWidgets('MyGroups has join input field', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final joinInputField = find.byKey(const Key('join_input_field'));
        expect(joinInputField, findsOneWidget);
      });

      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final joinButton = find.byKey(const Key('join_button'));
        expect(joinButton, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: MyGroupsPage(firestore: firestore, auth: auth)));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        final bottomNavigationFinder = find.byKey(const Key('bottom_navigation'));
        expect(bottomNavigationFinder, findsOneWidget);
      });
    },
  );
}
