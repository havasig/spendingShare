import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(h(16)),
      child: Column(children: [
        Text('main Page'),
        Button(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.to(() => LoginPage());
          },
          text: 'logout',
        )
      ]),
    ));
  }
}
