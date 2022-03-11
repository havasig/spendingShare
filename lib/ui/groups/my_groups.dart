import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/group_icon.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'package:spending_share/utils/globals.dart' as globals;

class MyGroupsPage extends StatelessWidget {
  MyGroupsPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        hasForward: true,
        forwardText: 'join'.tr,
        titleText: 'my-groups'.tr,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(
              children: [
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
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('groups').where('name', isEqualTo: 'adminokTalalkozoja').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return const NoGroupsYet(); // TODO ide jon a nincs csoportja kep
                      if (snapshot.hasData && snapshot.data!.docs.isEmpty) return const NoGroupsYet(); // TODO ide jon a nincs csoportja kep
                      return HaveGroups(snapshot: snapshot);
                    }),
              ],
            ),
          ),
        ),
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

class NoGroupsYet extends StatelessWidget {
  const NoGroupsYet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'no-groups'.tr,
            style: TextStyleConstants.body_2_medium,
          ),
          SizedBox(height: h(8)),
          Text(
            'you-are-not-member'.tr,
            style: TextStyleConstants.sub_1,
          ),
          SizedBox(height: h(16)),
          Text(
            'paste-code-here'.tr,
            style: TextStyleConstants.sub_1,
          ),
          SizedBox(height: h(16)),
          InputField(
            focusNode: focusNode,
            hintText: 'join'.tr,
            labelText: 'join'.tr,
            prefixIcon: const Icon(
              Icons.group_add,
              color: ColorConstants.defaultOrange,
            ),
          ),
          SizedBox(height: h(16)),
          Button(
            onPressed: () {},
            text: 'join'.tr,
          )
        ],
      ),
    );
  }
}

class HaveGroups extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  const HaveGroups({Key? key, required this.snapshot}) : super(key: key);

  getGroupItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data?.docs.map((doc) => GroupIcon(onTap: () {}, name: doc['name'], icon: doc['icon'], color: doc['color'],)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: getGroupItems(snapshot),
    );
  }
}
