import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/auth/authentication.dart';
import 'package:spending_share/ui/auth/register_page.dart';
import 'package:spending_share/ui/auth/sign_up_with_google_button.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/forgot_password_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

import '../groups/my_groups_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool emailHadFocus = false;
  bool passwordHadFocus = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _emailTextEditingController = TextEditingController(text: 'havasig@gmail.com');
  final _passwordTextEditingController = TextEditingController(text: 'Passw0rd');
  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginFormState');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: h(16)),
                  Text(
                    'login'.tr,
                    style: TextStyleConstants.h_3,
                  ),
                  SizedBox(height: h(16)),
                  InputField(
                    validator: TextValidator.validateEmailText,
                    key: const Key('email_input'),
                    focusNode: _emailFocusNode,
                    textEditingController: _emailTextEditingController,
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: ColorConstants.defaultOrange,
                    ),
                    labelText: 'email'.tr,
                    hintText: 'your_email'.tr,
                  ),
                  SizedBox(height: h(16)),
                  InputField(
                    key: const Key('password_input'),
                    focusNode: _passwordFocusNode,
                    textEditingController: _passwordTextEditingController,
                    isPasswordField: true,
                    labelText: 'password'.tr,
                    hintText: 'your_password'.tr,
                  ),
                  SizedBox(height: h(16)),
                  Button(
                    key: const Key('login_button'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signInWithEmailAndPassword();
                      }
                    },
                    text: 'login'.tr,
                  ),
                  SizedBox(height: h(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'no_account'.tr,
                        style: TextStyleConstants.body_2_medium,
                      ),
                      TextButton(
                        key: const Key('registration'),
                        onPressed: () {
                          Get.to(() => RegisterPage(firestore: widget.firestore));
                        },
                        child: Text('registration_exclamation'.tr,
                            style: TextStyleConstants.body_2_medium.copyWith(
                              color: ColorConstants.defaultOrange,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: h(16)),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ForgotPasswordDialog();
                          });
                    },
                    child: Text(
                      'forgot_password'.tr,
                      style: TextStyleConstants.body_2_medium.copyWith(
                        color: ColorConstants.defaultOrange,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: h(16)),
                  SingUpWithGoogleButton(firestore: widget.firestore, text: 'login_with_google'.tr),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextEditingController.text,
        password: _passwordTextEditingController.text,
      );

      Authentication.loadUser(context, credentials.user!.uid, widget.firestore);

      Get.offAll(() => MyGroupsPage(firestore: widget.firestore));
    } on FirebaseAuthException catch (e) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return ErrorDialog(
            title: 'sign_in_failed'.tr,
            message: '${(e as dynamic).message}'.tr,
          );
        },
      );
    }
  }
}
