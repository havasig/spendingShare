import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/enums/transaction_type.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/helpers/on_future_build_error.dart';
import 'package:spending_share/ui/widgets/circle_icon_button.dart';
import 'package:spending_share/ui/widgets/dialogs/are_you_sure_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';

import '../group_details_page.dart';

class DebtItem extends StatelessWidget {
  const DebtItem({
    Key? key,
    required this.firestore,
    required this.from,
    required this.to,
    required this.value,
    required this.currency,
    required this.color,
    required this.icon,
    required this.groupId,
    required this.debtId,
  }) : super(key: key);

  final FirebaseFirestore firestore;
  final DocumentReference from;
  final DocumentReference to;
  final double value;
  final String currency;
  final MaterialColor color;
  final IconData icon;
  final String groupId;
  final String debtId;

  @override
  Widget build(BuildContext context) {
    String? fromName;
    String? toName;
    return GestureDetector(
      onTap: () {
        if (fromName != null && toName != null) {
          showDialog(
              context: context,
              builder: (context) {
                return AreYouSureDialog(
                  title: 'settle_debt'.tr,
                  message: 'do_you_want_to_settle_debt'.tr +
                      value.toString() +
                      ' ' +
                      currency +
                      ' ' +
                      'from'.tr +
                      fromName! +
                      ' ' +
                      'to'.tr +
                      toName!,
                  okText: 'settle_debt'.tr,
                  cancelText: 'cancel'.tr,
                  color: color,
                );
              }).then((result) async {
            if (result != null && result) {
              try {
                SpendingShareUser user = Provider.of(context, listen: false);
                DocumentReference userReference = firestore.collection('users').doc(user.databaseId);

                //create new transfer
                DocumentReference transferReference = await firestore.collection('transactions').add({
                  'createdBy': userReference,
                  'currency': currency,
                  'date': DateTime.now(),
                  'from': from,
                  'name': 'settle_debt'.tr,
                  'to': [to],
                  'toAmounts': [value.toString()],
                  'toWeights': ['1'],
                  'type': TransactionType.transfer.toString(),
                  'value': value,
                });

                //set to member transaction references
                DocumentSnapshot toMemberSnapshot = await to.get();
                List<dynamic> newToMemberTransactionReferenceList = toMemberSnapshot['transactions'];
                newToMemberTransactionReferenceList.add(transferReference);
                to.set({'transactions': newToMemberTransactionReferenceList}, SetOptions(merge: true));

                //set from member transaction references
                DocumentSnapshot fromMemberSnapshot = await from.get();
                List<dynamic> newFromMemberTransactionReferenceList = fromMemberSnapshot['transactions'];
                newFromMemberTransactionReferenceList.add(transferReference);
                from.set({'transactions': newFromMemberTransactionReferenceList}, SetOptions(merge: true));

                //set group transaction references
                DocumentSnapshot<Map<String, dynamic>> groupSnapshot = await firestore.collection('groups').doc(groupId).get();
                List<dynamic> newDebtReferenceList = groupSnapshot.data()!['debts'];
                newDebtReferenceList.removeWhere((element) => element.id == debtId);

                List<dynamic> newTransactionReferenceList = groupSnapshot.data()!['transactions'];
                newTransactionReferenceList.add(transferReference);
                await firestore.collection('groups').doc(groupId).set({
                  'transactions': newTransactionReferenceList,
                  'debts': newDebtReferenceList,
                }, SetOptions(merge: true));

                //delete old debt
                await firestore.collection('debts').doc(debtId).delete();

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
                      title: 'settle_debt_failed'.tr,
                      message: '${(e as dynamic).message}'.tr,
                    );
                  },
                );
              }
            }
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: from.get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var member = Member.fromDocument(snapshot.data!);
                fromName = member.name;
                return Row(
                  children: [
                    CircleIconButton(
                      width: 20,
                      color: color,
                      icon: member.icon ?? icon,
                    ),
                    Column(
                      children: [
                        Text(member.name),
                        TextFormat.roundedValueWithCurrencyAndColor(value, currency, color),
                      ],
                    )
                  ],
                );
              }
              return OnFutureBuildError(snapshot);
            },
          ),
          const Icon(Icons.arrow_forward_outlined),
          FutureBuilder<DocumentSnapshot>(
            future: to.get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var member = Member.fromDocument(snapshot.data!);
                toName = member.name;
                return Row(
                  children: [
                    Text(member.name),
                    CircleIconButton(
                      width: 20,
                      color: color,
                      icon: member.icon ?? icon,
                    ),
                  ],
                );
              }
              return OnFutureBuildError(snapshot);
            },
          ),
        ],
      ),
    );
  }
}
