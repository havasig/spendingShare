import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/transactions/create_transaction_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class CreateTransactionFab extends StatelessWidget {
  const CreateTransactionFab({Key? key, required this.firestore, required this.color, required this.currency, required this.groupId})
      : super(key: key);

  final FirebaseFirestore firestore;
  final String color;
  final String currency;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        key: const Key('create_transaction'),
        tooltip: 'create_transaction',
        backgroundColor: globals.colors[color],
        splashColor: ColorConstants.lightGray,
        onPressed: () => Get.to(() => CreateTransactionPage(
              firestore: firestore,
              color: color,
              currency: currency,
              groupId: groupId,
            )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
