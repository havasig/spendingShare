import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../groups/create/create_group_page.dart';

class CreateGroupFab extends StatelessWidget {
  const CreateGroupFab({Key? key, required this.firestore, this.color}) : super(key: key);

  final FirebaseFirestore firestore;
  final MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        key: const Key('create_group'),
        tooltip: 'create_group',
        backgroundColor: color ?? globals.colors['default'],
        splashColor: ColorConstants.lightGray,
        onPressed: () => Get.to(() => CreateGroupPage(firestore: firestore)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
