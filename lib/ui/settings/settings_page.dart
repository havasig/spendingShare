import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/groups/who_are_you.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  CollectionReference get users => firestore.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'full_name': 'fullName', // John Doe
          'company': 'company', // Stokes and Sons
          'age': 42 // 42
        })
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('main Page'),
          Button(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginPage(firestore: firestore));
            },
            text: 'logout',
          ),
          TextButton(
            onPressed: addUser,
            child: Text(
              'Add User',
            ),
          ),
          TextButton(
            onPressed: () async {
              var group = await firestore.collection('groups').doc('BogfSst9NagxAHtnt5XJ').get();
              Get.to(() => WhoAreYou(firestore: firestore, group: Group.fromDocument(group)));
            },
            child: Text(
              'Who are you?',
            ),
          ),
        ],
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 2,
        firestore: firestore,
      ),
    );
  }
}
