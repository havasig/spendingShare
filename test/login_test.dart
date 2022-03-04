import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spending_share/ui/widgets/button.dart';

class _Wrapper extends StatelessWidget {
  final Widget child;

  const _Wrapper(this.child);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(const BoxConstraints(), context: context);
    return child;
  }
}

Widget testableWidget({required Widget child}) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: GetMaterialApp(
      home: Scaffold(body: _Wrapper(child)),
    ),
  );
}

void main() {
  group('Login', () {
    testWidgets('Login is created', (WidgetTester tester) async {
      var testWidget = testableWidget(child: const LoginPage());
      await tester.pumpWidget(testWidget);
    });

    testWidgets('Login has email input filed', (WidgetTester tester) async {
      var testWidget = testableWidget(child: const LoginPage());
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byKey(const Key('email_input')), 'admin@email.com');
      final emailFinder = find.text('admin@email.com');
      expect(emailFinder, findsOneWidget);
    });

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
      final registrationFinder = find.widgetWithText(TextButton, 'registration');
      expect(noAccountTextFinder, findsOneWidget);
      expect(registrationFinder, findsOneWidget);
    });

    testWidgets('Login has has login with google button', (WidgetTester tester) async {
      var testWidget = testableWidget(child: const LoginPage());
      await tester.pumpWidget(testWidget);
      final loginWithGoogleButton = find.widgetWithText(Button, 'login-with-google');
      expect(loginWithGoogleButton, findsOneWidget);
    });
  });

  /* TODO navigation, on press testing
  testWidgets('Button is present and triggers navigation after tapped',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(
          body: LoginPage(),
        ),
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byKey(const Key('registration')), findsOneWidget);
    await tester.tap(find.byKey(const Key('registration')));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    //verify(mockObserver.didPush(any, any));

    /// You'd also want to be sure that your page is now
    /// present in the screen.
    expect(find.byType(RegisterPage), findsOneWidget);
  });*/


}
