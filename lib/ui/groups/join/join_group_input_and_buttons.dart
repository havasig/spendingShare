import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import '../who_are_you.dart';

class JoinGroupInputAndButtons extends StatefulWidget {
  const JoinGroupInputAndButtons({Key? key, required this.firestore, required this.color}) : super(key: key);

  final FirebaseFirestore firestore;
  final MaterialColor color;

  @override
  _JoinGroupInputAndButtonsState createState() => _JoinGroupInputAndButtonsState();
}

class _JoinGroupInputAndButtonsState extends State<JoinGroupInputAndButtons> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_JoinFormState');
  FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  bool _isInvalidGroupId = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: InputField(
            validator: _isValidGroupId,
            textEditingController: textEditingController,
            key: const Key('join_input_field'),
            focusNode: focusNode,
            hintText: 'join'.tr,
            labelText: 'join'.tr,
            prefixIcon: Icon(
              Icons.group_add,
              color: widget.color,
            ),
            labelColor: widget.color,
            focusColor: widget.color,
          ),
        ),
        SizedBox(height: h(16)),
        Button(
          textColor: widget.color,
          buttonColor: widget.color.withOpacity(0.2),
          key: const Key('paste_from_clipboard_button'),
          onPressed: () {
            FlutterClipboard.paste().then((value) {
              setState(() {
                textEditingController.text = value;
              });
            });
          },
          text: 'paste_from_clipboard'.tr,
        ),
        Button(
          buttonColor: widget.color,
          key: const Key('join_button'),
          onPressed: () {
            _submit(textEditingController.text);
          },
          text: 'join'.tr,
        )
      ],
    );
  }

  String? _isValidGroupId(String? text) {
    if (text == null || text.isEmpty) return 'cant_be_empty'.tr;
    if (_isInvalidGroupId) {
      _isInvalidGroupId = false;
      return 'incorrect_group_id'.tr;
    }

    return null;
  }

  _submit(String? text) async {
    if (_formKey.currentState!.validate()) {
      DocumentSnapshot groupDocumentSnapshot = await widget.firestore.collection('groups').doc(text).get();

      setState(() {
        _isInvalidGroupId = groupDocumentSnapshot.data() == null;
        if (!_isInvalidGroupId) {
          Get.to(() => WhoAreYou(firestore: widget.firestore, groupId: text!, color: globals.colors[groupDocumentSnapshot['color']]!));
        }
      });
    }
  }
}
