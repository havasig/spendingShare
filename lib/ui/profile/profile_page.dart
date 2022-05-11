import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/auth/login_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final _formKeyEmail = GlobalKey<FormState>(debugLabel: '_emailFormState');
  static final _formKeyName = GlobalKey<FormState>(debugLabel: '_nameFormState');
  static final _formKeyPwd = GlobalKey<FormState>(debugLabel: '_pwdFormState');
  static final _formKeyCurrentMoney = GlobalKey<FormState>(debugLabel: '_currentMoneyFormState');
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();
  final FocusNode _pwdConfirmFocusNode = FocusNode();
  final FocusNode _currentMoneyFocusNode = FocusNode();
  final FocusNode _currentMoneyWithDebtsFocusNode = FocusNode();
  final _emailTextEditingController = TextEditingController();
  final _nameTextEditingController = TextEditingController();
  final _pwdTextEditingController = TextEditingController();
  final _pwdConfirmTextEditingController = TextEditingController();
  final _currentMoneyTextEditingController = TextEditingController();
  final _currentMoneyWithDebtsTextEditingController = TextEditingController();
  late SpendingShareUser user;
  String? userEmail;
  late num userCurrentMoney;

  @override
  void initState() {
    super.initState();
    user = Provider.of(context, listen: false);
    userEmail = FirebaseAuth.instance.currentUser?.email;
    _emailTextEditingController.text = userEmail ?? '';
    _nameTextEditingController.text = user.name;
    if (user.currentMoney?.floor() == user.currentMoney) {
      userCurrentMoney = user.currentMoney?.toInt() ?? 0;
    } else {
      userCurrentMoney = user.currentMoney ?? 0.0;
    }
    _currentMoneyTextEditingController.text = userCurrentMoney.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(
        titleText: 'profile'.tr,
        hasBack: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: h(8)),
              Form(
                key: _formKeyEmail,
                child: InputField(
                  validator: TextValidator.validateEmailText,
                  key: const Key('email_input'),
                  focusNode: _emailFocusNode,
                  textEditingController: _emailTextEditingController,
                  prefixIcon: Icon(
                    Icons.mail,
                    color: user.color,
                  ),
                  labelText: 'email'.tr,
                  hintText: 'your_email'.tr,
                  labelColor: user.color,
                  focusColor: user.color,
                ),
              ),
              SizedBox(height: h(16)),
              Form(
                key: _formKeyName,
                child: InputField(
                  validator: TextValidator.validateIsNotEmpty,
                  key: const Key('name_input'),
                  focusNode: _nameFocusNode,
                  textEditingController: _nameTextEditingController,
                  prefixIcon: Icon(
                    Icons.mail,
                    color: user.color,
                  ),
                  labelText: 'name'.tr,
                  hintText: 'your_name'.tr,
                  labelColor: user.color,
                  focusColor: user.color,
                ),
              ),
              SizedBox(height: h(16)),
              Form(
                key: _formKeyPwd,
                child: Column(
                  children: [
                    InputField(
                      validator: (text) {
                        if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
                      },
                      key: const Key('password_input'),
                      focusNode: _pwdFocusNode,
                      textEditingController: _pwdTextEditingController,
                      isPasswordField: true,
                      labelText: 'password'.tr,
                      hintText: 'password'.tr,
                      labelColor: user.color,
                      focusColor: user.color,
                    ),
                    SizedBox(height: h(16)),
                    InputField(
                      validator: (text) {
                        if (text?.isEmpty ?? true) return 'cant_be_empty'.tr;
                        if (text != _pwdTextEditingController.text) return 'not_matching_passwords'.tr;
                      },
                      key: const Key('password_confirmation_input'),
                      focusNode: _pwdConfirmFocusNode,
                      textEditingController: _pwdConfirmTextEditingController,
                      prefixIcon: Icon(
                        Icons.mail,
                        color: user.color,
                      ),
                      labelText: 'password_confirmation'.tr,
                      hintText: 'password_confirmation'.tr,
                      labelColor: user.color,
                      focusColor: user.color,
                    ),
                  ],
                ),
              ),
              SizedBox(height: h(16)),
              Form(
                key: _formKeyCurrentMoney,
                child: InputField(
                  validator: TextValidator.validateIsNotNegative,
                  key: const Key('current_money_input'),
                  focusNode: _currentMoneyFocusNode,
                  textEditingController: _currentMoneyTextEditingController,
                  prefixIcon: Icon(
                    Icons.mail,
                    color: user.color,
                  ),
                  labelText: 'current_money'.tr,
                  hintText: 'current_money'.tr,
                  labelColor: user.color,
                  focusColor: user.color,
                ),
              ),
              SizedBox(height: h(16)),
              InputField(
                enabled: false,
                validator: TextValidator.validateEmailText,
                key: const Key('current_money_with_debts_input'),
                focusNode: _currentMoneyWithDebtsFocusNode,
                initialValue: 'TODO',
                prefixIcon: Icon(
                  Icons.mail,
                  color: user.color,
                ),
                labelText: 'current_money_with_debts'.tr,
                hintText: 'current_money_with_debts'.tr,
                labelColor: user.color,
                focusColor: user.color,
              ),
              SizedBox(height: h(16)),
              Button(
                buttonColor: user.color,
                text: 'save_changes'.tr,
                onPressed: () async {
                  if (_emailTextEditingController.text.isNotEmpty &&
                      _emailTextEditingController.text != userEmail &&
                      _formKeyEmail.currentState!.validate()) {
                    try {
                      FirebaseAuth.instance.currentUser?.updateEmail(_emailTextEditingController.text);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorDialog(
                            color: user.color,
                            title: 'set_email_failed'.tr,
                            message: '${(e as dynamic).message}'.tr,
                          );
                        },
                      );
                    }
                  }
                  if (_nameTextEditingController.text.isNotEmpty &&
                      _nameTextEditingController.text != user.name &&
                      _formKeyName.currentState!.validate()) {
                    try {
                      //TODO remove username, use only firebase userdisplayname
                      user.name = _nameTextEditingController.text;
                      FirebaseAuth.instance.currentUser?.updateDisplayName(_nameTextEditingController.text);
                      widget.firestore.collection('users').doc(user.databaseId).set(
                        {'name': user.name},
                        SetOptions(merge: true),
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorDialog(
                            color: user.color,
                            title: 'set_name_failed'.tr,
                            message: '${(e as dynamic).message}'.tr,
                          );
                        },
                      );
                    }
                  }
                  if (_pwdTextEditingController.text.isNotEmpty && _formKeyPwd.currentState!.validate()) {
                    try {
                      FirebaseAuth.instance.currentUser?.updatePassword(_pwdTextEditingController.text);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorDialog(
                            color: user.color,
                            title: 'set_password_failed'.tr,
                            message: '${(e as dynamic).message}'.tr,
                          );
                        },
                      );
                    }
                  }
                  if (_currentMoneyTextEditingController.text != userCurrentMoney.toString() &&
                      _formKeyCurrentMoney.currentState!.validate()) {
                    try {
                      widget.firestore.collection('users').doc(user.databaseId).set(
                        {'currentMoney': double.tryParse(_currentMoneyTextEditingController.text)},
                        SetOptions(merge: true),
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ErrorDialog(
                            color: user.color,
                            title: 'set_current_money_failed'.tr,
                            message: '${(e as dynamic).message}'.tr,
                          );
                        },
                      );
                    }
                  }
                },
              ),
              SizedBox(height: h(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    buttonColor: user.color.withOpacity(0.2),
                    textColor: user.color,
                    width: (MediaQuery.of(context).size.width / 2) - 32,
                    text: 'delete_account'.tr,
                    onPressed: () async {
                      //TODO delete account
                    },
                  ),
                  Button(
                    buttonColor: user.color.withOpacity(0.2),
                    textColor: user.color,
                    width: (MediaQuery.of(context).size.width / 2) - 32,
                    text: 'logout'.tr,
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      SpendingShareUser user = Provider.of(context, listen: false);
                      user.clear();
                      Get.offAll(() => LoginPage(firestore: widget.firestore));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        selectedIndex: 3,
        firestore: widget.firestore,
        color: user.color,
      ),
    );
  }
}
