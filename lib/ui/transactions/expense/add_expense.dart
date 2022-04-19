import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/spending_share_appbar.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({Key? key, required this. firestore}) : super(key: key);

  final FirebaseFirestore firestore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'add_expense'.tr),
      body: Column(
        children: [Text('add_expense'.tr)],
      ),
    );
  }
}
