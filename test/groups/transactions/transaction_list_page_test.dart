import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/ui/transactions/transaction_list_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../wrapper.dart';

void main() {
  group(
    'TransactionListPage with transactions',
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
        await firestore.collection('users').doc('currentuserid').set({
          'name': 'Doe',
          'userFirebaseId': 'test_uid',
          'groups': [firestore.collection('groups').doc('new_group')]
        });

        await firestore.collection('members').doc('member').set({
          'name': 'member',
          'icon': 'wallet',
          'transactions': [firestore.collection('transactions').doc('transaction')],
          'userFirebaseId': 'test_uid',
        });

        await firestore.collection('transactions').doc('transaction').set({
          'category': firestore.collection('categories').doc('category'),
          'createdBy': firestore.collection('users').doc('currentuserid'),
          'currency': 'HUF',
          'date': Timestamp.now(),
          'exchangeRate': null,
          'from': firestore.collection('members').doc('member'),
          'name': 'new_transaction',
          'to': [firestore.collection('members').doc('member')],
          'toAmounts': ['100.0'],
          'toWeights': [1],
          'type': 'TransactionType.expense',
          'value': 400.0
        });

        await firestore.collection('groups').doc('new_group').set({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
          'adminId': 'test_uid',
          'categories': [],
          'currency': 'HUF',
          'members': [firestore.collection('members').doc('member')],
          'transactions': [firestore.collection('transactions').doc('transaction')],
          'debts': []
        });
      });

      testWidgets('TransactionListPage has transactions header', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    ),
                child: TransactionListPage(
                  firestore: firestore,
                  groupData: GroupData(
                    color: Colors.orange,
                    groupId: 'group',
                    icon: Icons.account_balance_wallet,
                  ),
                  transactionsDocumentReference: [firestore.collection('transactions').doc('transaction')],
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('transactions'), findsOneWidget);
      });

      testWidgets('TransactionListPage show item', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    ),
                child: TransactionListPage(
                  firestore: firestore,
                  groupData: GroupData(
                    color: Colors.orange,
                    groupId: 'group',
                    icon: Icons.account_balance_wallet,
                  ),
                  transactionsDocumentReference: [firestore.collection('transactions').doc('transaction')],
                )));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('new_transaction')), findsOneWidget);
      });


      testWidgets('TransactionListPage has back button', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: TransactionListPage(
                  firestore: firestore,
                  groupData: GroupData(
                    color: Colors.orange,
                    groupId: 'group',
                    icon: Icons.account_balance_wallet,
                  ),
                  transactionsDocumentReference: [firestore.collection('transactions').doc('transaction')],
                )));
        await tester.pumpWidget(testWidget);
        expect(find.text('back'), findsOneWidget);
      });


      testWidgets('TransactionListPage has bottom navigation', (WidgetTester tester) async {
        var testWidget = testableWidget(
            child: Provider(
                create: (context) => SpendingShareUser(
                  groups: [],
                  categoryData: [],
                  color: globals.colors['default']!,
                  icon: globals.icons['default']!,
                ),
                child: TransactionListPage(
                  firestore: firestore,
                  groupData: GroupData(
                    color: Colors.orange,
                    groupId: 'group',
                    icon: Icons.account_balance_wallet,
                  ),
                  transactionsDocumentReference: [firestore.collection('transactions').doc('transaction')],
                )));
        await tester.pumpWidget(testWidget);
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });
    },
  );
  group(
    'MyGroups with two group',
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
        await firestore.collection('users').doc('currentuserid').set({
          'name': 'Doe',
          'userFirebaseId': 'test_uid',
          'groups': [firestore.collection('groups').doc('new_group1'), firestore.collection('groups').doc('new_group2')]
        });

        await firestore.collection('groups').doc('new_group1').set({
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

        await firestore.collection('groups').doc('new_group2').set({
          'name': 'test group 2',
          'icon': 'sport',
          'color': 'orange',
          'adminId': 'test_uid',
          'categories': [],
          'currency': 'HUF',
          'members': [],
          'transactions': [],
          'debts': []
        });
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
        await tester.pump();
        final textFinder = find.text('my_groups');
        expect(textFinder, findsOneWidget);
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
        await tester.pump();
        final textFinder = find.text('join');
        expect(textFinder, findsOneWidget);
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
        await tester.pump();
        final createGroupFinder = find.byKey(const Key('create_group'));
        expect(createGroupFinder, findsOneWidget);
      });

      testWidgets('MyGroups has my groups', (WidgetTester tester) async {
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
        await tester.pump();
        final textFinder = find.text('test group');
        final textTwoFinder = find.text('test group 2');
        expect(textFinder, findsOneWidget);
        expect(textTwoFinder, findsOneWidget);
      });

      testWidgets('MyGroups has picked icons', (WidgetTester tester) async {
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
        await tester.pump();
        final iconFinder = find.byIcon(Icons.account_balance_wallet);
        final iconTwoFinder = find.byIcon(Icons.directions_run);
        expect(iconFinder, findsOneWidget);
        expect(iconTwoFinder, findsOneWidget);
      });
    },
  );
}
