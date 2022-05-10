import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/data/pie_data.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/helpers/transaction_row_item.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/tab.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryDetailsPage extends StatelessWidget {
  CategoryDetailsPage(
      {Key? key, required this.firestore, required this.category, required this.color, required this.groupId, required this.currency})
      : super(key: key);

  final FirebaseFirestore firestore;
  final Category category;
  final MaterialColor color;
  final String groupId;
  final String currency;
  double sumValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: category.name),
      body: Padding(
        padding: EdgeInsets.all(h(8)),
        child: StreamBuilder<List<DocumentSnapshot>>(
            stream: firestore.collection('categories').doc(category.databaseId).snapshots().switchMap((category) {
              return CombineLatestStream.list(category
                  .data()!['transactions']
                  .map<Stream<DocumentSnapshot>>((transaction) => (transaction as DocumentReference).snapshots()));
            }),
            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> transactionListSnapshot) {
              if (transactionListSnapshot.connectionState == ConnectionState.active ||
                  transactionListSnapshot.connectionState == ConnectionState.done) {
                if (transactionListSnapshot.hasData) {
                  List<spending_share_transaction.Transaction> transactions = [];
                  transactionListSnapshot.data
                      ?.forEach((element) => transactions.add(spending_share_transaction.Transaction.fromDocument(element)));
                  transactions = transactions.reversed.toList();
                  return TabNavigation(color: color, tabs: [
                    SpendingShareTab(
                      'transactions'.tr,
                      Padding(
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
                                  groupId: groupId,
                                  color: color,
                                  icon: category.icon,
                                ),
                                firestore: firestore,
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(height: h(10)),
                          ),
                        ),
                      ),
                    ),
                    SpendingShareTab(
                      'statistics'.tr,
                      Padding(
                        padding: EdgeInsets.all(h(8)),
                        child: StreamBuilder<List<DocumentSnapshot>>(
                            stream: firestore.collection('groups').doc(groupId).snapshots().switchMap((group) {
                              return CombineLatestStream.list(group
                                  .data()!['members']
                                  .map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                            }),
                            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                              if (memberListSnapshot.hasData) {
                                List<Member> members = [];
                                memberListSnapshot.data?.forEach((element) => members.add(Member.fromDocument(element)));
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('all_spent_money'.tr, style: TextStyleConstants.body_1_bold),
                                        TextFormat.roundedValueWithCurrencyAndColor(getSumValue(transactions), currency, color),
                                      ],
                                    ),
                                    Center(
                                        child: SfCircularChart(
                                            title: ChartTitle(text: 'money_spent_by_person'.tr, textStyle: TextStyleConstants.body_1_bold),
                                            legend: Legend(isVisible: true),
                                            series: <PieSeries<PieData, String>>[
                                          PieSeries<PieData, String>(
                                              explode: true,
                                              explodeIndex: 0,
                                              dataSource: getData(transactions, members, currency),
                                              xValueMapper: (PieData data, _) => data.xData,
                                              yValueMapper: (PieData data, _) => data.yData,
                                              dataLabelMapper: (PieData data, _) => data.text,
                                              dataLabelSettings: const DataLabelSettings(isVisible: true)),
                                        ])),
                                  ],
                                );
                              } else {
                                return OnFutureBuildError(memberListSnapshot);
                              }
                            }),
                      ),
                    )
                  ]);
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return OnFutureBuildError(transactionListSnapshot);
              }
            }),
      ),
    );
  }

  double getSumValue(List<spending_share_transaction.Transaction> transactions) {
    sumValue = 0;
    for (var element in transactions) {
      sumValue += element.value * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
    }
    return sumValue;
  }

  List<PieData> getData(List<spending_share_transaction.Transaction> transactions, List<Member> members, String currency) {
    Map<DocumentReference, double> valuePaidByMember = {};
    for (var element in transactions) {
      for (int i = 0; i < element.to.length; i++) {
        if (valuePaidByMember[element.to[i]] == null) valuePaidByMember[element.to[i]] = 0;
        valuePaidByMember[element.to[i]] = valuePaidByMember[element.to[i]]! +
            double.tryParse(element.toAmounts![i])! * (element.exchangeRate != null ? double.tryParse(element.exchangeRate!) ?? 1 : 1);
      }
    }

    return valuePaidByMember.entries.map((e) {
      String username = members.where((element) => element.databaseId == e.key.id).first.name;

      String value = '';
      if (e.value.floor() == e.value) {
        value = e.value.toInt().toString() + ' ' + currency;
      } else {
        value = (e.value.toString()) + ' ' + currency;
      }

      return PieData(username, e.value, value);
    }).toList();
  }
}
