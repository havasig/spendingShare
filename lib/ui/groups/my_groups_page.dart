import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/join_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/create_group_fab.dart';
import 'package:spending_share/ui/widgets/group_icon.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    var currentUserFirebaseId = FirebaseAuth.instance.currentUser!.uid;
    Stream<QuerySnapshot<Object?>> me = firestore.collection('users').where('userFirebaseId', isEqualTo: currentUserFirebaseId).snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: me,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.first['groups'].isNotEmpty) {
            List<dynamic> groups = snapshot.data!.docs.first['groups'].map((doc) async {
              var document = await (doc as DocumentReference).get();
              return Group.fromDocument(document);
            }).toList();

            return HaveGroups(
              groups: groups,
              firestore: firestore,
            );
          }
          return NoGroupsYet(firestore: firestore);
        });
  }
}

class NoGroupsYet extends StatelessWidget {
  const NoGroupsYet({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        titleText: 'my-groups'.tr,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'no-groups'.tr,
                      style: TextStyleConstants.body_2_medium,
                    ),
                    SizedBox(height: h(8)),
                    Text(
                      'you-are-not-member'.tr,
                      style: TextStyleConstants.sub_1,
                    ),
                    SizedBox(height: h(16)),
                    Text(
                      'paste-code-here'.tr,
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
                      onPressed: () {},
                      text: 'join'.tr,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const CreateGroupFab(),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }
}

class HaveGroups extends StatelessWidget {
  const HaveGroups({Key? key, required this.groups, required this.firestore}) : super(key: key);

  final List<dynamic> groups;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        hasForward: true,
        forwardText: 'join'.tr,
        titleText: 'my-groups'.tr,
        onForward: () => Get.to(() => JoinPage(firestore: firestore)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          alignment: Alignment.topLeft,
          child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 15,
              children: groups.map((group) {
                return FutureBuilder(
                  future: group as Future<Group>,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GroupIcon(
                        onTap: () {},
                        group: snapshot.data as Group,
                        width: (MediaQuery.of(context).size.width - 197) / 8, //-padding*2 -iconWidth*4 -spacing*3
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              }).toList()),
        ),
      ),
      floatingActionButton: const CreateGroupFab(),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }
}
