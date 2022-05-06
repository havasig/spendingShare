import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/settings/member_details_page.dart';
import 'package:spending_share/ui/helpers/member_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

class GroupMembersPage extends StatelessWidget {
  GroupMembersPage({Key? key, required this.firestore, required this.groupId, required this.color}) : super(key: key);

  final String groupId;
  final MaterialColor color;
  final FirebaseFirestore firestore;
  final Map<String, String> memberIdName = {};

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    TextEditingController textEditingController = TextEditingController();
    final _formKey = GlobalKey<FormState>(debugLabel: '_JoinMemberFormState');
    SpendingShareUser currentUser = Provider.of(context);

    return Scaffold(
      appBar: SpendingShareAppBar(
        titleText: 'members'.tr,
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
                      return CombineLatestStream.list(
                          group.data()!['members'].map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                    }),
                    builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                      if (memberListSnapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                              children: memberListSnapshot.data!.map((m) {
                            if (m.data() == null) return const SizedBox.shrink();
                            var member = Member.fromDocument(m);
                            if (member.userFirebaseId != null) memberIdName[member.userFirebaseId!] = member.name;
                            return MemberItem(
                              member: member,
                              onClick: () => Get.to(() => MemberDetailsPage(firestore: firestore, color: color)),
                              onDelete: () async {
                                if (member.userFirebaseId != null && member.transactions.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AreYouSureDialog(
                                        title: 'member_delete_failed'.tr,
                                        message: 'cannot_remove'.tr,
                                        okText: 'delete'.tr,
                                        cancelText: 'cancel'.tr,
                                        color: color,
                                      );
                                    },
                                  ).then((value) async {
                                    if (value != null && value) {
                                      await firestore.collection('members').doc(member.databaseId).delete();
                                      var oldMemberData = await firestore.collection('groups').doc(groupId).get();
                                      List<dynamic> memberList = oldMemberData.data()!['members'];
                                      memberList.removeWhere((element) => element.id == member.databaseId);

                                      firestore.collection('groups').doc(groupId).update({'members': memberList});
                                    }
                                  });
                                } else if (member.transactions.isEmpty) {
                                  await firestore.collection('members').doc(member.databaseId).delete();
                                  var oldMemberData = await firestore.collection('groups').doc(groupId).get();
                                  List<dynamic> memberList = oldMemberData.data()!['members'];
                                  memberList.removeWhere((element) => element.id == member.databaseId);

                                  firestore.collection('groups').doc(groupId).update({'members': memberList});
                                } else {
                                  showDialog<void>(
                                    context: context,
                                    builder: (context) {
                                      return ErrorDialog(
                                        title: 'member_delete_failed'.tr,
                                        message: 'cannot_remove'.tr,
                                        color: color,
                                      );
                                    },
                                  );
                                }
                              },
                              color: color,
                            );
                          }).toList()),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
              ),
              Text(
                'add_member_by_typing'.tr,
                style: TextStyleConstants.sub_1,
              ),
              SizedBox(height: h(16)),
              Form(
                key: _formKey,
                child: InputField(
                  validator: TextValidator.validateIsNotEmpty,
                  key: const Key('member_input_field'),
                  focusNode: focusNode,
                  textEditingController: textEditingController,
                  hintText: 'member_name'.tr,
                  labelText: 'member_name'.tr,
                  prefixIcon: Icon(
                    Icons.group_add,
                    color: color,
                  ),
                  labelColor: color,
                  focusColor: color,
                ),
              ),
              SizedBox(height: h(16)),
              Button(
                buttonColor: color,
                key: const Key('add_member_button'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String icon = globals.icons.entries.firstWhereOrNull((element) => element.value == currentUser.icon)?.key ?? 'default';
                    DocumentReference memberReference = await firestore.collection('members').add({
                      'icon': icon,
                      'name': textEditingController.text,
                      'userFirebaseId': currentUser.userFirebaseId,
                      'transactions': [],
                    });
                    textEditingController.text = '';

                    var oldMemberData = await firestore.collection('groups').doc(groupId).get();
                    List<dynamic> memberList = oldMemberData.data()!['members'];
                    memberList.add(memberReference);

                    firestore.collection('groups').doc(groupId).update({'members': memberList});
                  }
                },
                text: 'add_member'.tr,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
        color: color,
      ),
    );
  }
}
