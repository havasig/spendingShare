import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/profile/profile_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../wrapper.dart';

void main() {
  group('Profile page test', () {
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
    });

    testWidgets('Profile page has profile header', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      await tester.idle();
      await tester.pump();
      expect(find.text('profile'), findsNWidgets(2));
    });

    testWidgets('Profile page has email input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('email_input')), 'admin@email.com');
      expect(find.text('admin@email.com'), findsOneWidget);
    });

    testWidgets('Profile page has name input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('name_input')), 'my_name');
      expect(find.text('my_name'), findsOneWidget);
    });

    testWidgets('Profile page has password input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('password_input')), 'my_password');
      expect(find.text('my_password'), findsOneWidget);
    });

    testWidgets('Profile page has password confirm input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('password_confirmation_input')), 'my_password_confirm');
      expect(find.text('my_password_confirm'), findsOneWidget);
    });

    testWidgets('Profile page has current money input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('current_money_input')), 'my_current_money');
      expect(find.text('my_current_money'), findsOneWidget);
    });

    testWidgets('Profile page has save changes button', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      expect(find.byKey(const Key('save_button')), findsOneWidget);
    });

    testWidgets('Profile page has delete button', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      expect(find.byKey(const Key('delete_button')), findsOneWidget);
    });

    testWidgets('Profile page has logout button', (WidgetTester tester) async {
      var testWidget = testableWidget(
          child: MultiProvider(providers: [
        Provider(
          create: (context) => SpendingShareUser(
              groups: [],
              categoryData: [],
              color: globals.colors['default']!,
              icon: globals.icons['default']!,
              currency: 'HUF',
              language: 'EN'),
        ),
      ], child: ProfilePage(firestore: firestore, auth: auth)));
      await tester.pumpWidget(testWidget);
      expect(find.byKey(const Key('logout_button')), findsOneWidget);
    });
  });
}
