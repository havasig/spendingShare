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
import 'package:spending_share/ui/groups/settings/group_edit_page.dart';
import 'package:spending_share/ui/groups/settings/group_settings_page.dart';
import 'package:spending_share/ui/groups/settings/group_statistics_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../../wrapper.dart';

void main() {
  /* TODO group statistics test with data
  group(
    'Group statistics page with transaction',
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
          'transactions': [firestore.collection('transactions').doc('transaction')],
          'debts': []
        });

        await firestore.collection('categories').doc('category').set({
          'name': 'category',
          'icon': 'wallet',
          'transactions': [firestore.collection('transactions').doc('transaction')],
        });

        await firestore.collection('transactions').doc('transaction').set({
          'category': firestore.collection('categories').doc('category'),
          'createdBy': firestore.collection('users').doc('currentuserid'),
          'currency': 'HUF',
          'date': Timestamp.now(),
          'exchangeRate': null,
          'from': null,
          'name': 'transaction',
          'to': [firestore.collection('users').doc('currentuserid')],
          'toAmounts': ['100.0'],
          'toWeights': [1],
          'type': 'TransactionType.expense',
          'value': 400.0
        });

        await firestore.collection('members').doc('member').set({
          'name': 'member',
          'icon': 'wallet',
          'transactions': [firestore.collection('transactions').doc('transaction')],
          'userFirebaseId': 'test_uid',
        });
      });


      testWidgets('Group statistics has group name header', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupStatisticsPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
                groupName: 'test group',
              ),
            ));
        await tester.pumpWidget(testWidget);
        expect(find.text('test group'), findsOneWidget);
      });

      testWidgets('Group statistics has time selector', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupStatisticsPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
                groupName: 'test group',
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('time_selector')), findsOneWidget);
      });

      testWidgets('Group statistics has has back button', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupStatisticsPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
                groupName: 'test group',
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('back'), findsOneWidget);
      });

      testWidgets('Group statistics has bottom navigation', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupStatisticsPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
                groupName: 'test group',
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });
    },
  );*/
  group(
    'Group statistics page without transactions',
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

      testWidgets('Group statistics has group name header', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
            Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
          ],
          child: GroupStatisticsPage(
            firestore: firestore,
            groupData: GroupData(
              color: Colors.orange,
              groupId: 'group',
              icon: Icons.account_balance_wallet,
            ),
            groupName: 'test group',
          ),
        ));
        await tester.pumpWidget(testWidget);
        expect(find.text('test group'), findsOneWidget);
      });

      testWidgets('Group statistics has no transaction text', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
            Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
          ],
          child: GroupStatisticsPage(
            firestore: firestore,
            groupData: GroupData(
              color: Colors.orange,
              groupId: 'group',
              icon: Icons.account_balance_wallet,
            ),
            groupName: 'test group',
          ),
        ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('group_no_transactions'), findsOneWidget);
      });

      testWidgets('Group statistics has has back button', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
            Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
          ],
          child: GroupStatisticsPage(
            firestore: firestore,
            groupData: GroupData(
              color: Colors.orange,
              groupId: 'group',
              icon: Icons.account_balance_wallet,
            ),
            groupName: 'test group',
          ),
        ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('back'), findsOneWidget);
      });

      testWidgets('Group statistics has bottom navigation', (WidgetTester tester) async {
        CreateGroupChangeNotifier createGroupChangeNotifier = CreateGroupChangeNotifier();
        createGroupChangeNotifier.init(
            GroupData(
              groupId: '',
              currency: 'HUF',
              icon: Icons.account_balance_wallet,
              color: Colors.orange,
            ),
            'user',
            'firebaseId');
        var testWidget = testableWidget(
            child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => createGroupChangeNotifier),
            Provider(
                create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
          ],
          child: GroupStatisticsPage(
            firestore: firestore,
            groupData: GroupData(
              color: Colors.orange,
              groupId: 'group',
              icon: Icons.account_balance_wallet,
            ),
            groupName: 'test group',
          ),
        ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });
    },
  );
}
