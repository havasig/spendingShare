import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/spending_share_appbar.dart';

class AddIncome extends StatelessWidget {
  const AddIncome({Key? key, required this. firestore}) : super(key: key);

  final FirebaseFirestore firestore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(titleText: 'add_income'.tr),
      body: Column(
        children: [Text('add_income'.tr)],
      ),
    );
  }
}
