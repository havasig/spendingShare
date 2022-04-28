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
import 'package:spending_share/ui/helpers/member_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import 'details/group_details_page.dart';

class WhoAreYou extends StatelessWidget {
  WhoAreYou({Key? key, required this.firestore, required this.groupId}) : super(key: key);

  final String groupId;
  final FirebaseFirestore firestore;
  final List<String> memberFirebaseIds = [];

  @override
  Widget build(BuildContext context) {
    late MaterialColor color;
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
                    stream: firestore.collection('groups').doc(groupId).snapshots().switchMap((group) {
                      color = globals.colors[group.data()!['color']] ?? globals.colors['default']!;
                      return CombineLatestStream.list(
                          group.data()!['members'].map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                    }),
                    builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                      if (memberListSnapshot.hasData) {
                        return Column(
                            children: memberListSnapshot.data!.map((m) {
                          var member = Member.fromDocument(m);
                          member.userFirebaseId != null ? memberFirebaseIds.add(member.userFirebaseId!) : null;
                          return MemberItem(
                            member: member,
                            onClick: () => onMemberItemTap(member, currentUser, context),
                            color: color,
                          );
                        }).toList());
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
              const Spacer(),
              Text(
                'none_of_these'.tr,
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
                  Get.to(() => GroupDetailsPage(firestore: firestore, hasBack: false, groupId: groupId));
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
                title: 'sign_in_failed'.tr,
                message: 'already_member_of_the_group'.tr,
              ));
    } else if (memberData.userFirebaseId != null) {
      showDialog(
          context: context,
          builder: (_) => ErrorDialog(
                title: 'sign_in_failed'.tr,
                message: 'member_is_taken'.tr,
              ));
    } else {
      firestore.collection('members').doc(memberData.databaseId).update({'userFirebaseId': currentUser.userFirebaseId});
      Get.to(() => GroupDetailsPage(firestore: firestore, hasBack: false, groupId: groupId));
    }
  }
}
