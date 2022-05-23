import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/create/select_color.dart';
import 'package:spending_share/ui/groups/create/select_currency.dart';
import 'package:spending_share/ui/groups/create/select_icon.dart';
import 'package:spending_share/ui/groups/details/group_details_page.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/config/environment.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';
import 'package:spending_share/utils/text_validator.dart';

class GroupEditPage extends StatefulWidget {
  const GroupEditPage({Key? key, required this.firestore, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;

  @override
  State<GroupEditPage> createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  final FocusNode _groupNameFocusNode = FocusNode();
  late final TextEditingController _groupNameTextEditingController;
  final _formKey = GlobalKey<FormState>(debugLabel: '_EditGroupFormState');

  @override
  void initState() {
    super.initState();
    _groupNameTextEditingController = TextEditingController(text: widget.groupData.name);
  }

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    CreateGroupChangeNotifier _createGroupChangeNotifier = Provider.of(context, listen: false);
    _createGroupChangeNotifier.init(
        GroupData(
          groupId: '',
          currency: widget.groupData.currency,
          icon: widget.groupData.icon,
          color: widget.groupData.color,
        ),
        currentUser.name,
        currentUser.userFirebaseId);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<CreateGroupChangeNotifier>(
        builder: (_, createGroupChangeNotifier, __) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: SpendingShareAppBar(titleText: 'create_group'.tr),
          body: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(
              children: [
                SizedBox(height: h(6)),
                Form(
                  key: _formKey,
                  child: InputField(
                    validator: TextValidator.validateGroupNameText,
                    key: const Key('group_name_input'),
                    focusNode: _groupNameFocusNode,
                    textEditingController: _groupNameTextEditingController,
                    labelText: 'name'.tr,
                    hintText: 'group_name'.tr,
                    prefixIcon: Icon(Icons.group, color: createGroupChangeNotifier.color),
                    labelColor: createGroupChangeNotifier.color!,
                    focusColor: createGroupChangeNotifier.color!,
                  ),
                ),
                ChangeNotifierProvider.value(
                  value: createGroupChangeNotifier as CreateChangeNotifier,
                  child: SelectCurrency(currency: createGroupChangeNotifier.currency),
                ),
                SelectColor(defaultColor: createGroupChangeNotifier.color!),
                SelectIcon(defaultIcon: createGroupChangeNotifier.icon),
                const Spacer(),
                Button(
                  buttonColor: createGroupChangeNotifier.color!,
                  onPressed: () async {
                    createGroupChangeNotifier.setName(_groupNameTextEditingController.text);
                    if (_formKey.currentState!.validate() && createGroupChangeNotifier.validateFirstPage()) {
                      try {
                        widget.firestore.collection('groups').doc(widget.groupData.groupId).set({
                          'name': createGroupChangeNotifier.name,
                          'color': globals.colors.entries.firstWhere((element) => element.value == createGroupChangeNotifier.color).key,
                          'icon': globals.icons.entries.firstWhere((element) => element.value == createGroupChangeNotifier.icon).key,
                          'currency': createGroupChangeNotifier.currency,
                        }, SetOptions(merge: true));

                        if (createGroupChangeNotifier.currency != widget.groupData.currency) {
                          DocumentSnapshot groupSnapshot = await widget.firestore.collection('groups').doc(widget.groupData.groupId).get();
                          double? defaultExchangeRate =
                              await getExchangeRate(createGroupChangeNotifier.currency, widget.groupData.currency!);
                          for (DocumentReference t in groupSnapshot['transactions']) {
                            spending_share_transaction.Transaction transaction =
                                spending_share_transaction.Transaction.fromDocument(await t.get());
                            if (transaction.currency == createGroupChangeNotifier.currency) {
                              // eddig az a valuta volt, amire változott
                              t.set({'exchangeRate': null}, SetOptions(merge: true));
                            } else if (transaction.currency == widget.groupData.currency) {
                              // eddig default valuta volt
                              t.set({'exchangeRate': defaultExchangeRate}, SetOptions(merge: true));
                            } else {
                              //valami más volt eddig is a valuta, arról kell kiszámolni az exchange rate-t
                              double? newExchangeRate = await getExchangeRate(createGroupChangeNotifier.currency, transaction.currency);
                              t.set({'exchangeRate': newExchangeRate}, SetOptions(merge: true));
                            }
                          }
                        }

                        // TODO change debts to this currency lol

                        Get.offAll(() => GroupDetailsPage(firestore: widget.firestore, hasBack: false, groupId: widget.groupData.groupId));
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ErrorDialog(
                              title: 'group_edit_failed'.tr,
                              message: '${(e as dynamic).message}'.tr,
                            );
                          },
                        );
                      }
                    }
                  },
                  text: 'save_changes'.tr,
                ),
              ],
            ),
          ),
          bottomNavigationBar: SpendingShareBottomNavigationBar(
            selectedIndex: 1,
            firestore: widget.firestore,
            color: createGroupChangeNotifier.color,
          ),
        ),
      ),
    );
  }

  Future<double?> getExchangeRate(String to, String from) async {
    double? result;
    if (from == to) {
      return null;
    }
    try {
      String uri = '${Environment().config.currencyConverterbaseUrl}/currency/convert'
          '?api_key=${Environment().config.currencyConverterApiKey}'
          '&from=$from'
          '&to=$to'
          '&amount=1'
          '&format=json';
      var response = await http.get(Uri.parse(uri));
      Map<String, dynamic> map = json.decode(response.body);
      result = double.tryParse(map['rates'][to]['rate'])!;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return result;
  }
}
