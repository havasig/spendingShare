import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/transactions/create_transaction_page.dart';

class CreateTransactionFab extends StatelessWidget {
  const CreateTransactionFab({Key? key, required this.firestore, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final GroupData groupData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        key: const Key('create_transaction'),
        tooltip: 'create_transaction',
        backgroundColor: groupData.color,
        splashColor: ColorConstants.lightGray,
        onPressed: () => Get.to(() => CreateTransactionPage(
              firestore: firestore,
              groupData: groupData,
            )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
