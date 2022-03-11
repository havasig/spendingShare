import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/groups/my_groups.dart';
import 'package:spending_share/ui/widgets/button.dart';

import '../../firebase_options.dart';

class Authentication extends StatelessWidget {
  const Authentication({
    Key? key,
    required this.loginState,
  }) : super(key: key);

  final ApplicationLoginState loginState;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      switch (loginState) {
        case ApplicationLoginState.loggedIn:
          return const MyGroupsPage();
        case ApplicationLoginState.loggedOut:
          return const LoginPage();
        default:
          return Row(
            children: const [
              Text("Internal error, this shouldn't happen..."),
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
