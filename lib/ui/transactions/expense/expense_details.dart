import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/create/select_currency.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/ui/transactions/expense/equally_user_row.dart';
import 'package:spending_share/ui/transactions/expense/weight_user_row.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/number_helper.dart';
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
import '../member_dropdown.dart';
import '../transaction_dropdown.dart';
import 'amount_user_row.dart';

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({Key? key, required this.firestore, required this.expense, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final spending_share_transaction.Transaction expense;
  final GroupData groupData;

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  @override
  void initState() {
    super.initState();

    CreateTransactionData createTransactionData = Provider.of(context, listen: false);
    createTransactionData.setAllMembers(List<DocumentReference>.from(widget.expense.to));
    createTransactionData.setMember(widget.expense.from!);
    createTransactionData.setCategory(widget.expense.category!);
    createTransactionData.setColor(widget.groupData.color);

    CreateTransactionChangeNotifier createTransactionChangeNotifier = Provider.of(context, listen: false);

    createTransactionChangeNotifier.setDate(DateTime.fromMicrosecondsSinceEpoch(widget.expense.date.microsecondsSinceEpoch));
    createTransactionChangeNotifier.setValueNoNotify(widget.expense.value.toString());
    createTransactionChangeNotifier.setCurrencyNoNotify(widget.expense.currency);
    createTransactionChangeNotifier.setDefaultCurrency(widget.groupData.currency!);
    createTransactionChangeNotifier.setName(widget.expense.name);
    if (widget.expense.exchangeRate != null) {
      createTransactionChangeNotifier.setExchangeRate(double.tryParse(widget.expense.exchangeRate!));
    }
    Map<DocumentReference, Tuple2<String, String>> map = {};
    for (int i = 0; i < widget.expense.to.length; i++) {
      map[widget.expense.to[i]] = Tuple2(widget.expense.toAmounts![i], widget.expense.toWeights![i]);
    }
    createTransactionChangeNotifier.setTo(map);

    textEditingController.text = createTransactionChangeNotifier.name!;
  }

  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  DocumentReference? oldCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<CreateTransactionData>(
        builder: (_, createTransactionData, __) => Consumer<CreateTransactionChangeNotifier>(
          builder: (_, createTransactionChangeNotifier, __) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: SpendingShareAppBar(
              titleText: 'add_expense'.tr,
              onBack: () {
                createTransactionChangeNotifier.clear();
                createTransactionData.clear();
                Get.back();
              },
            ),
            body: Padding(
              padding: EdgeInsets.all(h(16)),
              child: Column(
                children: [
                  Column(
                    children: [
                      InputField(
                        key: const Key('expense_name_field'),
                        focusNode: focusNode,
                        textEditingController: textEditingController,
                        hintText: 'expense_name'.tr,
                        labelText: 'expense_name'.tr,
                        prefixIcon: Icon(Icons.group_add, color: widget.groupData.color),
                        validator: TextValidator.validateIsNotEmpty,
                        labelColor: widget.groupData.color.shade500,
                        focusColor: widget.groupData.color.shade500,
                      ),
                    ],
                  ),
                  SizedBox(height: h(16)),
                  GestureDetector(
                    onTap: () => showBarModalBottomSheet(
                      expand: true,
                      context: context,
                      builder: (context) {
                        return Consumer<CreateTransactionChangeNotifier>(
                          builder: (_, createTransactionChangeNotifier, __) => Container(
                            color: ColorConstants.backgroundBlack,
                            padding: EdgeInsets.all(h(16)),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(h(16), 0, h(16), h(16)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ChangeNotifierProvider(
                                    create: (context) => createTransactionChangeNotifier as CreateChangeNotifier,
                                    child: SelectCurrency(currency: widget.groupData.currency!, color: widget.groupData.color),
                                  ),
                                  StreamBuilder<List<DocumentSnapshot>>(
                                      stream: widget.firestore
                                          .collection('groups')
                                          .doc(widget.groupData.groupId)
                                          .snapshots()
                                          .switchMap((group) {
                                        createTransactionData
                                            .setGroupIcon(globals.icons[group.data()!['icon']] ?? globals.icons['default']!);
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
                                          createTransactionData.category == null
                                              ? createTransactionData.setCategory(options.entries.first.value)
                                              : null;
                                          return CreateTransactionDropdown(
                                            title: 'category'.tr,
                                            options: options,
                                            color: widget.groupData.color,
                                            onSelect: (value) {
                                              createTransactionData.setCategory(value);
                                            },
                                          );
                                        } else if (!categoryListSnapshot.hasData) {
                                          return Text('no_category_found'.tr);
                                        } else {
                                          return OnFutureBuildError(categoryListSnapshot);
                                        }
                                      }),
                                  StreamBuilder<List<DocumentSnapshot>>(
                                      stream: widget.firestore
                                          .collection('groups')
                                          .doc(widget.groupData.groupId)
                                          .snapshots()
                                          .switchMap((group) {
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
                                            color: widget.groupData.color,
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
                                  createTransactionChangeNotifier.value.isNotEmpty &&
                                          double.tryParse(createTransactionChangeNotifier.value) != null
                                      ? Text(
                                          formatNumberString(createTransactionChangeNotifier.value) +
                                              ' ' +
                                              createTransactionChangeNotifier.currency,
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
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    child: Row(
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
                                    width: 20,
                                    color: widget.groupData.color,
                                    icon: member.icon ?? widget.groupData.icon,
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
                              style: TextStyleConstants.value(widget.groupData.color),
                            ),
                            SizedBox(height: h(16)),
                            Row(
                              children: [
                                TextFormat.date(createTransactionChangeNotifier.date),
                                Icon(
                                  Icons.calendar_today,
                                  color: widget.groupData.color.shade500,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
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
                  SizedBox(
                      height: h(300),
                      child: TabNavigation(color: widget.groupData.color, tabs: [
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
                      ])),
                  const Spacer(),
                  Button(
                    onPressed: () async {
                      String name = textEditingController.text.isNotEmpty ? textEditingController.text : 'expense'.tr;
                      createTransactionChangeNotifier.setName(name);
                      try {
                        SpendingShareUser user = Provider.of(context, listen: false);
                        DocumentReference userReference = widget.firestore.collection('users').doc(user.databaseId);

                        //Remove transaction from old members if removed
                        Iterable<dynamic> removedMembers =
                            createTransactionChangeNotifier.to.entries.where((element) => element.value.item1 == '0');
                        createTransactionChangeNotifier.to.removeWhere((key, value) => value.item1 == '0');
                        removedMembers.forEach((element) async {
                          element as MapEntry<DocumentReference, Tuple2<String, String>>;
                          DocumentSnapshot memberSnapshot = await element.key.get();
                          List<dynamic> newMemberTransactionReferenceList = memberSnapshot['transactions'];
                          newMemberTransactionReferenceList.removeWhere((e) => e.id == widget.expense.databaseId);
                          element.key.set({'transactions': newMemberTransactionReferenceList}, SetOptions(merge: true));
                        });

                        //Update expense data
                        await widget.firestore.collection('transactions').doc(widget.expense.databaseId).set({
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
                        }, SetOptions(merge: true));

                        //set members' transaction if not set yet
                        DocumentReference expenseReference = widget.firestore.collection('transactions').doc(widget.expense.databaseId);
                        for (DocumentReference toItem in createTransactionChangeNotifier.to.keys.toList()) {
                          DocumentSnapshot memberSnapshot = await toItem.get();
                          if (!memberSnapshot['transactions'].contains(expenseReference)) {
                            List<dynamic> newMemberTransactionReferenceList = memberSnapshot['transactions'];
                            newMemberTransactionReferenceList.add(expenseReference);
                            toItem.set({'transactions': newMemberTransactionReferenceList}, SetOptions(merge: true));
                          }
                        }

                        if (oldCategory != null) {
                          //Set expense in new category
                          DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
                              await widget.firestore.collection('categories').doc(createTransactionData.category?.id).get();
                          List<dynamic> newExpenseReferenceList = categorySnapshot.data()!['transactions'];
                          newExpenseReferenceList.add(expenseReference);
                          await widget.firestore
                              .collection('categories')
                              .doc(createTransactionData.category?.id)
                              .set({'transactions': newExpenseReferenceList}, SetOptions(merge: true));

                          //Remove expense from old cateogry
                          DocumentSnapshot<Map<String, dynamic>> oldCategorySnapshot =
                              await widget.firestore.collection('categories').doc(oldCategory!.id).get();
                          List<dynamic> oldExpenseReferenceList = oldCategorySnapshot.data()!['transactions'];
                          oldExpenseReferenceList.remove(expenseReference);
                          await widget.firestore
                              .collection('categories')
                              .doc(oldCategory!.id)
                              .set({'transactions': oldExpenseReferenceList}, SetOptions(merge: true));
                        }

                        createTransactionData.clear();
                        createTransactionChangeNotifier.clear();

                        Get.to(() => GroupDetailsPage(
                              firestore: widget.firestore,
                              hasBack: false,
                              groupId: widget.groupData.groupId,
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
                              color: widget.groupData.color,
                            );
                          },
                        );
                      }
                    },
                    text: 'save_expense'.tr,
                    buttonColor: widget.groupData.color.shade500,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SpendingShareBottomNavigationBar(
              selectedIndex: 1,
              firestore: widget.firestore,
              color: widget.groupData.color,
            ),
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
