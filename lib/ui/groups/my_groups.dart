import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/group_icon.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  CollectionReference get groups => firestore.collection('groups');

  @override
  Widget build(BuildContext context) {
    //TODO get my groups
    Stream<QuerySnapshot<Object?>> myGroups = groups.where('name', isEqualTo: 'adminokTalalkozoja').snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: myGroups,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return NoGroupsYet(firestore: firestore);
          } else {
            return HaveGroups(
              snapshot: snapshot,
              firestore: firestore,
            );
          }
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
        child: SingleChildScrollView(
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
      ),
      floatingActionButton: createGroupFab,
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }
}

class HaveGroups extends StatelessWidget {
  const HaveGroups({Key? key, required this.snapshot, required this.firestore}) : super(key: key);

  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseFirestore firestore;

  List<GroupIcon> getGroupItems(AsyncSnapshot<QuerySnapshot> snapshot, double iconWidth) {
    return snapshot.data?.docs.map((doc) {
          Group group = Group.fromDocument(doc);
          return GroupIcon(
            onTap: () {},
            group: group,
            width: iconWidth,
          );
        }).toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        hasBack: false,
        hasForward: true,
        forwardText: 'join'.tr,
        titleText: 'my-groups'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          alignment: Alignment.topCenter,
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 10,
            spacing: 15,
            children: getGroupItems(snapshot, (MediaQuery.of(context).size.width - 197) / 8), //-padding*2 -iconWidth*4 -spacing*3
          ),
        ),
      ),
      floatingActionButton: createGroupFab,
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }
}

Widget createGroupFab = Padding(
  padding: const EdgeInsets.all(8.0),
  child: FloatingActionButton(
    key: const Key('create_group'),
    tooltip: 'create_group',
    backgroundColor: ColorConstants.defaultOrange,
    splashColor: ColorConstants.lightGray,
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
);
