import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MemberDetailsPage extends StatelessWidget {
  const MemberDetailsPage({Key? key, required this.firestore, required this.color}) : super(key: key);

  final MaterialColor color;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(
        titleText: 'who_are_you'.tr,
        suffixWidget: Text('del'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('TODO whole page rip'), // TODO member details page
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
        color: color,
      ),
    );
  }
}
