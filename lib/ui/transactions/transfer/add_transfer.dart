import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
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
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

import '../../constants/text_style_constants.dart';
import '../../helpers/on_future_build_error.dart';

class AddTransfer extends StatelessWidget {
  const AddTransfer({Key? key, required this.firestore}) : super(key: key);

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
          appBar: SpendingShareAppBar(
            titleText: 'add_transfer'.tr,
          ),
          body: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Form(
                  key: _formKey,
                  child: InputField(
                    key: const Key('transfer_name_field'),
                    focusNode: focusNode,
                    textEditingController: textEditingController,
                    hintText: 'transfer_name'.tr,
                    labelText: 'name'.tr,
                    prefixIcon: Icon(Icons.group_add, color: globals.colors[createTransactionChangeNotifier.color]!),
                    validator: TextValidator.validateIsNotEmpty,
                    labelColor: globals.colors[createTransactionChangeNotifier.color]!,
                    focusColor: globals.colors[createTransactionChangeNotifier.color]!,
                  ),
                ),
                SizedBox(height: h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('transfer_from'.tr),
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
                                    color: createTransactionChangeNotifier.color!,
                                    icon: member.icon ?? createTransactionChangeNotifier.groupIcon!,
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
                  style: TextStyleConstants.value(createTransactionChangeNotifier.color),
                ),
                SizedBox(height: h(16)),
                Row(
                  children: [
                    const Spacer(),
                    Text(createTransactionChangeNotifier.date.toString()),
                    Icon(
                      Icons.calendar_today,
                      color: globals.colors[createTransactionChangeNotifier.color],
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
                              Text((createTransactionChangeNotifier.exchangeRate! * double.tryParse(createTransactionChangeNotifier.value)!)
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
                    if (_formKey.currentState!.validate()) {
                      createTransactionChangeNotifier.setName(textEditingController.text);
                      //try {
                        SpendingShareUser user = Provider.of(context, listen: false);
                        DocumentReference userReference = firestore.collection('users').doc(user.databaseId);

                        DocumentReference transferReference = await firestore.collection('transactions').add({
                          'createdBy': userReference,
                          'currency': createTransactionChangeNotifier.currency,
                          'date': createTransactionChangeNotifier.date,
                          'exchangeRate': createTransactionChangeNotifier.exchangeRate,
                          'from': createTransactionChangeNotifier.member,
                          'name': createTransactionChangeNotifier.name,
                          'to': createTransactionChangeNotifier.to.keys.toList(),
                          'toValues': createTransactionChangeNotifier.to.values.toList(),
                          'type': createTransactionChangeNotifier.type.toString(),
                          'value': double.parse(createTransactionChangeNotifier.value),
                        });

                        DocumentSnapshot<Map<String, dynamic>> groupSnapshot =
                            await firestore.collection('groups').doc(createTransactionChangeNotifier.groupId).get();

                        List<dynamic> newTransactionReferenceList = groupSnapshot.data()!['transactions'];
                        newTransactionReferenceList.add(transferReference);

                        await firestore
                            .collection('groups')
                            .doc(createTransactionChangeNotifier.groupId)
                            .set({'transactions': newTransactionReferenceList}, SetOptions(merge: true));

                        var groupId = createTransactionChangeNotifier.groupId!;
                        createTransactionChangeNotifier.clear();

                        Get.to(() => GroupDetailsPage(
                              firestore: firestore,
                              hasBack: false,
                              groupId: groupId,
                            ));
                      /*} catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorDialog(
                              title: 'transaction_creation_failed'.tr, message: e.toString(), // TODO '${(e as dynamic).message}'.tr,
                            );
                          },
                        );
                      }*/
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
