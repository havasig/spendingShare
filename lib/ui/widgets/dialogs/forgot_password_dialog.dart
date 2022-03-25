import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/input_field.dart';

import '../button.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    TextEditingController _textEditingController = TextEditingController();
    return AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'forgot-password'.tr,
        style: TextStyleConstants.h_5,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'forgot-password-text'.tr,
              style: TextStyleConstants.body_1,
            ),
            Divider(
              thickness: 1,
              color: ColorConstants.white.withOpacity(0.2),
            ),
            InputField(
              key: const Key('email_input'),
              focusNode: _focusNode,
              textEditingController: _textEditingController,
              prefixIcon: const Icon(
                Icons.mail,
                color: ColorConstants.defaultOrange,
              ),
              labelText: 'email'.tr,
              hintText: 'your-email'.tr,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Button(
          onPressed: () {
            // TODO send email reset email
            Navigator.of(context).pop();
          },
          text: 'send-reminder'.tr,
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
            color: ColorConstants.white.withOpacity(0.3),
          ),
          textColor: ColorConstants.white.withOpacity(0.8),
        )
      ],
    );
  }
}
