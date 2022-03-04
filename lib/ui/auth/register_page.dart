import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/auth/main_page.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool nameHadFocus = false;
  bool emailHadFocus = false;
  bool passwordHadFocus = false;
  bool passwordConfirmationHadFocus = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();

  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConfirmationTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onNameFocusChange);
    _passwordFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
    _passwordConfirmationFocusNode.addListener(_onPasswordConfirmationFocusChange);
  }

  void _onNameFocusChange() {
    setState(() {
      nameHadFocus = true;
    });
  }

  void _onEmailFocusChange() {
    setState(() {
      emailHadFocus = true;
    });
  }

  void _onPasswordFocusChange() {
    setState(() {
      passwordHadFocus = true;
    });
  }

  void _onPasswordConfirmationFocusChange() {
    setState(() {
      passwordConfirmationHadFocus = true;
    });
  }

  String? get _errorText {
    // TODO fix validators
    TextValidator.validateEmptyText(_emailTextEditingController.value.text);
    TextValidator.validateEmailText(_emailTextEditingController.value.text);

    TextValidator.validateEmptyText(_passwordTextEditingController.value.text);
    TextValidator.validatePassText(_passwordTextEditingController.value.text);
  }

  Future<void> registerAccount(
      String email, String displayName, String password, void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      Get.to(() => const MainPage());
    } on FirebaseAuthException catch (e) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return ErrorDialog(
            title: 'Sign up failed',
            e: e,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'sign-up'.tr,
              style: TextStyleConstants.h_3,
            ),
            const Spacer(),
            InputField(
              key: const Key('name_input'),
              focusNode: _nameFocusNode,
              textEditingController: _nameTextEditingController,
              onChanged: (text) => setState(() {}),
              prefixIcon: const Icon(
                Icons.account_circle,
                color: ColorConstants.defaultOrange,
              ),
              labelText: "name".tr,
              hintText: "your-name".tr,
              errorText: nameHadFocus ? _errorText : null,
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
              labelText: "email".tr,
              hintText: "your-email".tr,
              errorText: emailHadFocus ? _errorText : null,
            ),
            const Spacer(),
            InputField(
              key: const Key('password_input'),
              focusNode: _passwordFocusNode,
              textEditingController: _passwordTextEditingController,
              isPasswordField: true,
              labelText: "password".tr,
              hintText: "your-password".tr,
              onChanged: (text) => setState(() {}),
              errorText: passwordHadFocus ? _errorText : null,
            ),
            const Spacer(),
            InputField(
              key: const Key('password_confirmation_input'),
              focusNode: _passwordConfirmationFocusNode,
              textEditingController: _passwordConfirmationTextEditingController,
              isPasswordField: true,
              labelText: "password-confirmation".tr,
              hintText: "password-confirmation".tr,
              onChanged: (text) => setState(() {}),
              errorText: passwordConfirmationHadFocus ? _errorText : null,
            ),
            const Spacer(),
            Button(
              onPressed: () {
                registerAccount('admin@email.com', 'displayName', 'password', (e) {});
              },
              text: 'sign-up'.tr,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'already-have-account'.tr,
                  style: TextStyleConstants.body_2_medium,
                ),
                TextButton(
                  key: const Key('login'),
                  onPressed: () {
                    Get.to(() => const LoginPage());
                  },
                  child: Text('login'.tr,
                      style: TextStyleConstants.body_2_medium.copyWith(
                        color: ColorConstants.defaultOrange,
                        decoration: TextDecoration.underline,
                      )),
                ),
              ],
            ),
            const Spacer(),
            Button(
              textColor: ColorConstants.white.withOpacity(0.8),
              buttonColor: ColorConstants.lightGray,
              onPressed: () {},
              text: 'sign-up-with-google'.tr,
              prefixWidget: SvgPicture.asset('assets/graphics/icons/google_logo.svg'),
              suffixWidget: Icon(
                Icons.arrow_forward_ios,
                color: ColorConstants.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
