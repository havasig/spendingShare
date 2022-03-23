import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spending_share/ui/groups/my_groups.dart';

import '../wrapper.dart';

void main() {
  group(
    'MyGroups',
    () {
      testWidgets('MyGroups is created', (WidgetTester tester) async {
        final firestore = FakeFirebaseFirestore();
        await firestore.collection('groups').add({
          'name': 'adminokTalalkozoja',
        });

        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
      });

      /*
      testWidgets('MyGroups has join button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final joinFinder = find.text('join');
        expect(joinFinder, findsOneWidget);
      });

      testWidgets('MyGroups has my groups text', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final joinFinder = find.text('my-groups');
        expect(joinFinder, findsOneWidget);
      });

      testWidgets('MyGroups display my groups', (WidgetTester tester) async {
        // TODO
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final joinFinder = find.text('my-groups');
        expect(joinFinder, findsOneWidget);
      });

      testWidgets('MyGroups has add button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: MyGroupsPage(firestore: firestore));
        await tester.pumpWidget(testWidget);
        final Finder fab = find.byTooltip('create_group');
        expect(fab, findsOneWidget);
      });


       */

/*

      testWidgets('Login has password input filed', (WidgetTester tester) async {
        var testWidget = testableWidget(child: const LoginPage());
        await tester.pumpWidget(testWidget);
        await tester.enterText(find.byKey(const Key('password_input')), 'admin');
        final passwordFinder = find.text('admin');
        expect(passwordFinder, findsOneWidget);
      });

      testWidgets('Login has login button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: const LoginPage());
        await tester.pumpWidget(testWidget);
        final buttonFinder = find.widgetWithText(Button, 'login');
        expect(buttonFinder, findsOneWidget);
      });

      testWidgets('Login has forgot password text button', (WidgetTester tester) async {
        var testWidget = testableWidget(child: const LoginPage());
        await tester.pumpWidget(testWidget);
        final forgotPasswordFinder = find.widgetWithText(TextButton, 'forgot-password');
        expect(forgotPasswordFinder, findsOneWidget);
      });

      testWidgets('Login has no account, registration option', (WidgetTester tester) async {
        var testWidget = testableWidget(child: const LoginPage());
        await tester.pumpWidget(testWidget);
        final noAccountTextFinder = find.text('no-account');
        final registrationFinder = find.widgetWithText(TextButton, 'registration-exclamation');
        expect(noAccountTextFinder, findsOneWidget);
        expect(registrationFinder, findsOneWidget);
      });

      testWidgets(
        'Login has has login with google button',
        (WidgetTester tester) async {
          var testWidget = testableWidget(child: const LoginPage());
          await tester.pumpWidget(testWidget);
          final loginWithGoogleButton = find.widgetWithText(Button, 'login-with-google');
          expect(loginWithGoogleButton, findsOneWidget);
        },
      );*/
    },
  );
}
