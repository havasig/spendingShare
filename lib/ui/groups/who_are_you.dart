import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/helpers/user_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'group_details_page.dart';

class WhoAreYou extends StatelessWidget {
  WhoAreYou({Key? key, required this.firestore, required this.groupId}) : super(key: key);

  final String groupId; //final Stream<DocumentSnapshot<Map<String, dynamic>>> groupId;
  final FirebaseFirestore firestore;
  final List<String> memberFirebaseIds = [];

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    SpendingShareUser currentUser = Provider.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        titleText: 'who-are-you'.tr,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                    stream: firestore.collection('groups').doc(groupId).snapshots().switchMap((group) => CombineLatestStream.list(
                        group.data()!['members'].map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()))),
                    builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> groupSnapshot) {
                      if (!groupSnapshot.hasData) {
                        return const SizedBox.shrink();
                      } else {
                        List<Widget> memberItems = [];
                        for (var element in groupSnapshot.data!) {
                          var member = Member.fromDocument(element);
                          member.userFirebaseId != null ? memberFirebaseIds.add(member.userFirebaseId!) : null;
                          memberItems.add(
                            MemberItem(
                                member: member,
                                onClick: () {
                                  onMemberItemTap(
                                    member,
                                    currentUser,
                                    context,
                                  );
                                }),
                          );
                        }
                        return Column(children: memberItems);
                      }
                    }),
              ),
              const Spacer(),
              Text(
                'none-of-these'.tr,
                style: TextStyleConstants.sub_1,
              ),
              SizedBox(height: h(16)),
              InputField(
                key: const Key('join_input_field'),
                focusNode: focusNode,
                hintText: 'join'.tr,
                labelText: 'join'.tr,
                prefixIcon: const Icon(
                  Icons.group_add,
                  color: ColorConstants.defaultOrange,
                ),
              ),
              SizedBox(height: h(16)),
              Button(
                key: const Key('join_button'),
                onPressed: () {
                  Get.to(() => GroupDetailsPage(firestore: firestore));
                },
                text: 'join'.tr,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }

  onMemberItemTap(Member memberData, SpendingShareUser currentUser, BuildContext context) {
    if (memberFirebaseIds.contains(currentUser.userFirebaseId)) {
      showDialog(
          context: context,
          builder: (_) => ErrorDialog(
                title: 'sign-in-failed'.tr,
                message: 'already-member-of-the-group'.tr,
              ));
    } else if (memberData.userFirebaseId != null) {
      showDialog(
          context: context,
          builder: (_) => ErrorDialog(
                title: 'sign-in-failed'.tr,
                message: 'member-is-taken'.tr,
              ));
    } else {
      firestore.collection('members').doc(memberData.databaseId).update({'userFirebaseId': currentUser.userFirebaseId});
      Get.to(() => GroupDetailsPage(firestore: firestore));
    }
  }
}
