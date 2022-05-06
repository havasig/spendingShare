import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/auth/sign_up_with_google_button.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

import 'authentication.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();

  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConfirmationTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: h(16)),
                Text(
                  'sign-up'.tr,
                  style: TextStyleConstants.h_3,
                ),
                SizedBox(height: h(16)),
                InputField(
                  validator: TextValidator.validateNameText,
                  key: const Key('name_input'),
                  focusNode: _nameFocusNode,
                  textEditingController: _nameTextEditingController,
                  prefixIcon: const Icon(
                    Icons.account_circle,
                    color: ColorConstants.defaultOrange,
                  ),
                  labelText: 'name'.tr,
                  hintText: 'your_name'.tr,
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
                InputField(
                  validator: (text) {
                    if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
                    if (text != _passwordTextEditingController.text) return 'not_matching_passwords'.tr;
                  },
                  key: const Key('password_confirmation_input'),
                  focusNode: _passwordConfirmationFocusNode,
                  textEditingController: _passwordConfirmationTextEditingController,
                  isPasswordField: true,
                  labelText: 'password_confirmation'.tr,
                  hintText: 'password_confirmation'.tr,
                ),
                SizedBox(height: h(16)),
                Button(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      registerAccount(_emailTextEditingController.text, _passwordTextEditingController.text, widget.firestore);
                    }
                  },
                  text: 'sign_up'.tr,
                ),
                SizedBox(height: h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already_have_account'.tr,
                      style: TextStyleConstants.body_2_medium,
                    ),
                    TextButton(
                      key: const Key('login'),
                      onPressed: () {
                        Get.to(() => LoginPage(firestore: widget.firestore));
                      },
                      child: Text('login'.tr,
                          style: TextStyleConstants.body_2_medium.copyWith(
                            color: ColorConstants.defaultOrange,
                            decoration: TextDecoration.underline,
                          )),
                    ),
                  ],
                ),
                SizedBox(height: h(16)),
                SingUpWithGoogleButton(firestore: widget.firestore, text: 'sign_up_with_google'.tr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerAccount(String email, String password, FirebaseFirestore firestore) async {
    try {
      var credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      SingUpWithGoogleButton.createUserIfNotExists(credentials.user!, firestore);

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
