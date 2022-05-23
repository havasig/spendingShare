import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/category.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
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

import '../../utils/number_helper.dart';
import 'income/add_income.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key, required this.firestore, required this.groupData, this.category, this.member}) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;
  final Member? member;
  final Category? category;

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var createTransactionData = Provider.of<CreateTransactionData>(context, listen: false);
      createTransactionData.setGroupId(widget.groupData.groupId);
      createTransactionData.setColor(widget.groupData.color);

      var createTransactionChangeNotifier = Provider.of<CreateTransactionChangeNotifier>(context, listen: false);
      createTransactionChangeNotifier.setCurrency(widget.groupData.currency);
      createTransactionChangeNotifier.setDefaultCurrency(widget.groupData.currency!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTransactionData>(builder: (_, createTransactionData, __) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: SpendingShareAppBar(
            titleText: 'add_transaction'.tr,
            hasForward: true,
            onBack: () {
              CreateTransactionChangeNotifier createTransactionChangeNotifier =
                  Provider.of<CreateTransactionChangeNotifier>(context, listen: false);
              createTransactionChangeNotifier.clear();
              CreateTransactionData createTransactionData = Provider.of<CreateTransactionData>(context, listen: false);
              createTransactionData.clear();
              Get.back();
            },
            forwardText: 'next'.tr,
            onForward: () async {
              CreateTransactionChangeNotifier createTransactionChangeNotifier =
                  Provider.of<CreateTransactionChangeNotifier>(context, listen: false);
              createTransactionChangeNotifier.setColorNoNotify(widget.groupData.color);

              String? validate = createTransactionData.validateMember();
              if (validate != null) {
                createTransactionChangeNotifier.setValue(validate);
                return;
              }

              switch (createTransactionChangeNotifier.type) {
                case TransactionType.expense:
                  String? validate = createTransactionData.validateCategory();
                  if (validate != null) {
                    createTransactionChangeNotifier.setValue(validate);
                    return;
                  }
                  if (createTransactionChangeNotifier.isValidExpense()) {
                    var group = await widget.firestore.collection('groups').doc(createTransactionData.groupId).get();
                    createTransactionData.clearAllMembers();
                    createTransactionChangeNotifier.clearTo();
                    createTransactionChangeNotifier.clearEditedAmount();
                    String valuePerMember =
                        (double.parse(createTransactionChangeNotifier.value) / group.data()!['members'].length).toString();
                    for (var member in group.data()!['members']) {
                      createTransactionData.addToAllMembers(member);
                      createTransactionChangeNotifier.addTo(member, valuePerMember);
                    }
                    Get.to(() => AddExpense(firestore: widget.firestore));
                  }
                  break;
                case TransactionType.transfer:
                  if (createTransactionChangeNotifier.isValidTransfer()) Get.to(() => TransferTo(firestore: widget.firestore));
                  break;
                case TransactionType.income:
                  if (createTransactionChangeNotifier.isValidIncome()) {
                    Get.to(() => AddIncome(firestore: widget.firestore));
                  }
                  break;
              }
            },
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(h(16), 0, h(16), h(16)),
            child: Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ChangeNotifierProvider.value(
                    value: createTransactionChangeNotifier as CreateChangeNotifier,
                    child: SelectCurrency(currency: widget.groupData.currency!, color: widget.groupData.color),
                  ),
                  CreateTransactionDropdown(
                    defaultValue: 'expense'.tr,
                    options: {
                      'expense'.tr: TransactionType.expense,
                      'transfer'.tr: TransactionType.transfer,
                      'income'.tr: TransactionType.income,
                    },
                    title: 'type'.tr,
                    color: widget.groupData.color,
                    onSelect: (value) {
                      createTransactionChangeNotifier.setType(value);
                    },
                  ),
                  createTransactionChangeNotifier.type == TransactionType.expense
                      ? StreamBuilder<List<DocumentSnapshot>>(
                          stream: widget.firestore.collection('groups').doc(widget.groupData.groupId).snapshots().switchMap((group) {
                            createTransactionData.setGroupIcon(globals.icons[group.data()!['icon']] ?? globals.icons['default']!);
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
                              if (widget.category != null && options.keys.contains(widget.category!.name)) {
                                createTransactionData
                                    .setCategory(options.entries.where((element) => element.key == widget.category!.name).first.value);
                              }
                              if (createTransactionData.category == null) createTransactionData.setCategory(options.entries.first.value);

                              return CreateTransactionDropdown(
                                title: 'category'.tr,
                                options: options,
                                color: widget.groupData.color,
                                defaultValue: widget.category?.name,
                                onSelect: (value) {
                                  createTransactionData.setCategory(value);
                                },
                              );
                            } else if (!categoryListSnapshot.hasData) {
                              return Text('no_category_found'.tr);
                            } else {
                              return OnFutureBuildError(categoryListSnapshot);
                            }
                          })
                      : const SizedBox.shrink(),
                  StreamBuilder<List<DocumentSnapshot>>(
                      stream: widget.firestore.collection('groups').doc(widget.groupData.groupId).snapshots().switchMap((group) {
                        return CombineLatestStream.list(
                            group.data()!['members'].map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                      }),
                      builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                        if (memberListSnapshot.hasData && memberListSnapshot.data!.isNotEmpty) {
                          Map<String, dynamic> options = {};
                          for (var member in memberListSnapshot.data!) {
                            member as DocumentSnapshot<Map<String, dynamic>>;
                            options.addAll({member.data()!['name']: member.reference});
                          }

                          if (widget.member != null && options.keys.contains(widget.member!.name)) {
                            createTransactionData
                                .setMember(options.entries.where((element) => element.key == widget.member!.name).first.value);
                          }
                          if (createTransactionData.member == null) createTransactionData.setMember(options.entries.first.value);

                          return TransactionMemberDropdown(
                            options: options,
                            color: widget.groupData.color,
                            defaultValue: widget.member?.name,
                          );
                        } else if (memberListSnapshot.hasData && memberListSnapshot.data!.isEmpty) {
                          return Text('no_member_found'.tr);
                        } else {
                          return OnFutureBuildError(memberListSnapshot);
                        }
                      }),
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
                                    primary: widget.groupData.color, // header text color
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
                            TextFormat.date(createTransactionChangeNotifier.date),
                            Icon(
                              Icons.calendar_today,
                              color: widget.groupData.color,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h(10)),
                  createTransactionChangeNotifier.value.isNotEmpty && double.tryParse(createTransactionChangeNotifier.value) != null
                      ? Text(
                          formatNumberString(createTransactionChangeNotifier.value) + ' ' + createTransactionChangeNotifier.currency,
                          style: TextStyleConstants.value(widget.groupData.color).copyWith(fontSize: 30),
                        )
                      : Text(
                          createTransactionChangeNotifier.value,
                          style: TextStyleConstants.value(widget.groupData.color).copyWith(fontSize: 30),
                        ),
                  const Spacer(),
                  Calculator(
                    color: widget.groupData.color,
                    onEqualPressed: (double userInput) {
                      createTransactionChangeNotifier.setValue(formatNumberString(userInput.toString()));
                    },
                  ),
                ],
              );
            }),
          ),
          bottomNavigationBar: SpendingShareBottomNavigationBar(
            selectedIndex: 1,
            firestore: widget.firestore,
            color: widget.groupData.color,
          ),
        ),
      );
    });
  }
}
