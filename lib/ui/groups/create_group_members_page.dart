import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/helpers/create_group_change_notifier.dart';
import 'package:spending_share/ui/groups/helpers/user_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'group_details_page.dart';

class CreateGroupMembersPage extends StatefulWidget {
  const CreateGroupMembersPage({Key? key, required this.firestore, required this.createGroupChangeNotifier}) : super(key: key);

  final CreateGroupChangeNotifier createGroupChangeNotifier;
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
      child: Scaffold(
        appBar: SpendingShareAppBar(
          titleText: 'members'.tr
        ),
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChangeNotifierProvider(
                create: (context) => widget.createGroupChangeNotifier,
                child: Consumer<CreateGroupChangeNotifier>(builder: (_, createGroupChangeNotifier, __) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: createGroupChangeNotifier.members.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: MemberItem(
                            member: Member(name: createGroupChangeNotifier.members[index]),
                            onClick: () {},
                            onDelete: index == 0 ? null : () => createGroupChangeNotifier.removeMember(index),
                            color: createGroupChangeNotifier.color,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
              Text(
                'none_of_these'.tr,
                style: TextStyleConstants.sub_1,
              ),
              SizedBox(height: h(16)),
              InputField(
                key: const Key('add_member_input_field'),
                focusNode: _memberNameFocusNode,
                textEditingController: _memberNameTextEditingController,
                hintText: 'name'.tr,
                labelText: 'member_name'.tr,
                prefixIcon: const Icon(
                  Icons.group_add,
                  color: ColorConstants.defaultOrange,
                ),
              ),
              SizedBox(height: h(16)),
              Button(
                key: const Key('add_member_button'),
                onPressed: () {
                  if (_memberNameTextEditingController.text.isNotEmpty) {
                    widget.createGroupChangeNotifier.addMember(_memberNameTextEditingController.text);
                    _memberNameTextEditingController.text = '';
                  }
                },
                text: 'add_member'.tr,
              ),
              Button(
                key: const Key('create_group_button'),
                onPressed: () async {
                  if (widget.createGroupChangeNotifier.members.isNotEmpty) {
                    try {
                      List<DocumentReference> memberReferences = [];
                      for (var member in widget.createGroupChangeNotifier.members) {
                        memberReferences.add(await widget.firestore.collection('members').add({
                          'name': member,
                          'userFirebaseId': widget.createGroupChangeNotifier.adminId,
                        }));
                      }

                      DocumentReference groupReference = await widget.firestore.collection('groups').add({
                        'adminId': widget.createGroupChangeNotifier.adminId,
                        'name': widget.createGroupChangeNotifier.name,
                        'color': widget.createGroupChangeNotifier.colorName,
                        'defaultCurrency': widget.createGroupChangeNotifier.currency,
                        'icon': widget.createGroupChangeNotifier.iconName,
                        'members': memberReferences,
                        'categories': [],
                        'transactions': [],
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
        ),
      ),
    );
  }
}
