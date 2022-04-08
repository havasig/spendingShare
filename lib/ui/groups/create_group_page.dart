import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/groups/helpers/select_currency.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final FocusNode _groupNameFocusNode = FocusNode();
  final bool _groupNameHadFocus = false;
  final TextEditingController _groupNameTextEditingController = TextEditingController();

  String? get _errorText {
    // TODO fix validators
    TextValidator.validateEmptyText(_groupNameTextEditingController.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'create_group'.tr),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: Column(
          children: [
            InputField(
              key: const Key('group_name_input'),
              focusNode: _groupNameFocusNode,
              textEditingController: _groupNameTextEditingController,
              isPasswordField: true,
              labelText: 'password'.tr,
              hintText: 'your-password'.tr,
              onChanged: (text) => setState(() {}),
              errorText: _groupNameHadFocus ? _errorText : null,
            ),
            SelectCurrency(),
          ],
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        selectedIndex: 1,
        firestore: widget.firestore,
      ),
    );
  }
}
