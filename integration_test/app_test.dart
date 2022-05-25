import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/main.dart' as app;
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/auth/authentication.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration tests', () {
    testWidgets('Create group integration test', (WidgetTester tester) async {
      FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('currentuserid').set({
        'color': 'default',
        'icon': 'default',
        'name': 'HavaG',
        'currency': 'HUF',
        'currentMoney': 0,
        'groups': [],
        'language': 'EN',
        'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
        //'groups': [firestore.collection('groups').doc('new_group')]
      });

      /*await firestore.collection('groups').doc('new_group').set({
        'name': 'test group',
        'icon': 'wallet',
        'color': 'orange',
        'adminId': 'test_uid',
        'categories': [],
        'currency': 'HUF',
        'members': [],
        'transactions': [],
        'debts': []
      });*/

      var widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ApplicationState()),
          ChangeNotifierProvider(create: (context) => CreateTransactionChangeNotifier()),
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
          Provider(create: (context) => CreateTransactionData()),
        ],
        child: app.MyApp(firestore: firestore),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final Finder login = find.byKey(const Key('login_button'));
      tester.tap(login);
      await addDelay(3);
      await tester.pumpAndSettle();

      await addDelay(3);
      final Finder createGroupFab = find.byKey(const Key('create_group'));
      tester.tap(createGroupFab);
      await addDelay(3);
      await tester.pumpAndSettle();

      await addDelay(3);
      await tester.enterText(find.byKey(const Key('group_name_input')), 'my-group');
      await addDelay(3);
      await tester.pumpAndSettle();

      await addDelay(3);
      final Finder nextButton = find.byKey(const Key('next'));
      tester.tap(nextButton);
      await addDelay(3);
      await tester.pumpAndSettle();

      await addDelay(3);
      await tester.enterText(find.byKey(const Key('add_member_input_field')), 'partner');
      await addDelay(3);
      await tester.pumpAndSettle();

      await addDelay(3);
      final Finder addMemberButton = find.byKey(const Key('add_member_button'));
      tester.tap(addMemberButton);
      await addDelay(3);
      await tester.pumpAndSettle();

      await addDelay(3);
      final Finder createGroupButton = find.byKey(const Key('create_group_button'));
      tester.tap(createGroupButton);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      //Test database if group is created
      QuerySnapshot querySnapshot = await firestore.collection('groups').where('adminId', isEqualTo: 'kZPJ9226hOM5yLFqLofrf2Nr5Y83').get();
      expect(querySnapshot.size, 1);

      await addDelay(3);
    });

    testWidgets('Add expense integration test', (WidgetTester tester) async {
      FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('currentuserid').set({
        'color': 'default',
        'icon': 'default',
        'name': 'HavaG',
        'currency': 'HUF',
        'currentMoney': 0,
        'language': 'EN',
        'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
        'groups': [firestore.collection('groups').doc('new_group')]
      });

      await firestore.collection('members').doc('member').set({
        'name': 'HavaG',
        'icon': 'default',
        'transactions': [],
        'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
      });

      await firestore.collection('categories').doc('category').set({
        'name': 'test category',
        'icon': 'wallet',
        'transactions': [],
      });

      await firestore.collection('groups').doc('new_group').set({
        'name': 'test group',
        'icon': 'wallet',
        'color': 'orange',
        'adminId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
        'categories': [firestore.collection('categories').doc('category')],
        'currency': 'HUF',
        'members': [firestore.collection('members').doc('member')],
        'transactions': [],
        'debts': []
      });

      var widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ApplicationState()),
          ChangeNotifierProvider(create: (context) => CreateTransactionChangeNotifier()),
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
          Provider(create: (context) => CreateTransactionData()),
        ],
        child: app.MyApp(firestore: firestore),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final Finder login = find.byKey(const Key('login_button'));
      tester.tap(login);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder testGroupCircleIcon = find.byKey(const Key('test group_button'));
      tester.tap(testGroupCircleIcon);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder createTransactionFab = find.byKey(const Key('create_transaction_button'));
      tester.tap(createTransactionFab);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder one = find.byKey(const Key('1'));
      tester.tap(one);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder zero = find.byKey(const Key('0'));
      tester.tap(zero);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder plus = find.byKey(const Key('+'));
      tester.tap(plus);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder five = find.byKey(const Key('5'));
      tester.tap(five);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder equals = find.byKey(const Key('='));
      tester.tap(equals);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder next = find.byKey(const Key('next'));
      tester.tap(next);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder save = find.byKey(const Key('save_expense'));
      tester.tap(save);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      //Test database if transaction is created
      QuerySnapshot querySnapshot =
          await firestore.collection('transactions').where('from', isEqualTo: firestore.collection('members').doc('member')).get();
      expect(querySnapshot.size, 1);

      await addDelay(3);
    });

    testWidgets('Add income integration test', (WidgetTester tester) async {
      FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('currentuserid').set({
        'color': 'default',
        'icon': 'default',
        'name': 'HavaG',
        'currency': 'HUF',
        'currentMoney': 0,
        'language': 'EN',
        'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
        'groups': [firestore.collection('groups').doc('new_group')]
      });

      await firestore.collection('members').doc('member').set({
        'name': 'HavaG',
        'icon': 'default',
        'transactions': [],
        'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
      });

      await firestore.collection('categories').doc('category').set({
        'name': 'test category',
        'icon': 'wallet',
        'transactions': [],
      });

      await firestore.collection('groups').doc('new_group').set({
        'name': 'test group',
        'icon': 'wallet',
        'color': 'orange',
        'adminId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
        'categories': [firestore.collection('categories').doc('category')],
        'currency': 'HUF',
        'members': [firestore.collection('members').doc('member')],
        'transactions': [],
        'debts': []
      });

      var widget = MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ApplicationState()),
          ChangeNotifierProvider(create: (context) => CreateTransactionChangeNotifier()),
          ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
          ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
          Provider(
              create: (context) => SpendingShareUser(
                    groups: [],
                    categoryData: [],
                    color: globals.colors['default']!,
                    icon: globals.icons['default']!,
                  )),
          Provider(create: (context) => CreateTransactionData()),
        ],
        child: app.MyApp(firestore: firestore),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      final Finder login = find.byKey(const Key('login_button'));
      tester.tap(login);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder testGroupCircleIcon = find.byKey(const Key('test group_button'));
      tester.tap(testGroupCircleIcon);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder createTransactionFab = find.byKey(const Key('create_transaction_button'));
      tester.tap(createTransactionFab);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder selectTypeDropdown = find.byKey(const Key('dropdown_button_type'));
      tester.tap(selectTypeDropdown);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder income = find.byKey(const Key('income'));
      tester.tap(income);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder one = find.byKey(const Key('1'));
      tester.tap(one);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder zero = find.byKey(const Key('0'));
      tester.tap(zero);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder plus = find.byKey(const Key('+'));
      tester.tap(plus);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder five = find.byKey(const Key('5'));
      tester.tap(five);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder equals = find.byKey(const Key('='));
      tester.tap(equals);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder next = find.byKey(const Key('next'));
      tester.tap(next);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      await addDelay(3);
      final Finder save = find.byKey(const Key('save_income'));
      tester.tap(save);
      await addDelay(3);
      await tester.pumpAndSettle();
      await addDelay(3);

      //Test database if transaction is created
      QuerySnapshot querySnapshot = await firestore.collection('transactions').where('value', isEqualTo: 15).get();
      expect(querySnapshot.size, 1);

      await addDelay(3);
    });
  });

  testWidgets('Add transfer integration test', (WidgetTester tester) async {
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('currentuserid').set({
      'color': 'default',
      'icon': 'default',
      'name': 'HavaG',
      'currency': 'HUF',
      'currentMoney': 0,
      'language': 'EN',
      'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
      'groups': [firestore.collection('groups').doc('new_group')]
    });

    await firestore.collection('members').doc('member1').set({
      'name': 'HavaG',
      'icon': 'default',
      'transactions': [],
      'userFirebaseId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
    });

    await firestore.collection('members').doc('member2').set({
      'name': 'friend',
      'icon': 'default',
      'transactions': [],
      'userFirebaseId': null,
    });

    await firestore.collection('categories').doc('category').set({
      'name': 'test category',
      'icon': 'wallet',
      'transactions': [],
    });

    await firestore.collection('groups').doc('new_group').set({
      'name': 'test group',
      'icon': 'wallet',
      'color': 'orange',
      'adminId': 'kZPJ9226hOM5yLFqLofrf2Nr5Y83',
      'categories': [firestore.collection('categories').doc('category')],
      'currency': 'HUF',
      'members': [firestore.collection('members').doc('member1'), firestore.collection('members').doc('member2')],
      'transactions': [],
      'debts': []
    });

    var widget = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationState()),
        ChangeNotifierProvider(create: (context) => CreateTransactionChangeNotifier()),
        ChangeNotifierProvider(create: (context) => CreateGroupChangeNotifier()),
        ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
        Provider(
            create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                )),
        Provider(create: (context) => CreateTransactionData()),
      ],
      child: app.MyApp(firestore: firestore),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    final Finder login = find.byKey(const Key('login_button'));
    tester.tap(login);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder testGroupCircleIcon = find.byKey(const Key('test group_button'));
    tester.tap(testGroupCircleIcon);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder createTransactionFab = find.byKey(const Key('create_transaction_button'));
    tester.tap(createTransactionFab);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder selectTypeDropdown = find.byKey(const Key('dropdown_button_type'));
    tester.tap(selectTypeDropdown);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder income = find.byKey(const Key('transfer'));
    tester.tap(income);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder one = find.byKey(const Key('1'));
    tester.tap(one);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder zero = find.byKey(const Key('0'));
    tester.tap(zero);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder plus = find.byKey(const Key('+'));
    tester.tap(plus);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder five = find.byKey(const Key('5'));
    tester.tap(five);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder equals = find.byKey(const Key('='));
    tester.tap(equals);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder next = find.byKey(const Key('next'));
    tester.tap(next);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder member = find.byKey(const Key('friend_member'));
    tester.tap(member);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    await addDelay(3);
    final Finder save = find.byKey(const Key('save_transfer'));
    tester.tap(save);
    await addDelay(3);
    await tester.pumpAndSettle();
    await addDelay(3);

    //Test database if transaction is created
    QuerySnapshot querySnapshot =
        await firestore.collection('transactions').where('from', isEqualTo: firestore.collection('members').doc('member1')).get();
    expect(querySnapshot.size, 1);

    await addDelay(3);
  });
}

Future<void> addDelay(int s) async {
  await Future<void>.delayed(Duration(seconds: s));
}
