import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('main Page'),
          Button(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Get.offAll(() => LoginPage(firestore: firestore));
            },
            text: 'logout',
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
