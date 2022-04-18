import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../create/create_group_page.dart';

class AddTransactionFab extends StatelessWidget {
  const AddTransactionFab({Key? key, required this.firestore, required this.color}) : super(key: key);

  final FirebaseFirestore firestore;
  final String color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        key: const Key('add_transaction'),
        tooltip: 'add_transaction',
        backgroundColor: globals.colors[color],
        splashColor: ColorConstants.lightGray,
        onPressed: () => Get.to(() => CreateGroupPage(firestore: firestore)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
