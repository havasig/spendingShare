import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../button.dart';
import '../input_field.dart';

class CreateCategoryDialog extends StatelessWidget {
  const CreateCategoryDialog({Key? key, required this.color}) : super(key: key);

  final String color;

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = FocusNode();
    TextEditingController _textEditingController = TextEditingController();
    return AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'create_category'.tr,
        style: TextStyleConstants.h_5,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'add_new_category_name'.tr,
              style: TextStyleConstants.body_1,
            ),
            Divider(
              thickness: 1,
              color: ColorConstants.white.withOpacity(0.2),
            ),
            InputField(
              labelColor: globals.colors[color]!,
              focusColor: globals.colors[color]!,
              key: const Key('category_name_input'),
              focusNode: _focusNode,
              textEditingController: _textEditingController,
              prefixIcon: Icon(
                Icons.mail,
                color: globals.colors[color],
              ),
              labelText: 'category'.tr,
              hintText: 'category'.tr,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Button(
          buttonColor: globals.colors[color]!,
          onPressed: () {
            Navigator.of(context).pop(_textEditingController.text);
          },
          text: 'create'.tr,
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
