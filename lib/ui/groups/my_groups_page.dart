import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/src/transformers/switch_map.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/details/group_details_page.dart';
import 'package:spending_share/ui/groups/join_page.dart';
import 'package:spending_share/ui/helpers/fab/create_group_fab.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/loading_indicator.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    var currentUserFirebaseId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<List<DocumentSnapshot>>(
        stream: firestore.collection('users').where('userFirebaseId', isEqualTo: currentUserFirebaseId).snapshots().switchMap((user) =>
            CombineLatestStream.list(
                user.docs.first['groups'].map<Stream<DocumentSnapshot>>((group) => (group as DocumentReference).snapshots()))),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> groupListSnapshot) {
          if (groupListSnapshot.hasData) {
            if (groupListSnapshot.data!.isNotEmpty) {
              return HaveGroups(
                groups: groupListSnapshot.data!,
                firestore: firestore,
                color: currentUser.color,
              );
            } else {
              return NoGroupsYet(
                firestore: firestore,
                color: currentUser.color,
              );
            }
          }
          return LoadingPage(
            firestore: firestore,
            color: currentUser.color,
          );
        });
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key, required this.firestore, required this.color}) : super(key: key);

  final MaterialColor color;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        titleText: 'my_groups'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: const LoadingIndicator(),
      ),
      floatingActionButton: CreateGroupFab(firestore: firestore, color: color),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
        color: color,
      ),
    );
  }
}

class NoGroupsYet extends StatelessWidget {
  const NoGroupsYet({Key? key, required this.firestore, required this.color}) : super(key: key);

  final MaterialColor color;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    SpendingShareUser currentUser = Provider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        titleText: 'my_groups'.tr,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(h(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'no_groups'.tr,
                      style: TextStyleConstants.body_2_medium,
                    ),
                    SizedBox(height: h(8)),
                    Text(
                      'you_are_not_a_member'.tr,
                      style: TextStyleConstants.sub_1,
                    ),
                    SizedBox(height: h(16)),
                    Text(
                      'paste_code_here'.tr,
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
      floatingActionButton: CreateGroupFab(firestore: firestore, color: color),
      bottomNavigationBar:
          SpendingShareBottomNavigationBar(key: const Key('bottom_navigation'), selectedIndex: 1, firestore: firestore, color: color),
    );
  }
}

class HaveGroups extends StatelessWidget {
  const HaveGroups({Key? key, required this.groups, required this.firestore, required this.color}) : super(key: key);

  final MaterialColor color;
  final List<DocumentSnapshot> groups;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        hasForward: true,
        forwardText: 'join'.tr,
        titleText: 'my_groups'.tr,
        onForward: () => Get.to(() => JoinPage(firestore: firestore)),
      ),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: Container(
          alignment: Alignment.topLeft,
          child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 10,
              spacing: 15,
              children: groups.map((group) {
                Group g = Group.fromDocument(group);
                return CircleIconButton(
                  onTap: () => Get.to(() => GroupDetailsPage(firestore: firestore, groupId: group.id)),
                  width: (MediaQuery.of(context).size.width - 197) / 8,
                  //-padding*2 -iconWidth*4 -spacing*3
                  color: g.color,
                  name: g.name,
                  icon: g.icon,
                );
              }).toList()),
        ),
      ),
      floatingActionButton: CreateGroupFab(firestore: firestore, color: color),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
        color: color,
      ),
    );
  }
}
