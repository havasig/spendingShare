import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/my_appbar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': 'fullName', // John Doe
            'company': 'company', // Stokes and Sons
            'age': 42 // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      appBar: MyAppBar(
        hasBack: true,
        hasForward: true,
        backText: "Back",
        forwardText: "Forward",
        titleText: "Title",
      ),
        body: Padding(
      padding: EdgeInsets.all(h(16)),
      child: Column(children: [
        Text('main Page'),
        Button(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.offAll(() => LoginPage());
          },
          text: 'logout',
        ),
        TextButton(
          onPressed: addUser,
          child: Text(
            "Add User",
          ),
        ),
      ]),
    ));
  }
}
