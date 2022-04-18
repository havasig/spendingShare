import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/create/create_group_members_page.dart';
import 'package:spending_share/ui/groups/create/select_currency.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

import 'select_color.dart';
import 'select_icon.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final FocusNode _groupNameFocusNode = FocusNode();
  final TextEditingController _groupNameTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>(debugLabel: '_CreateGroupFormState');

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    CreateGroupChangeNotifier _createGroupChangeNotifier = CreateGroupChangeNotifier(
      currentUser.userFirebaseId,
      currentUser.currency,
      currentUser.color,
      globals.colors[currentUser.color],
      currentUser.icon,
      globals.icons[currentUser.icon],
    );
    _createGroupChangeNotifier.addMember(currentUser.name);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SpendingShareAppBar(titleText: 'create_group'.tr),
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: ChangeNotifierProvider(
            create: (context) => _createGroupChangeNotifier,
            child: Column(
              children: [
                SizedBox(height: h(6)),
                Form(
                  key: _formKey,
                  child: InputField(
                    validator: TextValidator.validateGroupNameText,
                    key: const Key('group_name_input'),
                    focusNode: _groupNameFocusNode,
                    textEditingController: _groupNameTextEditingController,
                    labelText: 'name'.tr,
                    hintText: 'group_name'.tr,
                    prefixIcon: const Icon(
                      Icons.group,
                      color: ColorConstants.defaultOrange,
                    ),
                  ),
                ),
                ChangeNotifierProvider(
                  create: (context) => _createGroupChangeNotifier as CreateChangeNotifier,
                  child: SelectCurrency(currency: currentUser.currency, color: currentUser.color),
                ),
                SelectColor(defaultColor: currentUser.color),
                SelectIcon(defaultIcon: currentUser.icon),
                const Spacer(),
                Button(
                  onPressed: () {
                    _createGroupChangeNotifier.setName(_groupNameTextEditingController.text);
                    if (_formKey.currentState!.validate() && _createGroupChangeNotifier.validateFirstPage()) {
                      Get.to(() => CreateGroupMembersPage(
                            firestore: widget.firestore,
                            createGroupChangeNotifier: _createGroupChangeNotifier,
                          ));
                    }
                  },
                  text: 'next'.tr,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SpendingShareBottomNavigationBar(
          selectedIndex: 1,
          firestore: widget.firestore,
        ),
      ),
    );
  }
}
