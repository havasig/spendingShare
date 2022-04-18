import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/details/add_transaction_fab.dart';
import 'package:spending_share/ui/groups/details/statistics/statistics.dart';
import 'package:spending_share/ui/groups/details/transactions/transactions_list.dart';
import 'package:spending_share/ui/groups/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import '../group_settings_page.dart';
import 'debts/debts_list.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({Key? key, required this.firestore, this.hasBack = true, required this.groupId}) : super(key: key);

  final FirebaseFirestore firestore;
  final bool hasBack;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('groups').doc(groupId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> group = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: SpendingShareAppBar(
              hasBack: hasBack,
              hasForward: true,
              forwardText: 'settings'.tr,
              titleText: group['name'],
              onForward: () => Get.to(() => GroupSettingsPage(firestore: firestore)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('members'.tr),
                    ),
                    SizedBox(
                      height: h(100),
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: group['members'].length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: group['members'][index].get(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  var member = Member.fromDocument(snapshot.data!);
                                  return CircleIconButton(
                                    onTap: () {},
                                    width: (MediaQuery.of(context).size.width - 197) / 8,
                                    //-padding*2 -iconWidth*4 -spacing*3
                                    color: group['color'],
                                    name: member.name,
                                    icon: member.icon ?? group['icon'],
                                  );
                                }
                                return OnFutureBuildError(snapshot);
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(width: 10)),
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
                      height: h(getCategoriesHeight(group['categories'])),
                      child: Wrap(
                        children: group['categories']
                            .map<Widget>(
                              (category) => FutureBuilder<DocumentSnapshot>(
                                future: category.get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    var category = Category.fromDocument(snapshot.data!);
                                    return CircleIconButton(
                                      onTap: () {},
                                      width: (MediaQuery.of(context).size.width - 197) / 8,
                                      //-padding*2 -iconWidth*4 -spacing*3
                                      color: group['color'],
                                      name: category.name,
                                      icon: category.icon,
                                    );
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
                      group['debts'],
                      currency: group['defaultCurrency'],
                      color: group['color'],
                      icon: group['icon'],
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
                      group['transactions'],
                      color: group['color'],
                      icon: group['icon'],
                    ),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('statistics'.tr),
                    ),
                    Statistics(color: group['color']),
                    Divider(
                      thickness: 1,
                      color: ColorConstants.white.withOpacity(0.2),
                    ),
                    SizedBox(height: h(65)),
                  ],
                ),
              ),
            ),
            floatingActionButton: AddTransactionFab(firestore: firestore, color: group['color']),
            bottomNavigationBar: SpendingShareBottomNavigationBar(
              firestore: firestore,
              selectedIndex: 1,
              color: group['color']
            ),
          );
        }

        return OnFutureBuildError(snapshot);
      },
    );
  }

  double getCategoriesHeight(List list) {
    int wholePart = list.length ~/ 4;
    if (list.length % 4 == 0) {
      return wholePart * 100;
    }
    return (wholePart + 1) * 100;
  }
}
