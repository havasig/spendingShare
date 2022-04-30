import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/member_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import '../details/group_details_page.dart';

class CreateGroupMembersPage extends StatefulWidget {
  const CreateGroupMembersPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  _CreateGroupMembersPageState createState() => _CreateGroupMembersPageState();
}

class _CreateGroupMembersPageState extends State<CreateGroupMembersPage> {
  final FocusNode _memberNameFocusNode = FocusNode();
  final TextEditingController _memberNameTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<CreateGroupChangeNotifier>(
        builder: (_, createGroupChangeNotifier, __) => Scaffold(
          appBar: SpendingShareAppBar(titleText: 'members'.tr),
          body: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: createGroupChangeNotifier.members.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: MemberItem(
                          member: Member(name: createGroupChangeNotifier.members[index], transactions: []),
                          onClick: () {},
                          onDelete: index == 0 ? null : () => createGroupChangeNotifier.removeMember(index),
                          color: createGroupChangeNotifier.color!,
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'type_name_and_add_member'.tr,
                  style: TextStyleConstants.sub_1,
                ),
                SizedBox(height: h(16)),
                InputField(
                  onSubmit: (String? text) {
                    if (text != null && text.isNotEmpty) {
                      createGroupChangeNotifier.addMember(_memberNameTextEditingController.text);
                      _memberNameTextEditingController.text = '';
                    }
                  },
                  key: const Key('add_member_input_field'),
                  focusNode: _memberNameFocusNode,
                  textEditingController: _memberNameTextEditingController,
                  hintText: 'name'.tr,
                  labelText: 'member_name'.tr,
                  prefixIcon: Icon(Icons.group_add, color: createGroupChangeNotifier.color),
                  labelColor: createGroupChangeNotifier.color!,
                  focusColor: createGroupChangeNotifier.color!,
                ),
                SizedBox(height: h(16)),
                Button(
                  buttonColor: createGroupChangeNotifier.color!,
                  key: const Key('add_member_button'),
                  onPressed: () {
                    if (_memberNameTextEditingController.text.isNotEmpty) {
                      createGroupChangeNotifier.addMember(_memberNameTextEditingController.text);
                      _memberNameTextEditingController.text = '';
                    }
                  },
                  text: 'add_member'.tr,
                ),
                Button(
                  buttonColor: createGroupChangeNotifier.color!,
                  key: const Key('create_group_button'),
                  onPressed: () async {
                    if (createGroupChangeNotifier.members.isNotEmpty) {
                      try {
                        List<DocumentReference> memberReferences = [];
                        for (var member in createGroupChangeNotifier.members) {
                          memberReferences.add(await widget.firestore.collection('members').add({
                            'name': member,
                            'userFirebaseId': createGroupChangeNotifier.adminId,
                            'transactions': [],
                          }));
                        }

                        // TODO add default categories
                        List<DocumentReference> categoryReferences = [];
                        categoryReferences.add(await widget.firestore.collection('categories').add({
                          'name': 'other'.tr,
                          'transactions': [],
                        }));

                        DocumentReference groupReference = await widget.firestore.collection('groups').add({
                          'adminId': createGroupChangeNotifier.adminId,
                          'name': createGroupChangeNotifier.name,
                          'color': globals.colors.entries.firstWhere((element) => element.value == createGroupChangeNotifier.color).key,
                          'currency': createGroupChangeNotifier.currency,
                          'icon': globals.icons.entries.firstWhere((element) => element.value == createGroupChangeNotifier.icon).key,
                          'members': memberReferences,
                          'categories': categoryReferences,
                          'transactions': [],
                          'debts': [],
                        });

                        SpendingShareUser user = Provider.of(context, listen: false);

                        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                            await widget.firestore.collection('users').doc(user.databaseId).get();

                        List<dynamic> newGroupReferenceList = userSnapshot.data()!['groups'];
                        newGroupReferenceList.add(groupReference);

                        await widget.firestore
                            .collection('users')
                            .doc(user.databaseId)
                            .set({'groups': newGroupReferenceList}, SetOptions(merge: true));

                        Get.offAll(() => GroupDetailsPage(firestore: widget.firestore, hasBack: false, groupId: groupReference.id));
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorDialog(
                              title: 'group_create_failed'.tr,
                              message: '${(e as dynamic).message}'.tr,
                            );
                          },
                        );
                      }
                    }
                  },
                  text: 'create_group'.tr,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SpendingShareBottomNavigationBar(
            key: const Key('bottom_navigation'),
            selectedIndex: 1,
            firestore: widget.firestore,
            color: createGroupChangeNotifier.color,
          ),
        ),
      ),
    );
  }
}
