import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/src/transformers/switch_map.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/data/pie_data.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/transactions/transaction_list_page.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/ui/widgets/tab.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MemberDetailsPage extends StatelessWidget {
  MemberDetailsPage({Key? key, required this.firestore, required this.member, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final Member member;
  final GroupData groupData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: member.name),
      body: Padding(
        padding: EdgeInsets.all(h(8)),
        child: StreamBuilder(
            stream: firestore.collection('members').doc(member.databaseId).snapshots().switchMap((member) {
              if ((member.data()!['transactions'] as List).isNotEmpty) {
                return CombineLatestStream.list(member
                    .data()!['transactions']
                    .map<Stream<DocumentSnapshot>>((transaction) => (transaction as DocumentReference).snapshots()));
              } else {
                return CombineLatestStream.list([
                  Stream.fromIterable([''])
                ]);
              }
            }),
            builder: (BuildContext context, AsyncSnapshot transactionListSnapshot) {
              if (transactionListSnapshot.connectionState == ConnectionState.active ||
                  transactionListSnapshot.connectionState == ConnectionState.done) {
                if (transactionListSnapshot.hasData && transactionListSnapshot.data?.first == '') {
                  return Column(
                    children: [
                      Center(child: Text('member_no_transactions'.tr)), //TODO no transaction found screen
                      const Spacer(),
                      Button(
                        text: 'delete_member'.tr,
                        onPressed: () async {
                          if (member.userFirebaseId != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ErrorDialog(
                                  title: 'member_delete_failed'.tr,
                                  message: 'member_delete_has_person'.tr,
                                  color: groupData.color,
                                );
                              },
                            );
                          } else if (member.transactions.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AreYouSureDialog(
                                  title: 'are_you_sure'.tr,
                                  message: 'member_delete_no_transactions_no_person'.tr,
                                  okText: 'delete'.tr,
                                  cancelText: 'cancel'.tr,
                                  color: groupData.color,
                                );
                              },
                            ).then((value) async {
                              if (value != null && value) {
                                await firestore.collection('members').doc(member.databaseId).delete();
                                var oldMemberData = await firestore.collection('groups').doc(groupData.groupId).get();
                                List<dynamic> memberList = oldMemberData.data()!['members'];
                                memberList.removeWhere((element) => element.id == member.databaseId);

                                firestore.collection('groups').doc(groupData.groupId).update({'members': memberList});
                              }
                              Get.back();
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ErrorDialog(
                                  title: 'member_delete_failed'.tr,
                                  message: 'member_delete_cannot_remove'.tr,
                                  color: groupData.color,
                                );
                              },
                            );
                          }
                        },
                        textColor: groupData.color,
                        buttonColor: groupData.color.withOpacity(0.2),
                      ),
                    ],
                  );
                }
                if (transactionListSnapshot.hasData) {
                  List<spending_share_transaction.Transaction> transactions = [];
                  transactionListSnapshot.data
                      ?.forEach((element) => transactions.add(spending_share_transaction.Transaction.fromDocument(element)));
                  transactions = transactions.reversed.toList();
                  return Column(
                    children: [
                      /*Padding(
                            padding: EdgeInsets.all(h(8)),
                            child: Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: transactionListSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return TransactionRowItem(
                                    transactions[index],
                                    groupData: GroupData(
                                      groupId: groupData.groupId,
                                      color: groupData.color,
                                      icon: null,
                                    ),
                                    firestore: firestore,
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(height: h(10)),
                              ),
                            ),
                          ),*/
                      Padding(
                        padding: EdgeInsets.all(h(8)),
                        child: StreamBuilder<List<DocumentSnapshot>>(
                            stream: firestore.collection('groups').doc(groupData.groupId).snapshots().switchMap((group) {
                              return CombineLatestStream.list(group
                                  .data()!['categories']
                                  .map<Stream<DocumentSnapshot>>((category) => (category as DocumentReference).snapshots()));
                            }),
                            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> categoryListSnapshot) {
                              if (categoryListSnapshot.hasData) {
                                List<Category> categories = [];
                                categoryListSnapshot.data?.forEach((element) => categories.add(Category.fromDocument(element)));
                                return TabNavigation(color: groupData.color, tabs: [
                                  SpendingShareTab(
                                    'this_month'.tr,
                                    _StatisticTab(
                                      firestore: firestore,
                                      start: DateTime(DateTime.now().year, DateTime.now().month, 1),
                                      end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
                                      categories: categories,
                                      transactions: transactions,
                                      groupData: groupData,
                                      member: member,
                                    ),
                                  ),
                                  SpendingShareTab(
                                    'last_month'.tr,
                                    _StatisticTab(
                                      firestore: firestore,
                                      start: DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
                                      end: DateTime(DateTime.now().year, DateTime.now().month, 0, 23, 59, 59),
                                      categories: categories,
                                      transactions: transactions,
                                      groupData: groupData,
                                      member: member,
                                    ),
                                  ),
                                  SpendingShareTab(
                                    'today'.tr,
                                    _StatisticTab(
                                      firestore: firestore,
                                      start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                      end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
                                      categories: categories,
                                      transactions: transactions,
                                      groupData: groupData,
                                      member: member,
                                    ),
                                  ),
                                  SpendingShareTab(
                                    'all_time'.tr,
                                    _StatisticTab(
                                      firestore: firestore,
                                      categories: categories,
                                      transactions: transactions,
                                      groupData: groupData,
                                      member: member,
                                    ),
                                  ),
                                ]);
                              } else {
                                return OnFutureBuildError(categoryListSnapshot);
                              }
                            }),
                      ),
                      const Spacer(),
                      Button(
                        text: 'delete_member'.tr,
                        onPressed: () async {
                          if (member.userFirebaseId != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ErrorDialog(
                                  title: 'member_delete_failed'.tr,
                                  message: 'member_delete_has_person'.tr,
                                  color: groupData.color,
                                );
                              },
                            );
                          } else if (member.transactions.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AreYouSureDialog(
                                  title: 'are_you_sure'.tr,
                                  message: 'member_delete_no_transactions_no_person'.tr,
                                  okText: 'delete'.tr,
                                  cancelText: 'cancel'.tr,
                                  color: groupData.color,
                                );
                              },
                            ).then((value) async {
                              if (value != null && value) {
                                await firestore.collection('members').doc(member.databaseId).delete();
                                var oldMemberData = await firestore.collection('groups').doc(groupData.groupId).get();
                                List<dynamic> memberList = oldMemberData.data()!['members'];
                                memberList.removeWhere((element) => element.id == member.databaseId);

                                firestore.collection('groups').doc(groupData.groupId).update({'members': memberList});
                              }
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ErrorDialog(
                                  title: 'member_delete_failed'.tr,
                                  message: 'member_delete_cannot_remove'.tr,
                                  color: groupData.color,
                                );
                              },
                            );
                          }
                        },
                        textColor: groupData.color,
                        buttonColor: groupData.color.withOpacity(0.2),
                      ),
                      Button( //TODO jo lenne, ha nem ay osszes tranzakciot mutatna, hanem csak azt ahova a statisztika tartozik
                        text: 'view_all_transactions'.tr,
                        onPressed: () => Get.to(() => TransactionListPage(
                              firestore: firestore,
                              spendingShareTransactions: transactions,
                              groupData: groupData,
                            )),
                        buttonColor: groupData.color,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return OnFutureBuildError(transactionListSnapshot);
              }
            }),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
        color: groupData.color,
      ),
    );
  }
}

