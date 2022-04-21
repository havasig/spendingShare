import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/transactions/expense/equally_user_row.dart';
import 'package:spending_share/ui/widgets/tab_navigation.dart';

import '../../../models/member.dart';
import '../../../models/user.dart';
import '../../../utils/screen_util_helper.dart';
import '../../../utils/text_validator.dart';
import '../../groups/details/group_details_page.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';
import '../../helpers/member_item.dart';
import '../../helpers/on_future_build_error.dart';
import '../../widgets/button.dart';
import '../../widgets/circle_icon_button.dart';
import '../../widgets/dialogs/error_dialog.dart';
import '../../widgets/input_field.dart';
import '../../widgets/spending_share_appbar.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../widgets/spending_share_bottom_navigation_bar.dart';
import '../../widgets/tab.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    TextEditingController textEditingController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: SpendingShareAppBar(titleText: 'add_expense'.tr),
          body: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputField(
                        key: const Key('expense_name_field'),
                        focusNode: focusNode,
                        textEditingController: textEditingController,
                        hintText: 'expense_name'.tr,
                        labelText: 'expense_name'.tr,
                        prefixIcon: Icon(Icons.group_add, color: globals.colors[createTransactionChangeNotifier.color]!),
                        validator: TextValidator.validateIsNotEmpty,
                        labelColor: globals.colors[createTransactionChangeNotifier.color]!,
                        focusColor: globals.colors[createTransactionChangeNotifier.color]!,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: createTransactionChangeNotifier.member!.get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          var member = Member.fromDocument(snapshot.data!);
                          return Column(
                            children: [
                              CircleIconButton(
                                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                width: 20,
                                color: createTransactionChangeNotifier.color!,
                                icon: member.icon ?? createTransactionChangeNotifier.groupIcon!,
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
                          createTransactionChangeNotifier.value! + ' ' + createTransactionChangeNotifier.currency,
                          style: TextStyleConstants.value(createTransactionChangeNotifier.color),
                        ),
                        SizedBox(height: h(16)),
                        Row(
                          children: [
                            Text(createTransactionChangeNotifier.date.toString()),
                            Icon(
                              Icons.calendar_today,
                              color: globals.colors[createTransactionChangeNotifier.color],
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
                                  createTransactionChangeNotifier.defaultCurrency),
                            ],
                          ),
                          Text((createTransactionChangeNotifier.exchangeRate! * double.tryParse(createTransactionChangeNotifier.value!)!)
                                  .toString() +
                              ' ' +
                              createTransactionChangeNotifier.defaultCurrency),
                        ],
                      ),
                    ],
                  ),
                Button(
                  onPressed: () => showBarModalBottomSheet(
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(),
                  ),
                ),
                SizedBox(
                    height: h(300),
                    child: TabNavigation(color: createTransactionChangeNotifier.color!, tabs: [
                      SpendingShareTab(
                          'equally'.tr,
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: createTransactionChangeNotifier.allMembers.length,
                                itemBuilder: (context, index) {
                                  return EquallyUserRow(
                                    memberReference: createTransactionChangeNotifier.allMembers.elementAt(index),
                                    color: createTransactionChangeNotifier.color!,
                                  );
                                }),

                            /*
                            child: StreamBuilder<List<DocumentSnapshot>>(
                                stream: CombineLatestStream.list(
                                    createTransactionChangeNotifier.allMembers.map<Stream<DocumentSnapshot>>((member) => member.snapshots())),
                                builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                                  if (memberListSnapshot.hasData) {
                                    return Column(
                                        children: memberListSnapshot.data!.map((m) {
                                      var member = Member.fromDocument(m);
                                      return EquallyUserRow(member: m, color: createTransactionChangeNotifier.color!);
                                    }).toList());
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),

                             */

                            /*ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: createTransactionChangeNotifier.,
                                itemBuilder: (context, index) {
                                  return Text('asd');
                                }),

                               */
                          ),
                          onSelect: (context) => showBarModalBottomSheet(
                                expand: true,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(),
                              )),
                      SpendingShareTab('amounts'.tr, Text('asd')),
                      SpendingShareTab('weights'.tr, Text('asd')),
                    ])),
                const Spacer(),
                Button(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      createTransactionChangeNotifier.setName(textEditingController.text);
                      try {
                        SpendingShareUser user = Provider.of(context, listen: false);
                        DocumentReference userReference = firestore.collection('users').doc(user.databaseId);

                        await firestore.collection('transactions').add({
                          'createdBy': userReference,
                          'currency': createTransactionChangeNotifier.currency,
                          'date': createTransactionChangeNotifier.date,
                          'exchangeRate': createTransactionChangeNotifier.exchangeRate,
                          'from': 'fromTextEditingController.text',
                          'name': createTransactionChangeNotifier.name,
                          'to': createTransactionChangeNotifier.member,
                          'type': createTransactionChangeNotifier.type.toString(),
                          'value': double.parse(createTransactionChangeNotifier.value!),
                        });

                        var groupId = createTransactionChangeNotifier.groupId!;
                        createTransactionChangeNotifier.clear();

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
                              message: '${(e as dynamic).message}'.tr,
                            );
                          },
                        );
                      }
                    }
                  },
                  text: 'save_transfer'.tr,
                  buttonColor: globals.colors[createTransactionChangeNotifier.color]!,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SpendingShareBottomNavigationBar(
            selectedIndex: 1,
            firestore: firestore,
            color: createTransactionChangeNotifier.color!,
          ),
        );
      }),
    );
  }
}
