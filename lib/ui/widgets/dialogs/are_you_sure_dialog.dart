import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';

import '../button.dart';

class AreYouSureDialog extends StatelessWidget {
  final String title;
  final String message;
  final String okText;
  final String cancelText;
  final MaterialColor? color;

  const AreYouSureDialog({Key? key, required this.title, required this.message, required this.okText, required this.cancelText, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title,
        style: TextStyleConstants.h_5,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              message,
              style: TextStyleConstants.body_1,
            ),
            Divider(
              thickness: 1,
              color: ColorConstants.white.withOpacity(0.2),
            )
          ],
        ),
      ),
      actions: <Widget>[
        Button(
          buttonColor: color ?? ColorConstants.defaultOrange,
          onPressed: () => Navigator.of(context).pop(true),
          text: okText,
        ),
        Button(
          buttonColor: color?.withOpacity(0.2) ?? ColorConstants.defaultOrange.withOpacity(0.2),
          textColor: color ?? ColorConstants.defaultOrange,
          onPressed: () => Navigator.of(context).pop(false),
          text: cancelText,
        ),
      ],
    );
  }
}
