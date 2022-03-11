import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
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
          .then((value) => print('User Added'))
          .catchError((error) => print('Failed to add user: $error'));
    }

    return Scaffold(
      appBar: SpendingShareAppBar(
        hasBack: false,
        hasForward: true,
        forwardText: 'join'.tr,
        titleText: 'my-groups'.tr,
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
              'Add User',
            ),
          ),
        ]),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          key: const Key('create_group'),
          tooltip: 'create_group',
          backgroundColor: ColorConstants.defaultOrange,
          splashColor: ColorConstants.lightGray,
          onPressed: () {},
          //shape: const StadiumBorder(side: BorderSide(color: ColorConstants.darkGray, width: 4)),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: const SpendingShareBottomNavigationBar(selectedIndex: 1),
    );
  }
}
