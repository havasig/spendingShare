import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/text_validator.dart';

import '../button.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    TextEditingController _textEditingController = TextEditingController();
    final _formKey = GlobalKey<FormState>(debugLabel: '_ForgotPasswordFormState');
    return AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'forgot_password'.tr,
        style: TextStyleConstants.h_5,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'forgot_password_text'.tr,
              style: TextStyleConstants.body_1,
            ),
            Divider(
              thickness: 1,
              color: ColorConstants.white.withOpacity(0.2),
            ),
            Form(
              key: _formKey,
              child: InputField(
                validator: TextValidator.validateEmailText,
                key: const Key('email_input'),
                focusNode: _focusNode,
                textEditingController: _textEditingController,
                prefixIcon: const Icon(
                  Icons.mail,
                  color: ColorConstants.defaultOrange,
                ),
                labelText: 'email'.tr,
                hintText: 'your_email'.tr,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Button(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final _auth = FirebaseAuth.instance;
              _auth.sendPasswordResetEmail(email: _textEditingController.text);
              Navigator.of(context).pop();
            }
          },
          text: 'send_reminder'.tr,
          textStyle: TextStyleConstants.sub_1_medium.copyWith(color: ColorConstants.textBlack),
        ),
        Button(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'close'.tr,
          textStyle: TextStyleConstants.sub_1,
          buttonColor: Colors.transparent,
          borderSide: BorderSide(
            color: ColorConstants.white.withOpacity(0.5),
          ),
          textColor: ColorConstants.white.withOpacity(0.8),
        )
      ],
    );
  }
}
