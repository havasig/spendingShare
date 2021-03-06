import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/categories/categroy_details_page.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/details/statistics/statistics.dart';
import 'package:spending_share/ui/groups/details/transactions/transactions_list.dart';
import 'package:spending_share/ui/groups/settings/member_details_page.dart';
import 'package:spending_share/ui/helpers/fab/create_transaction_fab.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/transactions/create_transaction_page.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import '../settings/group_settings_page.dart';
import 'debts/debts_list.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({Key? key, required this.firestore, this.hasBack = true, required this.groupId}) : super(key: key);

  final FirebaseFirestore firestore;
  final bool hasBack;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    return StreamBuilder(
      stream: firestore.collection('groups').doc(groupId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Group group = Group.fromDocument(snapshot.data!);

          return Scaffold(
            appBar: SpendingShareAppBar(
              hasBack: hasBack,
              hasForward: true,
              forwardText: 'settings'.tr,
              titleText: group.name,
              onForward: () => Get.to(() => GroupSettingsPage(
                    groupName: group.name,
                    firestore: firestore,
                    groupData:
                        GroupData(color: group.color, icon: group.icon, groupId: groupId, name: group.name, currency: group.currency),
                    isAdmin: group.adminId == currentUser.userFirebaseId,
                  )),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: h(16)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('members'.tr),
                    ),
                    Container(
                      key: const Key('members'),
                      alignment: Alignment.centerLeft,
                      height: h(120),
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: group.members.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: group.members[index].get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  var member = Member.fromDocument(snapshot.data!);
                                  return GestureDetector(
                                    onTap: () => Get.to(() => MemberDetailsPage(
                                        firestore: firestore,
                                        groupData: GroupData(
                                          color: group.color,
                                          groupId: groupId,
                                          currency: group.currency,
                                          icon: group.icon,
                                        ),
                                        member: member)),
                                    child: Draggable<Member>(
                                      data: member,
                                      dragAnchorStrategy: childDragAnchorStrategy,
                                      feedback: CircleIconButton(
                                        width: (MediaQuery.of(context).size.width - 197) / 7,
                                        //-padding*2 -iconWidth*4 -spacing*3
                                        color: group.color,
                                        icon: member.icon ?? group.icon,
                                      ),
                                      child: CircleIconButton(
                                        width: (MediaQuery.of(context).size.width - 197) / 8,
                                        //-padding*2 -iconWidth*4 -spacing*3
                                        color: group.color,
                                        name: member.name,
                                        icon: member.icon ?? group.icon,
                                      ),
                                    ),
                                  );
                                }
                                return OnFutureBuildError(snapshot);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(width: h(10))),
                    ),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('categories'.tr),
                    ),
                    SizedBox(
                      key: const Key('categories'),
                      height: h(getCategoriesHeight(group.categories)),
                      child: Wrap(
                        children: group.categories
                            .map<Widget>(
                              (c) => FutureBuilder<DocumentSnapshot>(
                                future: c.get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    var category = Category.fromDocument(snapshot.data!);
                                    return Padding(
                                        padding: EdgeInsets.only(right: h(10)),
                                        child: DragTarget<Member>(
                                          builder: (context, candidateItems, rejectedItems) {
                                            return CircleIconButton(
                                              onTap: () => Get.to(() => CategoryDetailsPage(
                                                    firestore: firestore,
                                                    category: category,
                                                    color: group.color,
                                                    groupId: groupId,
                                                    currency: group.currency,
                                                  )),
                                              width: (MediaQuery.of(context).size.width - 197) / 8,
                                              //-padding*2 -iconWidth*4 -spacing*3
                                              color: group.color,
                                              name: category.name,
                                              icon: category.icon ?? group.icon,
                                            );
                                          },
                                          onAccept: (member) {
                                            Get.to(() => CreateTransactionPage(
                                                  category: category,
                                                  member: member,
                                                  firestore: firestore,
                                                  groupData: GroupData(
                                                      groupId: groupId,
                                                      color: group.color,
                                                      icon: group.icon,
                                                      currency: group.currency,
                                                      name: group.name),
                                                ));
                                          },
                                        ));
                                  }
                                  return OnFutureBuildError(snapshot);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('debts'.tr),
                    ),
                    DebtsList(
                      group.debts,
                      groupId: groupId,
                      firestore: firestore,
                      currency: group.currency,
                      color: group.color,
                      icon: group.icon,
                      key: const Key('debt_list'),
                    ),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('transactions'.tr),
                    ),
                    TransactionsList(
                      group.transactions.reversed.toList(),
                      groupData: GroupData(
                        color: group.color,
                        icon: group.icon,
                        currency: group.currency,
                        groupId: groupId,
                      ),
                      firestore: firestore,
                      key: const Key('transaction_list'),
                    ),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('statistics'.tr),
                    ),
                    Statistics(color: group.color, key: const Key('statistics')),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    SizedBox(height: h(65)),
                  ],
                ),
              ),
            ),
            floatingActionButton: CreateTransactionFab(
              firestore: firestore,
              groupData: GroupData(
                color: group.color,
                icon: group.icon,
                currency: group.currency,
                groupId: groupId,
              ),
              key: const Key('create_transaction_button'),
            ),
            bottomNavigationBar: SpendingShareBottomNavigationBar(
                key: const Key('bottom_navigation'), firestore: firestore, selectedIndex: 1, color: group.color),
          );
        }

        return OnFutureBuildError(snapshot);
      },
    );
  }

  double getCategoriesHeight(List list) {
    int wholePart = list.length ~/ 3;
    if (list.length % 4 == 0) {
      return wholePart * 100;
    }
    return (wholePart + 1) * 100;
  }
}
