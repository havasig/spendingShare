import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/groups/create/select_currency.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/transactions/calculator.dart';
import 'package:spending_share/ui/transactions/expense/add_expense.dart';
import 'package:spending_share/ui/transactions/member_dropdown.dart';
import 'package:spending_share/ui/transactions/transaction_dropdown.dart';
import 'package:spending_share/ui/transactions/transfer/transfer_to.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import 'income/add_income.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key, required this.firestore, required this.color, required this.currency, required this.groupId})
      : super(key: key);

  final FirebaseFirestore firestore;
  final String color;
  final String currency;
  final String groupId;

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    CreateTransactionChangeNotifier _createTransactionChangeNotifier = CreateTransactionChangeNotifier(widget.currency);
    return ChangeNotifierProvider(
      create: (context) => _createTransactionChangeNotifier,
      child: Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SpendingShareAppBar(
                titleText: 'add_transaction'.tr,
                hasForward: true,
                forwardText: 'next'.tr,
                onForward: () {
                  switch (createTransactionChangeNotifier.type) {
                    case TransactionType.expense:
                      if (createTransactionChangeNotifier.isValidExpense()) Get.to(() => AddExpense(firestore: widget.firestore));
                      break;
                    case TransactionType.transfer:
                      if (createTransactionChangeNotifier.isValidTransfer()) Get.to(() => TransferTo(firestore: widget.firestore));
                      break;
                    case TransactionType.income:
                      if (createTransactionChangeNotifier.isValidIncome()) Get.to(() => AddIncome(firestore: widget.firestore));
                      break;
                  }
                }),
            body: Padding(
              padding: EdgeInsets.fromLTRB(h(16), 0, h(16), h(16)),
              child: Column(
                children: [
                  ChangeNotifierProvider(
                    create: (context) => _createTransactionChangeNotifier as CreateChangeNotifier,
                    child: SelectCurrency(currency: currentUser.currency, color: widget.color),
                  ),
                  CreateTransactionDropdown(
                    defaultValue: 'expense'.tr,
                    options: {
                      'expense'.tr: TransactionType.expense,
                      'transfer'.tr: TransactionType.transfer,
                      'income'.tr: TransactionType.income,
                    },
                    title: 'type'.tr,
                    color: widget.color,
                    onSelect: (value) {
                      _createTransactionChangeNotifier.setType(value);
                    },
                  ),
                  createTransactionChangeNotifier.type == TransactionType.expense
                      ? StreamBuilder<List<DocumentSnapshot>>(
                          stream: widget.firestore.collection('groups').doc(widget.groupId).snapshots().switchMap((group) {
                            return CombineLatestStream.list(group
                                .data()!['categories']
                                .map<Stream<DocumentSnapshot>>((category) => (category as DocumentReference).snapshots()));
                          }),
                          builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> categoryListSnapshot) {
                            if (categoryListSnapshot.hasData && categoryListSnapshot.data!.isNotEmpty) {
                              Map<String, dynamic> options = {};
                              for (var category in categoryListSnapshot.data!) {
                                category as DocumentSnapshot<Map<String, dynamic>>;
                                options.addAll({category.data()!['name']: category.reference});
                              }
                              _createTransactionChangeNotifier.setCategory(options.entries.first.value);
                              return CreateTransactionDropdown(
                                title: 'category'.tr,
                                options: options,
                                color: widget.color,
                                onSelect: (value) {
                                  _createTransactionChangeNotifier.setCategory(value);
                                },
                              );
                            } else if (!categoryListSnapshot.hasData) {
                              return Text('no_category_found'.tr);
                            } else {
                              return OnFutureBuildError(categoryListSnapshot);
                            }
                          })
                      : const SizedBox.shrink(),
                  createTransactionChangeNotifier.type == TransactionType.expense ||
                          createTransactionChangeNotifier.type == TransactionType.transfer
                      ? StreamBuilder<List<DocumentSnapshot>>(
                          stream: widget.firestore.collection('groups').doc(widget.groupId).snapshots().switchMap((group) {
                            return CombineLatestStream.list(group
                                .data()!['members']
                                .map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                          }),
                          builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                            if (memberListSnapshot.hasData && memberListSnapshot.data!.isNotEmpty) {
                              Map<String, dynamic> options = {};
                              for (var member in memberListSnapshot.data!) {
                                member as DocumentSnapshot<Map<String, dynamic>>;
                                options.addAll({member.data()!['name']: member.reference});
                              }
                              return TransactionMemberDropdown(
                                options: options,
                                color: widget.color,
                              );
                            } else if (memberListSnapshot.hasData && memberListSnapshot.data!.isEmpty) {
                              return Text('no_member_found'.tr);
                            } else {
                              return OnFutureBuildError(memberListSnapshot);
                            }
                          })
                      : const SizedBox.shrink(),
                  Row(
                    children: [
                      Text('date'.tr),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          var selectedDate = await showDatePicker(
                            context: context,
                            initialDate: createTransactionChangeNotifier.date,
                            firstDate: DateTime.now().add(const Duration(days: -365 * 5)),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: globals.colors[widget.color]!, // header text color
                                    onSurface: ColorConstants.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (selectedDate != null) createTransactionChangeNotifier.setDate(selectedDate);
                        },
                        child: Row(
                          children: [
                            Text(createTransactionChangeNotifier.date.toString()),
                            Icon(
                              Icons.calendar_today,
                              color: globals.colors[widget.color],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Calculator(color: widget.color),
                ],
              ),
            ),
            bottomNavigationBar: SpendingShareBottomNavigationBar(
              selectedIndex: 1,
              firestore: widget.firestore,
              color: widget.color,
            ),
          ),
        );
      }),
    );
  }
}
