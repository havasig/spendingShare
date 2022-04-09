import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/ui/widgets/button.dart';

import '../../firebase_options.dart';

class Authentication extends StatelessWidget {
  const Authentication({
    Key? key,
    required this.loginState,
    required this.firestore,
  }) : super(key: key);

  final ApplicationLoginState loginState;
  final FirebaseFirestore firestore;

  static loadUser(BuildContext context, String firebaseUId, FirebaseFirestore firestore) async {
    SpendingShareUser user = Provider.of(context, listen: false);
    user.userFirebaseId = firebaseUId;
    QuerySnapshot<Map<String, dynamic>> firestoreUser =
        await firestore.collection('users').where('userFirebaseId', isEqualTo: user.userFirebaseId).get();
    user.name = firestoreUser.docs.first['name'];
    user.color = firestoreUser.docs.first['color'];
    user.currency = firestoreUser.docs.first['currency'];
    user.icon = firestoreUser.docs.first['icon'];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      switch (loginState) {
        case ApplicationLoginState.loggedIn:
          loadUser(context, FirebaseAuth.instance.currentUser!.uid, firestore);
          return MyGroupsPage(firestore: firestore);
        case ApplicationLoginState.loggedOut:
          return LoginPage(firestore: firestore);
        default:
          return Row(
            children: const [
              Text('Internal error, this shouldn\'t happen...'),
            ],
          );
      }
    });
  }

  void showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Button(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'OK',
            ),
          ],
        );
      },
    );
  }
}

enum ApplicationLoginState { loggedOut, loggedIn }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState get loginState => _loginState;
}
