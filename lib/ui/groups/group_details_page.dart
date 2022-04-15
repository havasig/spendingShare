import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/helpers/add_transaction_fab.dart';
import 'package:spending_share/ui/groups/helpers/debts_list.dart';
import 'package:spending_share/ui/groups/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'group_settings_page.dart';
import 'helpers/create_group_fab.dart';

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
            body: SingleChildScrollView(
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
                                  icon: 'sport',
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
                    height: h(100),
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
                  DebtsList(group['transactions']),
                  Divider(
                    thickness: 1,
                    color: ColorConstants.white.withOpacity(0.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('transactions'.tr),
                  ),
                  Column(
                    children: List.generate(
                      group['transactions'].length > 5 ? 5 : group['transactions'].length,
                      (index) => FutureBuilder<DocumentSnapshot>(
                        future: group['transactions'][index].get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                            return Text(transaction.databaseId);
                          }
                          return OnFutureBuildError(snapshot);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Button(
                      onPressed: () {},
                      text: 'show_all_transactions'.tr,
                      textColor: ColorConstants.defaultOrange,
                      buttonColor: ColorConstants.defaultOrange.withOpacity(0.2),
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: ColorConstants.white.withOpacity(0.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('statistics'.tr),
                  ),
                  Column(
                    children: List.generate(
                      group['transactions'].length > 5 ? 5 : group['transactions'].length,
                      (index) => FutureBuilder<DocumentSnapshot>(
                        future: group['transactions'][index].get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                            return Text(transaction.databaseId);
                          }
                          return OnFutureBuildError(snapshot);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Button(
                      onPressed: () {},
                      text: 'show_all_statistics'.tr,
                      textColor: ColorConstants.defaultOrange,
                      buttonColor: ColorConstants.defaultOrange.withOpacity(0.2),
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: ColorConstants.white.withOpacity(0.2),
                  ),
                  SizedBox(height: h(65)),
                ],
              ),
            ),
            floatingActionButton: AddTransactionFab(firestore: firestore),
            bottomNavigationBar: SpendingShareBottomNavigationBar(
              firestore: firestore,
              selectedIndex: 1,
            ),
          );
        }

        return OnFutureBuildError(snapshot);
      },
    );
  }
}
