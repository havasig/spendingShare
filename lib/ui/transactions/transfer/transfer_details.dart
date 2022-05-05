import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/data/group_data.dart';
import 'package:spending_share/models/transaction.dart' as spending_share_transaction;
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class TransferDetails extends StatelessWidget {
  const TransferDetails({Key? key, required this.firestore, required this.transfer, required this.groupData}) : super(key: key);

  final FirebaseFirestore firestore;
  final spending_share_transaction.Transaction transfer;
  final GroupData groupData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(
        titleText: 'transfer'.tr,
      ),
      body: Padding(
        padding: EdgeInsets.all(h(16)),
        child: SingleChildScrollView(
          child: Column(
            children: [Text('expense details copy paste add expense')],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        firestore: firestore,
        selectedIndex: 1,
        color: groupData.color,
      ),
    );
  }
}
