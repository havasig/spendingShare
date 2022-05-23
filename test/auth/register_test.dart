import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/auth/register_page.dart';
import 'package:spending_share/ui/widgets/button.dart';

import '../wrapper.dart';

void main() {
  group('Register', () {
    final firestore = FakeFirebaseFirestore();

    testWidgets('Register is created', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
    });

    testWidgets('Register has name input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('name_input')), 'admin');
      final nameFinder = find.text('admin');
      expect(nameFinder, findsOneWidget);
    });

    testWidgets('Register has email input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('email_input')), 'admin@email.com');
      final emailFinder = find.text('admin@email.com');
      expect(emailFinder, findsOneWidget);
    });

    testWidgets('Register has password input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('password_input')), 'admin');
      final passwordFinder = find.text('admin');
      expect(passwordFinder, findsOneWidget);
    });

    testWidgets('Register has password confirmation input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('password_confirmation_input')), 'admin');
      final passwordConfirmationFinder = find.text('admin');
      expect(passwordConfirmationFinder, findsOneWidget);
    });

    testWidgets('Register has sign up button', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      final buttonFinder = find.widgetWithText(Button, 'sign_up');
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('Register has already have account, login option', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      final noAccountTextFinder = find.text('already_have_account');
      final registrationFinder = find.widgetWithText(TextButton, 'login');
      expect(noAccountTextFinder, findsOneWidget);
      expect(registrationFinder, findsOneWidget);
    });

    testWidgets('Register has has sign up with google button', (WidgetTester tester) async {
      var testWidget = testableWidget(child: RegisterPage(firestore: firestore));
      await tester.pumpWidget(testWidget);
      final signUpWithGoogleButton = find.widgetWithText(Button, 'sign_up_with_google');
      expect(signUpWithGoogleButton, findsOneWidget);
    });
  });
}
