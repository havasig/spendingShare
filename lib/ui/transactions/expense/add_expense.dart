import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/debt.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/transactions/expense/equally_user_row.dart';
import 'package:spending_share/ui/transactions/expense/weight_user_row.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';
import 'package:spending_share/utils/debt_calculator.dart';
import 'package:tuple/tuple.dart';

import '../../../models/member.dart';
import '../../../models/user.dart';
import '../../../utils/screen_util_helper.dart';
import '../../../utils/text_validator.dart';
import '../../constants/color_constants.dart';
import '../../groups/details/group_details_page.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';
import '../../helpers/on_future_build_error.dart';
import '../../widgets/button.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/dialogs/error_dialog.dart';
import '../../widgets/input_field.dart';
import '../../widgets/spending_share_appbar.dart';
import '../../widgets/spending_share_bottom_navigation_bar.dart';
import '../../widgets/tab.dart';
import '../calculator.dart';
import 'amount_user_row.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({Key? key, required this.firestore, this.oldExpense}) : super(key: key);

  final FirebaseFirestore firestore;
  final spending_share_transaction.Transaction? oldExpense;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = oldExpense?.name ?? '';

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<CreateTransactionData>(
        builder: (_, createTransactionData, __) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: SpendingShareAppBar(titleText: 'add_expense'.tr),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(h(16)),
              child: Consumer<CreateTransactionChangeNotifier>(
                builder: (_, createTransactionChangeNotifier, __) => Column(
                  children: [
                    Column(
                      children: [
                        InputField(
                          key: const Key('expense_name_field'),
                          focusNode: focusNode,
                          textEditingController: textEditingController,
                          hintText: 'expense_name'.tr,
                          labelText: 'expense_name'.tr,
                          prefixIcon: Icon(Icons.group_add, color: createTransactionData.color),
                          validator: TextValidator.validateIsNotEmpty,
                          labelColor: createTransactionData.color.shade500,
                          focusColor: createTransactionData.color.shade500,
                        ),
                      ],
                    ),
                    SizedBox(height: h(16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: createTransactionData.member?.get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              var member = Member.fromDocument(snapshot.data!);
                              return Column(
                                children: [
                                  CircleIconButton(
                                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                    width: 20,
                                    color: createTransactionData.color,
                                    icon: member.icon ?? createTransactionData.groupIcon,
                                  ),
                                  Text(member.name + ' ' + 'paid'.tr),
                                ],
                              );
                            }
                            return OnFutureBuildError(snapshot);
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              createTransactionChangeNotifier.value + ' ' + createTransactionChangeNotifier.currency,
                              style: TextStyleConstants.value(createTransactionData.color),
                            ),
                            SizedBox(height: h(16)),
                            Row(
                              children: [
                                TextFormat.date(createTransactionChangeNotifier.date),
                                Icon(
                                  Icons.calendar_today,
                                  color: createTransactionData.color.shade500,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    if (createTransactionChangeNotifier.exchangeRate != null)
                      Row(
                        children: [
                          Text('exchange_rate'.tr),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text('1 ' + createTransactionChangeNotifier.currency),
                                  const Icon(Icons.arrow_forward_outlined),
                                  Text(createTransactionChangeNotifier.exchangeRate.toString() +
                                      ' ' +
                                      createTransactionChangeNotifier.defaultCurrency!),
                                ],
                              ),
                              Text((createTransactionChangeNotifier.exchangeRate! * double.tryParse(createTransactionChangeNotifier.value)!)
                                      .toString() +
                                  ' ' +
                                  createTransactionChangeNotifier.defaultCurrency!),
                            ],
                          ),
                        ],
                      ),
                    TabNavigation(color: createTransactionData.color, tabs: [
                      SpendingShareTab(
                        'equally'.tr,
                        equally(createTransactionData),
                      ),
                      SpendingShareTab(
                        'amounts'.tr,
                        amount(createTransactionData),
                        onSelect: (context) => onSelectTab(createTransactionData, createTransactionChangeNotifier, context, 1),
                      ),
                      SpendingShareTab(
                        'weights'.tr,
                        weight(createTransactionData),
                        onSelect: (context) => onSelectTab(createTransactionData, createTransactionChangeNotifier, context, 2),
                      ),
                    ]),
                    Button(
                      onPressed: () async {
                        String name = textEditingController.text.isNotEmpty ? textEditingController.text : 'expense'.tr;
                        createTransactionChangeNotifier.setName(name);
                        try {
                          late DocumentReference expenseReference;

                          DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
                              await firestore.collection('groups').doc(createTransactionData.groupId).get();
                          List<dynamic> newTransactionReferenceList = groupSnapshot.data()!['transactions'];

                          if (oldExpense != null) {
                            await firestore.collection('transactions').doc(oldExpense!.databaseId).set({
                              'category': createTransactionData.category,
                              'currency': createTransactionChangeNotifier.currency,
                              'date': createTransactionChangeNotifier.date,
                              'exchangeRate': createTransactionChangeNotifier.exchangeRate,
                              'from': createTransactionData.member,
                              'name': createTransactionChangeNotifier.name,
                              'to': createTransactionChangeNotifier.to.keys.toList(),
                              'toAmounts': createTransactionChangeNotifier.to.values.map((e) => e.item1).toList(),
                              'toWeights': createTransactionChangeNotifier.to.values.map((e) => e.item2).toList(),
                              'value': double.parse(createTransactionChangeNotifier.value),
                            }, SetOptions(merge: true));

                            expenseReference = firestore.collection('transactions').doc(oldExpense!.databaseId);
                            //remove from old members transcation list
                            for (DocumentReference toItem in oldExpense!.to) {
                              DocumentSnapshot memberSnapshot = await toItem.get();
                              List<dynamic> newMemberTransactionReferenceList = memberSnapshot['transactions'];
                              newMemberTransactionReferenceList.removeWhere((element) => element.id == expenseReference.id);
                              toItem.set({'transactions': newMemberTransactionReferenceList}, SetOptions(merge: true));
                            }

                            //remove from old category transaction list
                            DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
                                await oldExpense!.category!.get() as DocumentSnapshot<Map<String, dynamic>>;
                            List<dynamic> newExpenseReferenceList = categorySnapshot.data()!['transactions'];
                            newExpenseReferenceList.removeWhere((element) => element.id == expenseReference.id);
                            await firestore
                                .collection('categories')
                                .doc(oldExpense!.category!.id)
                                .set({'transactions': newExpenseReferenceList}, SetOptions(merge: true));
                          } else {
                            SpendingShareUser user = Provider.of(context, listen: false);
                            DocumentReference userReference = firestore.collection('users').doc(user.databaseId);

                            expenseReference = await firestore.collection('transactions').add({
                              'category': createTransactionData.category,
                              'createdBy': userReference,
                              'currency': createTransactionChangeNotifier.currency,
                              'date': createTransactionChangeNotifier.date,
                              'exchangeRate': createTransactionChangeNotifier.exchangeRate,
                              'from': createTransactionData.member,
                              'name': createTransactionChangeNotifier.name,
                              'to': createTransactionChangeNotifier.to.keys.toList(),
                              'toAmounts': createTransactionChangeNotifier.to.values.map((e) => e.item1).toList(),
                              'toWeights': createTransactionChangeNotifier.to.values.map((e) => e.item2).toList(),
                              'type': createTransactionChangeNotifier.type.toString(),
                              'value': double.parse(createTransactionChangeNotifier.value),
                            });

                            //update transactions in group
                            newTransactionReferenceList.add(expenseReference);
                          }

                          //update members
                          for (DocumentReference toItem in createTransactionChangeNotifier.to.keys.toList()) {
                            DocumentSnapshot memberSnapshot = await toItem.get();
                            List<dynamic> newMemberTransactionReferenceList = memberSnapshot['transactions'];
                            newMemberTransactionReferenceList.add(expenseReference);
                            toItem.set({'transactions': newMemberTransactionReferenceList}, SetOptions(merge: true));
                          }

                          //update category
                          DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
                              await firestore.collection('categories').doc(createTransactionData.category?.id).get();
                          List<dynamic> newExpenseReferenceList = categorySnapshot.data()!['transactions'];
                          newExpenseReferenceList.add(expenseReference);
                          await firestore
                              .collection('categories')
                              .doc(createTransactionData.category?.id)
                              .set({'transactions': newExpenseReferenceList}, SetOptions(merge: true));

                          //calculate debts
                          List<dynamic> members = groupSnapshot.data()!['members'];
                          List<List<double>> graph =
                              List<List<double>>.generate(members.length, (index) => List<double>.generate(members.length, (i) => 0));

                          //load old debts
                          List<dynamic> oldDebts = groupSnapshot.data()!['debts'];
                          List<Debt> debts = [];
                          for (var element in oldDebts) {
                            debts.add(Debt.fromDocument(await element.get()));
                          }
                          for (var debt in debts) {
                            int row = members.lastIndexWhere((member) => member.id == debt.to.id);
                            int column = members.lastIndexWhere((member) => member.id == debt.from.id);
                            graph[row][column] = debt.value;
                          }

                          //add current expense
                          for (var to in createTransactionChangeNotifier.to.entries) {
                            graph[members.indexWhere((member) => member.id == createTransactionData.member!.id)]
                                    [members.indexWhere((member) => member.id == to.key.id)] +=
                                double.tryParse(to.value.item1)! * (createTransactionChangeNotifier.exchangeRate ?? 1);
                          }

                          //remove old expense
                          if (oldExpense != null) {
                            for (int i = 0; i < oldExpense!.to.length; i++) {
                              graph[members.indexWhere((member) => member.id == oldExpense!.from!.id)]
                                      [members.indexWhere((member) => member.id == oldExpense!.to[i].id)] -=
                                  double.tryParse(oldExpense!.toAmounts![i])! *
                                      (oldExpense?.exchangeRate != null ? double.tryParse(oldExpense!.exchangeRate!) ?? 1 : 1);
                            }
                          }

                          //calculate new debts
                          List<Tuple3<int, int, double>> newDebts = GFG(groupSnapshot.data()!['members'].length).minCashFlow(graph);

                          //save new debts
                          var newDebtDocumentReferenceList = [];
                          for (var element in newDebts) {
                            DocumentReference<Map<String, dynamic>> newDebtDocumentReference = await firestore.collection('debts').add({
                              'from': members[element.item2],
                              'to': members[element.item1],
                              'value': element.item3,
                            });
                            newDebtDocumentReferenceList.add(newDebtDocumentReference);
                          }

                          //delete old debts
                          for (var element in oldDebts) {
                            await firestore.collection('debts').doc(element.id).delete();
                          }

                          //save group
                          await firestore.collection('groups').doc(createTransactionData.groupId).set({
                            'transactions': newTransactionReferenceList,
                            'debts': newDebtDocumentReferenceList,
                          }, SetOptions(merge: true));

                          var groupId = createTransactionData.groupId!;

                          createTransactionChangeNotifier.clear();
                          createTransactionData.clear();

                          Get.to(() => GroupDetailsPage(
                                firestore: firestore,
                                hasBack: false,
                                groupId: groupId,
                              ));
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                          showDialog(
                            context: context,
                            builder: (context) {
                              return ErrorDialog(
                                title: 'transaction_creation_failed'.tr,
                                message: e.toString().tr,
                                color: createTransactionData.color,
                              );
                            },
                          );
                        }
                      },
                      text: 'save_expense'.tr,
                      buttonColor: createTransactionData.color.shade500,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SpendingShareBottomNavigationBar(
            selectedIndex: 1,
            firestore: firestore,
            color: createTransactionData.color,
          ),
        ),
      ),
    );
  }

  equally(CreateTransactionData createTransactionData) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: createTransactionData.allMembers.length,
      itemBuilder: (context, index) {
        return EquallyUserRow(
          memberReference: createTransactionData.allMembers.elementAt(index),
          color: createTransactionData.color,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: h(10)),
    );
  }

  amount(CreateTransactionData createTransactionData) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: createTransactionData.allMembers.length,
      itemBuilder: (context, index) {
        return AmountUserRow(
          memberReference: createTransactionData.allMembers.elementAt(index),
          groupData: GroupData(
            groupId: '',
            icon: createTransactionData.groupIcon,
            color: createTransactionData.color,
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: h(10)),
    );
  }

  weight(CreateTransactionData createTransactionData) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: createTransactionData.allMembers.length,
      itemBuilder: (context, index) {
        return WeightUserRow(
          memberReference: createTransactionData.allMembers.elementAt(index),
          color: createTransactionData.color,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: h(10)),
    );
  }

  onSelectTab(
      CreateTransactionData createTransactionData, CreateTransactionChangeNotifier createTransactionChangeNotifier, context, index) {
    return showBarModalBottomSheet(
      expand: true,
      context: context,
      builder: (context) {
        return Container(
          color: ColorConstants.backgroundBlack,
          padding: EdgeInsets.all(h(16)),
          child: TabNavigation(
            initIndex: index,
            color: createTransactionData.color,
            tabs: popupTabs(createTransactionData, createTransactionChangeNotifier),
          ),
        );
      },
    );
  }

  popupTabs(CreateTransactionData createTransactionData, CreateTransactionChangeNotifier createTransactionChangeNotifier) {
    return [
      SpendingShareTab(
        'equally'.tr,
        equally(createTransactionData),
      ),
      SpendingShareTab(
        'amounts'.tr,
        Column(
          children: [
            amount(createTransactionData),
            Calculator(
                color: createTransactionData.color,
                onEqualPressed: (double userInput) {
                  createTransactionChangeNotifier.setSelectedAmount(userInput);
                }),
          ],
        ),
      ),
      SpendingShareTab(
        'weights'.tr,
        Column(
          children: [
            weight(createTransactionData),
            Calculator(
                color: createTransactionData.color,
                onEqualPressed: (double userInput) {
                  createTransactionChangeNotifier.setSelectedWeight(userInput);
                }),
          ],
        ),
      ),
    ];
  }
}