class _StatisticTab extends StatelessWidget {
  _StatisticTab({
    Key? key,
    this.start,
    this.end,
    required this.groupData,
    required this.transactions,
    required this.categories,
    required this.member,
    required this.firestore,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final DateTime? start;
  final DateTime? end;
  final GroupData groupData;
  final Member member;
  List<spending_share_transaction.Transaction> transactions;
  final List<Category> categories;
  double allSpentMoney = 0;
  double allIncome = 0;
  double allTransfers = 0;

  @override
  Widget build(BuildContext context) {
    transactions = transactions.where((element) {
      if (start != null && element.date.toDate().isBefore(start!)) return false;
      if (end != null && element.date.toDate().isAfter(end!)) return false;
      return true;
    }).toList();

    if (transactions.isEmpty) {
      return Center(child: Text('no_transactions_this_period'.tr));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('all_spent_money'.tr, style: TextStyleConstants.body_1_bold),
            TextFormat.roundedValueWithCurrencyAndColor(
              getAllSpentMoney(transactions),
              groupData.currency!,
              groupData.color,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('all_income'.tr, style: TextStyleConstants.body_1_bold),
            TextFormat.roundedValueWithCurrencyAndColor(
              getAllIncome(transactions),
              groupData.currency!,
              groupData.color,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('all_transfers'.tr, style: TextStyleConstants.body_1_bold),
            TextFormat.roundedValueWithCurrencyAndColor(
              getAllTransfers(transactions),
              groupData.currency!,
              groupData.color,
            ),
          ],
        ),
        Center(
            child: SfCircularChart(
                title: ChartTitle(text: 'money_spent_by_categories'.tr, textStyle: TextStyleConstants.body_1_bold),
                legend: Legend(isVisible: true),
                series: <PieSeries<PieData, String>>[
              PieSeries<PieData, String>(
                  explode: true,
                  explodeIndex: 0,
                  dataSource: getData(transactions, categories, groupData.currency!),
                  xValueMapper: (PieData data, _) => data.xData,
                  yValueMapper: (PieData data, _) => data.yData,
                  dataLabelMapper: (PieData data, _) => data.text,
                  dataLabelSettings: const DataLabelSettings(isVisible: true)),
            ])),
      ],
    );
  }

  double getAllSpentMoney(List<spending_share_transaction.Transaction> transactions) {
    allSpentMoney = 0;
    for (var element in transactions) {
      if (element.type == TransactionType.expense) {
        int i = element.to.indexWhere((element) => element.id == member.databaseId);
        double amount = double.tryParse(element.toAmounts!.elementAt(i))!;
        allSpentMoney += amount * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }
    return allSpentMoney;
  }

  double getAllIncome(List<spending_share_transaction.Transaction> transactions) {
    allIncome = 0;
    for (var element in transactions) {
      int i = element.to.indexWhere((element) => element.id == member.databaseId);
      if (element.type == TransactionType.income && i != -1) {
        allIncome += element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }
    return allIncome;
  }

  double getAllTransfers(List<spending_share_transaction.Transaction> transactions) {
    allTransfers = 0;
    for (var element in transactions) {
      int i = element.to.indexWhere((element) => element.id == member.databaseId);
      if (element.type == TransactionType.transfer && i != -1) {
        allTransfers += element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
      if (element.type == TransactionType.transfer && element.from?.id == member.databaseId) {
        allTransfers -= element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }
    return allTransfers;
  }

  List<PieData> getData(List<spending_share_transaction.Transaction> transactions, List<Category> categories, String currency) {
    Map<DocumentReference, double> valuePaidByCategories = {};
    for (var element in transactions) {
      if (element.type == TransactionType.expense) {
        int i = element.to.indexWhere((element) => element.id == member.databaseId);
        double amount = double.tryParse(element.toAmounts!.elementAt(i))!;
        if (valuePaidByCategories[element.category!] == null) valuePaidByCategories[element.category!] = 0;
        valuePaidByCategories[element.category!] = valuePaidByCategories[element.category!]! +
            amount * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }

    return valuePaidByCategories.entries.map((e) {
      String categoryName = categories.firstWhereOrNull((element) => element.databaseId == e.key.id)?.name ?? '';

      String value = '';
      if (e.value.floor() == e.value) {
        value = e.value.toInt().toString() + ' ' + currency;
      } else {
        value = (e.value.toString()) + ' ' + currency;
      }

      return PieData(categoryName, e.value, value);
    }).toList();
  }
}
