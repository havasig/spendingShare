import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import '../button.dart';

class SelectNewCategoryDialog extends StatefulWidget {
  const SelectNewCategoryDialog({Key? key, this.defaultValue, required this.color, required this.options}) : super(key: key);

  final String? defaultValue;
  final String color;
  final Map<String, dynamic> options;

  @override
  State<SelectNewCategoryDialog> createState() => _SelectNewCategoryDialogState();
}

class _SelectNewCategoryDialogState extends State<SelectNewCategoryDialog> {
  Map<String, dynamic> dropDownItems = {};
  String _dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropDownItems.addAll(widget.options);
    _dropdownValue = widget.defaultValue ?? dropDownItems.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'title'.tr,
        style: TextStyleConstants.h_5,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'message',
              style: TextStyleConstants.body_1,
            ),
            Divider(
              thickness: 1,
              color: ColorConstants.white.withOpacity(0.2),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: h(6)),
              decoration: BoxDecoration(
                border: Border.all(color: globals.colors[widget.color]!),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: DropdownButton<String>(
                value: _dropdownValue,
                dropdownColor: ColorConstants.darkGray,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                elevation: 6,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: globals.colors[widget.color]!,
                ),
                underline: Container(height: 0),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return dropDownItems.keys.map<Widget>((key) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(key),
                    );
                  }).toList();
                },
                items: dropDownItems.keys.map<DropdownMenuItem<String>>((key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      key,
                      style: _dropdownValue == key ? TextStyle(color: globals.colors[widget.color]!) : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Button(
          onPressed: () {
            Navigator.of(context).pop(widget.options[_dropdownValue]);
          },
          text: 'ok'.tr,
        ),
        Button(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          text: 'cancel'.tr,
        ),
      ],
    );
  }
}
