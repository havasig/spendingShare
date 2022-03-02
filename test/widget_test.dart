import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spending_share/album.dart';
import 'package:spending_share/counter.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/auth/register_page.dart';
import 'package:spending_share/ui/widgets/button.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Login', () {
    testWidgets('Login has every item', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: LoginPage(),
        ),
      ));

      await tester.enterText(find.byKey(const Key('email_input')), 'admin@email.com');
      await tester.enterText(find.byKey(const Key('password_input')), 'admin');

      final emailFinder = find.text('admin@email.com');
      final passwordFinder = find.text('admin@email.com');
      final buttonFinder = find.widgetWithText(Button, 'login');
      final forgotPassword = find.widgetWithText(TextButton, 'forgot-password');

      expect(emailFinder, findsOneWidget);
      expect(passwordFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
      expect(forgotPassword, findsOneWidget);
    });

    testWidgets('Authenticate successfully', (WidgetTester tester) async {});

    testWidgets('Authentication fails', (WidgetTester tester) async {});
  });

  testWidgets('Button is present and triggers navigation after tapped', (WidgetTester tester) async {
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
  });

  group('Counter', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('Counter value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });
    test('Counter value should be descremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });
  group('Counter', () {
    test('value should start at 0', () {
      expect(Counter().value, 0);
    });

    test('Counter value should be incremented', () {
      final counter = Counter();

      counter.increment();

      expect(counter.value, 1);
    });
    test('Counter value should be descremented', () {
      final counter = Counter();

      counter.decrement();

      expect(counter.value, -1);
    });
  });

  group('fetchAlbum', () {
    test('returns an Album if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')))
          .thenAnswer((_) async => http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));

      expect(await fetchAlbum(client), isA<Album>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'))).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchAlbum(client), throwsException);
    });
  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
