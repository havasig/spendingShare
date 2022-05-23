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
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/ui/widgets/tab.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GroupStatisticsPage extends StatelessWidget {
  const GroupStatisticsPage({Key? key, required this.firestore, required this.groupData, required this.groupName}) : super(key: key);

  final FirebaseFirestore firestore;
  final String groupName;
  final GroupData groupData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: groupName),
      body: Padding(
        padding: EdgeInsets.all(h(8)),
        child: StreamBuilder(
            stream: firestore.collection('groups').doc(groupData.groupId).snapshots().switchMap((group) {
              if ((group.data()!['transactions'] as List).isNotEmpty) {
                return CombineLatestStream.list(group
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
                      Center(child: Text('group_no_transactions'.tr)), //TODO no transaction found screen
                    ],
                  );
                }
                if (transactionListSnapshot.hasData) {
                  List<spending_share_transaction.Transaction> transactions = [];
                  transactionListSnapshot.data
                      ?.forEach((element) => transactions.add(spending_share_transaction.Transaction.fromDocument(element)));
                  transactions = transactions.reversed.toList();
                  return Padding(
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
                            return StreamBuilder<List<DocumentSnapshot>>(
                                stream: firestore.collection('groups').doc(groupData.groupId).snapshots().switchMap((group) {
                                  return CombineLatestStream.list(group
                                      .data()!['members']
                                      .map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                                }),
                                builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                                  if (memberListSnapshot.hasData) {
                                    List<Member> members = [];
                                    memberListSnapshot.data?.forEach((element) => members.add(Member.fromDocument(element)));
                                    return TabNavigation(
                                      key: const Key('time_selector'),
                                      color: groupData.color,
                                      tabs: [
                                        SpendingShareTab(
                                          'this_month'.tr,
                                          _GroupStatisticsTab(
                                            firestore: firestore,
                                            start: DateTime(DateTime.now().year, DateTime.now().month, 1),
                                            end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
                                            categories: categories,
                                            transactions: transactions,
                                            groupData: groupData,
                                            members: members,
                                          ),
                                        ),
                                        SpendingShareTab(
                                          'last_month'.tr,
                                          _GroupStatisticsTab(
                                            firestore: firestore,
                                            start: DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
                                            end: DateTime(DateTime.now().year, DateTime.now().month, 0, 23, 59, 59),
                                            categories: categories,
                                            transactions: transactions,
                                            groupData: groupData,
                                            members: members,
                                          ),
                                        ),
                                        SpendingShareTab(
                                          'today'.tr,
                                          _GroupStatisticsTab(
                                            firestore: firestore,
                                            start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                            end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
                                            categories: categories,
                                            transactions: transactions,
                                            groupData: groupData,
                                            members: members,
                                          ),
                                        ),
                                        SpendingShareTab(
                                          'all_time'.tr,
                                          _GroupStatisticsTab(
                                            firestore: firestore,
                                            categories: categories,
                                            transactions: transactions,
                                            groupData: groupData,
                                            members: members,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return OnFutureBuildError(categoryListSnapshot);
                                  }
                                });
                          } else {
                            return OnFutureBuildError(categoryListSnapshot);
                          }
                        }),
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

class _GroupStatisticsTab extends StatelessWidget {
  _GroupStatisticsTab({
    Key? key,
    this.start,
    this.end,
    required this.groupData,
    required this.transactions,
    required this.categories,
    required this.members,
    required this.firestore,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final DateTime? start;
  final DateTime? end;
  final GroupData groupData;
  List<spending_share_transaction.Transaction> transactions;
  final List<Category> categories;
  final List<Member> members;
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
      return Center(child: Text('group_no_transactions_this_period'.tr));
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
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
                      dataSource: getCategoryChartData(transactions, categories, groupData.currency!),
                      xValueMapper: (PieData data, _) => data.xData,
                      yValueMapper: (PieData data, _) => data.yData,
                      dataLabelMapper: (PieData data, _) => data.text,
                      dataLabelSettings: const DataLabelSettings(isVisible: true)),
                ])),
            Center(
                child: SfCartesianChart(
              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              primaryXAxis: CategoryAxis(),
              series: getMemberChartData(transactions, members, categories, groupData.currency!),
              title: ChartTitle(text: 'money_spent_by_members'.tr, textStyle: TextStyleConstants.body_1_bold),
            )),
          ],
        ),
      ),
    );
  }

  List<ChartSeries> getMemberChartData(
      List<spending_share_transaction.Transaction> transactions, List<Member> members, List<Category> categories, String currency) {
    Map<Member, List<double>> valuePaidByMembersByCategories = {};

    for (int i = 0; i < members.length; i++) {
      var member = members.elementAt(i);
      valuePaidByMembersByCategories[member] = List.generate(categories.length, (index) => 0);
      for (int j = 0; j < categories.length; j++) {
        var category = categories.elementAt(j);
        for (var transaction in transactions) {
          if (transaction.type == TransactionType.expense && transaction.category!.id == category.databaseId) {
            int index = transaction.to.indexWhere((element) => element.id == member.databaseId);
            double amount = double.tryParse(transaction.toAmounts!.elementAt(index))!;
            valuePaidByMembersByCategories[member]![j] = valuePaidByMembersByCategories[member]![j] +
                amount * (transaction.exchangeRate != null ? double.tryParse(transaction.exchangeRate!) ?? 1 : 1);
          }
        }
      }
    }

    List<ChartSeries> result = [];

    for (int j = 0; j < categories.length; j++) {
      result.add(StackedColumnSeries<MapEntry<Member, List<double>>, String>(
        dataSource: valuePaidByMembersByCategories.entries.toList(),
        xValueMapper: (MapEntry<Member, List<double>> data, _) => data.key.name,
        yValueMapper: (MapEntry<Member, List<double>> data, _) => data.value[j],
        dataLabelMapper: (MapEntry<Member, List<double>> data, _) => categories[j].name,
        name: categories[j].name,
      ));
    }

    return result;
  }

  List<PieData> getCategoryChartData(
      List<spending_share_transaction.Transaction> transactions, List<Category> categories, String currency) {
    Map<DocumentReference, double> valuePaidByCategories = {};
    for (var element in transactions) {
      if (element.type == TransactionType.expense) {
        if (valuePaidByCategories[element.category!] == null) valuePaidByCategories[element.category!] = 0;
        valuePaidByCategories[element.category!] = valuePaidByCategories[element.category!]! +
            element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
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

  double getAllSpentMoney(List<spending_share_transaction.Transaction> transactions) {
    allSpentMoney = 0;
    for (var element in transactions) {
      if (element.type == TransactionType.expense) {
        allSpentMoney += element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }
    return allSpentMoney;
  }

  double getAllIncome(List<spending_share_transaction.Transaction> transactions) {
    allIncome = 0;
    for (var element in transactions) {
      if (element.type == TransactionType.income) {
        allIncome += element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }
    return allIncome;
  }

  double getAllTransfers(List<spending_share_transaction.Transaction> transactions) {
    allTransfers = 0;
    for (var element in transactions) {
      if (element.type == TransactionType.transfer) {
        allTransfers += element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }
    return allTransfers;
  }
}
