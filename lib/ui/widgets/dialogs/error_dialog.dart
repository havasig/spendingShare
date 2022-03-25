import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';

import '../button.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final Exception e;

  const ErrorDialog({Key? key, required this.title, required this.e}) : super(key: key);

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
              '${(e as dynamic).message}',
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'OK',
        )
      ],
    );
  }
}
