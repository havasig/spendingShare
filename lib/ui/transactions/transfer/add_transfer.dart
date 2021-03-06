import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/debt.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/details/group_details_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/debt_calculator.dart';
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:tuple/tuple.dart';

import '../../constants/text_style_constants.dart';
import '../../helpers/on_future_build_error.dart';

class AddTransfer extends StatelessWidget {
  const AddTransfer({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    TextEditingController textEditingController = TextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<CreateTransactionChangeNotifier>(
        builder: (_, createTransactionChangeNotifier, __) => Consumer<CreateTransactionData>(
          builder: (_, createTransactionData, __) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SpendingShareAppBar(
              titleText: 'add_transfer'.tr,
            ),
            body: Padding(
              padding: EdgeInsets.all(h(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InputField(
                    key: const Key('transfer_name_field'),
                    focusNode: focusNode,
                    textEditingController: textEditingController,
                    hintText: 'transfer_name'.tr,
                    labelText: 'name'.tr,
                    prefixIcon: Icon(Icons.group_add, color: createTransactionData.color),
                    labelColor: createTransactionData.color,
                    focusColor: createTransactionData.color,
                  ),
                  SizedBox(height: h(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('transfer_from'.tr),
                          FutureBuilder<DocumentSnapshot>(
                            future: createTransactionData.member!.get(),
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
                                    Text(member.name),
                                  ],
                                );
                              }
                              return OnFutureBuildError(snapshot);
                            },
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_outlined, size: h(30)),
                      Column(
                        children: [
                          Text('transfer_to'.tr),
                          FutureBuilder<DocumentSnapshot>(
                            future: createTransactionChangeNotifier.to.entries.first.key.get(),
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
                                    Text(member.name),
                                  ],
                                );
                              }
                              return OnFutureBuildError(snapshot);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: h(16)),
                  Text(
                    createTransactionChangeNotifier.value + ' ' + createTransactionChangeNotifier.currency,
                    style: TextStyleConstants.value(createTransactionData.color),
                  ),
                  SizedBox(height: h(16)),
                  Row(
                    children: [
                      const Spacer(),
                      TextFormat.date(createTransactionChangeNotifier.date),
                      Icon(
                        Icons.calendar_today,
                        color: createTransactionData.color,
                      ),
                    ],
                  ),
                  if (createTransactionChangeNotifier.exchangeRate != null)
                    Column(
                      children: [
                        SizedBox(height: h(16)),
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
                                Text((createTransactionChangeNotifier.exchangeRate! *
                                            double.tryParse(createTransactionChangeNotifier.value)!)
                                        .toString() +
                                    ' ' +
                                    createTransactionChangeNotifier.defaultCurrency!),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  const Spacer(),
                  Button(
                    onPressed: () async {
                      String name = textEditingController.text.isNotEmpty ? textEditingController.text : 'transfer'.tr;
                      createTransactionChangeNotifier.setName(name);
                      try {
                        SpendingShareUser user = Provider.of(context, listen: false);
                        DocumentReference userReference = firestore.collection('users').doc(user.databaseId);

                        DocumentReference transferReference = await firestore.collection('transactions').add({
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

                        DocumentSnapshot toMemberSnapshot = await createTransactionChangeNotifier.to.keys.first.get();
                        List<dynamic> newToMemberTransactionReferenceList = toMemberSnapshot['transactions'];
                        newToMemberTransactionReferenceList.add(transferReference);
                        createTransactionChangeNotifier.to.keys.first
                            .set({'transactions': newToMemberTransactionReferenceList}, SetOptions(merge: true));

                        DocumentSnapshot fromMemberSnapshot = await createTransactionData.member!.get();
                        List<dynamic> newFromMemberTransactionReferenceList = fromMemberSnapshot['transactions'];
                        newFromMemberTransactionReferenceList.add(transferReference);
                        createTransactionData.member!.set({'transactions': newFromMemberTransactionReferenceList}, SetOptions(merge: true));

                        DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
                            await firestore.collection('groups').doc(createTransactionData.groupId).get();

                        List<dynamic> newTransactionReferenceList = groupSnapshot.data()!['transactions'];
                        newTransactionReferenceList.add(transferReference);

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
                              message: e.toString(), // TODO '${(e as dynamic).message}'.tr,
                            );
                          },
                        );
                      }
                    },
                    text: 'save_transfer'.tr,
                    buttonColor: createTransactionData.color,
                    key: const Key('save_transfer'),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SpendingShareBottomNavigationBar(
              key: const Key('bottom_navigation'),
              selectedIndex: 1,
              firestore: firestore,
              color: createTransactionData.color,
            ),
          ),
        ),
      ),
    );
  }
}
