import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';

class TransferTo extends StatelessWidget {
  const TransferTo({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'transfer_to'.tr),
      body: Column(
        children: [Text('transfer_to'.tr)],
      ),
    );
  }
}
