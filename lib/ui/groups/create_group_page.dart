import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/create_group_members_page.dart';
import 'package:spending_share/ui/groups/helpers/create_group_change_notifier.dart';
import 'package:spending_share/ui/groups/helpers/select_currency.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import 'helpers/select_color.dart';
import 'helpers/select_icon.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final FocusNode _groupNameFocusNode = FocusNode();
  final TextEditingController _groupNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    CreateGroupChangeNotifier _createGroupChangeNotifier = CreateGroupChangeNotifier(
      currentUser.currency,
      currentUser.color,
      globals.colors[currentUser.color],
      currentUser.icon,
      globals.icons[currentUser.icon],
    );
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
                InputField(
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
                SelectCurrency(defaultCurrency: currentUser.currency),
                SelectColor(defaultColor: currentUser.color),
                SelectIcon(defaultIcon: currentUser.icon),
                const Spacer(),
                Button(
                  onPressed: () => Get.to(() => CreateGroupMembersPage(
                        firestore: widget.firestore,
                        createGroupChangeNotifier: _createGroupChangeNotifier,
                      )),
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
