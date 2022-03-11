import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spending_share/ui/auth/register_page.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

import 'authentication.dart';
import '../groups/my_groups.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool emailHadFocus = false;
  bool passwordHadFocus = false;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPassWordFocusChange);
  }

  void _onEmailFocusChange() {
    setState(() {
      emailHadFocus = true;
    });
  }

  void _onPassWordFocusChange() {
    setState(() {
      passwordHadFocus = true;
    });
  }

  String? get _errorText {
    // TODO fix validators
    TextValidator.validateEmptyText(_emailTextEditingController.value.text);
    TextValidator.validateEmailText(_emailTextEditingController.value.text);

    TextValidator.validateEmptyText(_passwordTextEditingController.value.text);
    TextValidator.validatePassText(_passwordTextEditingController.value.text);
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'havasi.gaabor@gmail.com', //_emailTextEditingController.text,
        password: 'password', //_passwordTextEditingController.text,
      );
      Get.offAll(() => const MyGroupsPage());
    } on FirebaseAuthException catch (e) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return ErrorDialog(
            title: 'Sign in failed',
            e: e,
          );
        },
      );
    }
  }

  final _formKey = GlobalKey<FormState>(debugLabel: '_LoginFormState');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              Text(
                'login'.tr,
                style: TextStyleConstants.h_3,
              ),
              const Spacer(),
              InputField(
                key: const Key('email_input'),
                focusNode: _emailFocusNode,
                textEditingController: _emailTextEditingController,
                onChanged: (text) => setState(() {}),
                prefixIcon: const Icon(
                  Icons.mail,
                  color: ColorConstants.defaultOrange,
                ),
                labelText: 'email'.tr,
                hintText: 'your-email'.tr,
                errorText: emailHadFocus ? _errorText : null,
              ),
              const Spacer(),
              InputField(
                key: const Key('password_input'),
                focusNode: _passwordFocusNode,
                textEditingController: _passwordTextEditingController,
                isPasswordField: true,
                labelText: 'password'.tr,
                hintText: 'your-password'.tr,
                onChanged: (text) => setState(() {}),
                errorText: passwordHadFocus ? _errorText : null,
              ),
              const Spacer(),
              Button(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signInWithEmailAndPassword();
                  }
                },
                text: 'login'.tr,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'no-account'.tr,
                    style: TextStyleConstants.body_2_medium,
                  ),
                  TextButton(
                    key: const Key('registration'),
                    onPressed: () {
                      Get.to(() => const RegisterPage());
                    },
                    child: Text('registration-exclamation'.tr,
                        style: TextStyleConstants.body_2_medium.copyWith(
                          color: ColorConstants.defaultOrange,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                        )),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'forgot-password'.tr,
                  style: TextStyleConstants.body_2_medium.copyWith(
                    color: ColorConstants.defaultOrange,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
              const Spacer(),
              Button(
                textColor: ColorConstants.white.withOpacity(0.8),
                buttonColor: ColorConstants.lightGray,
                onPressed: () async {
                  await signInWithGoogle().then((value) {
                    Get.offAll(() => const MyGroupsPage());
                  });
                },
                text: 'login-with-google'.tr,
                prefixWidget: SvgPicture.asset('assets/graphics/icons/google_logo.svg'),
                suffixWidget: Icon(
                  Icons.arrow_forward_ios,
                  color: ColorConstants.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
