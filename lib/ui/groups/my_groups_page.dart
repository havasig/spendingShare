import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/src/transformers/switch_map.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/details/group_details_page.dart';
import 'package:spending_share/ui/groups/join/join_page.dart';
import 'package:spending_share/ui/helpers/fab/create_group_fab.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/loading_indicator.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'join/join_group_input_and_buttons.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({Key? key, required this.firestore, this.auth}) : super(key: key);

  final FirebaseFirestore firestore;
  final FirebaseAuth? auth;

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context, listen: false);
    var currentUserFirebaseId = auth?.currentUser?.uid ?? FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<List<dynamic>>(
        stream: firestore.collection('users').where('userFirebaseId', isEqualTo: currentUserFirebaseId).snapshots().switchMap((user) {
          if ((user.docs.first['groups'] as List).isNotEmpty) {
            return CombineLatestStream.list(
                user.docs.first['groups'].map<Stream<dynamic>>((group) => (group as DocumentReference).snapshots()));
          } else {
            return Stream.fromIterable([['']]);
          }
        }),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> groupListSnapshot) {
          if (groupListSnapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(
              firestore: firestore,
              color: currentUser.color,
              snapshot: groupListSnapshot,
            );
          }
          if (groupListSnapshot.hasData && groupListSnapshot.data?.first != '') {
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
        });
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key, required this.firestore, required this.color, required this.snapshot}) : super(key: key);

  final MaterialColor color;
  final FirebaseFirestore firestore;
  final AsyncSnapshot<dynamic> snapshot;

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
        child: snapshot.hasError ? Text('something_went_wrong'.tr) : const LoadingIndicator(),
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

class NoGroupsYet extends StatefulWidget {
  const NoGroupsYet({Key? key, required this.firestore, required this.color}) : super(key: key);

  final MaterialColor color;
  final FirebaseFirestore firestore;

  @override
  State<NoGroupsYet> createState() => _NoGroupsYetState();
}

class _NoGroupsYetState extends State<NoGroupsYet> {
  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    final TextEditingController textEditingController = TextEditingController();
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
                    JoinGroupInputAndButtons(firestore: widget.firestore, color: widget.color),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CreateGroupFab(firestore: widget.firestore, color: widget.color),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
          key: const Key('bottom_navigation'), selectedIndex: 1, firestore: widget.firestore, color: widget.color),
    );
  }
}

class HaveGroups extends StatelessWidget {
  const HaveGroups({Key? key, required this.groups, required this.firestore, required this.color}) : super(key: key);

  final MaterialColor color;
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
        titleText: 'my_groups'.tr,
        onForward: () => Get.to(() => JoinPage(firestore: firestore, color: color)),
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
