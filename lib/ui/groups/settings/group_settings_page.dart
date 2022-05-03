import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'group_categories_page.dart';
import 'group_edit_page.dart';
import 'group_members_page.dart';
import 'group_statistics_page.dart';

class GroupSettingsPage extends StatelessWidget {
  const GroupSettingsPage({Key? key, required this.firestore, required this.groupData, required this.isAdmin}) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'group_settings'.tr),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: Center(
          child: Column(
            children: [
              Button(
                width: MediaQuery.of(context).size.width * 0.9,
                height: h(40),
                textColor: ColorConstants.white.withOpacity(0.8),
                buttonColor: ColorConstants.lightGray,
                borderSide: const BorderSide(color: Colors.grey),
                onPressed: () => Get.to(() => GroupEditPage(firestore: firestore, groupData: groupData)),
                text: 'edit'.tr,
              ),
              SizedBox(height: h(10)),
              Button(
                width: MediaQuery.of(context).size.width * 0.9,
                height: h(40),
                textColor: ColorConstants.white.withOpacity(0.8),
                buttonColor: ColorConstants.lightGray,
                borderSide: const BorderSide(color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: groupData.groupId));
                  //TODO show toast copied
                },
                text: 'copy_invite_link'.tr,
              ),
              SizedBox(height: h(10)),
              Button(
                width: MediaQuery.of(context).size.width * 0.9,
                height: h(40),
                textColor: ColorConstants.white.withOpacity(0.8),
                buttonColor: ColorConstants.lightGray,
                borderSide: const BorderSide(color: Colors.grey),
                onPressed: () => Get.to(() => GroupMembersPage(
                      firestore: firestore,
                      color: groupData.color,
                      groupId: groupData.groupId,
                    )),
                text: 'members'.tr,
              ),
              SizedBox(height: h(10)),
              Button(
                width: MediaQuery.of(context).size.width * 0.9,
                height: h(40),
                textColor: ColorConstants.white.withOpacity(0.8),
                buttonColor: ColorConstants.lightGray,
                borderSide: const BorderSide(color: Colors.grey),
                onPressed: () => Get.to(() => GroupStatisticsPage()),
                text: 'group_statistics'.tr,
              ),
              SizedBox(height: h(10)),
              Button(
                width: MediaQuery.of(context).size.width * 0.9,
                height: h(40),
                textColor: ColorConstants.white.withOpacity(0.8),
                buttonColor: ColorConstants.lightGray,
                borderSide: const BorderSide(color: Colors.grey),
                onPressed: () => Get.to(() => GroupCategoriesPage(
                      firestore: firestore,
                      groupData: groupData,
                    )),
                text: 'categories'.tr,
              ),
              const Spacer(),
              isAdmin ? Text('cannot_leave'.tr) : Text('if_you_leave'.tr),
              SizedBox(height: h(10)),
              isAdmin
                  ? Button(
                      height: h(40),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AreYouSureDialog(
                                title: 'are_you_sure'.tr,
                                message: 'if_you_delete_group'.tr,
                                color: groupData.color,
                              );
                            }).then((value) {
                          // TODO delete group
                        });
                      },
                      text: 'delete_group'.tr,
                      textColor: groupData.color,
                      buttonColor: groupData.color.withOpacity(0.2),
                      width: MediaQuery.of(context).size.width * 0.9,
                    )
                  : Button(
                      height: h(40),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AreYouSureDialog(
                                title: 'are_you_sure'.tr,
                                message: 'if_you_leave_group'.tr,
                                color: groupData.color,
                              );
                            }).then((value) {
                          // TODO leave group
                        });
                      },
                      text: 'leave_group'.tr,
                      textColor: groupData.color,
                      buttonColor: groupData.color.withOpacity(0.2),
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        firestore: firestore,
        selectedIndex: 1,
        color: groupData.color,
      ),
    );
  }
}
