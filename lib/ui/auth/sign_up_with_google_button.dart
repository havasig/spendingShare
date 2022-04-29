import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spending_share/ui/auth/authentication.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/ui/widgets/button.dart';

class SingUpWithGoogleButton extends StatelessWidget {
  const SingUpWithGoogleButton({Key? key, required this.firestore, required this.text}) : super(key: key);

  final String text;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Button(
      textColor: ColorConstants.white.withOpacity(0.8),
      buttonColor: ColorConstants.lightGray,
      onPressed: () async {
        await signInWithGoogle().then((value) async {
          await createUserIfNotExists(value.user!);
          Authentication.loadUser(context, value.user!.uid, firestore);
          Get.offAll(() => MyGroupsPage(firestore: firestore));
        });
      },
      text: text,
      prefixWidget: SvgPicture.asset('assets/graphics/icons/google_logo.svg'),
      suffixWidget: Icon(
        Icons.arrow_forward_ios,
        color: ColorConstants.white.withOpacity(0.8),
      ),
    );
  }

  Future<void> createUserIfNotExists(User firebaseUser) async {
    QuerySnapshot<Map<String, dynamic>> firestoreUser =
        await firestore.collection('users').where('userFirebaseId', isEqualTo: firebaseUser.uid).get();
    if (firestoreUser.size == 0) {
      await firestore.collection('users').add({
        'color': 'default',
        'icon': 'default',
        'currency': 'USD', // TODO ???
        'groups': [],
        'name': firebaseUser.displayName,
        'userFirebaseId': firebaseUser.uid,
      });
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
