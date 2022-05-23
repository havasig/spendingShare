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
import 'package:spending_share/ui/groups/settings/group_categories_page.dart';
import 'package:spending_share/ui/groups/settings/group_edit_page.dart';
import 'package:spending_share/ui/groups/settings/group_settings_page.dart';
import 'package:spending_share/ui/groups/settings/group_statistics_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/widgets/dialogs/helpers/select_icon_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../../wrapper.dart';

void main() {
  group(
    'Group categories page',
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

        await firestore.collection('categories').doc('category').set({
          'name': 'test category',
          'icon': 'wallet',
          'transactions': [],
        });

        await firestore.collection('groups').doc('group').set({
          'name': 'test group',
          'icon': 'wallet',
          'color': 'orange',
          'adminId': 'test_uid',
          'categories': [firestore.collection('categories').doc('category')],
          'currency': 'HUF',
          'members': [],
          'transactions': [firestore.collection('transactions').doc('transaction')],
          'debts': []
        });
      });


      testWidgets('Group categories has categories header', (WidgetTester tester) async {
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
                ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupCategoriesPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        expect(find.text('categories'), findsOneWidget);
      });

      testWidgets('Group categories has one category', (WidgetTester tester) async {
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
                ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupCategoriesPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('test category_key')), findsOneWidget);
      });

      testWidgets('Group categories has one category close button', (WidgetTester tester) async {
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
                ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupCategoriesPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('test category_close_button')), findsOneWidget);
      });

      testWidgets('Group categories has add category button', (WidgetTester tester) async {
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
                ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupCategoriesPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('create_category_button')), findsOneWidget);
      });

      testWidgets('Group categories has back button', (WidgetTester tester) async {
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
                ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupCategoriesPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.text('back'), findsOneWidget);
      });

      testWidgets('Group categories has bottom navigation', (WidgetTester tester) async {
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
                ChangeNotifierProvider(create: (context) => SelectIconChangeNotifier()),
                Provider(
                    create: (context) => SpendingShareUser(
                      groups: [],
                      categoryData: [],
                      color: globals.colors['default']!,
                      icon: globals.icons['default']!,
                    )),
              ],
              child: GroupCategoriesPage(
                firestore: firestore,
                groupData: GroupData(
                  color: Colors.orange,
                  groupId: 'group',
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ));
        await tester.pumpWidget(testWidget);
        await tester.idle();
        await tester.pump();
        expect(find.byKey(const Key('bottom_navigation')), findsOneWidget);
      });

      //TODO test add category popup
    },
  );
}
