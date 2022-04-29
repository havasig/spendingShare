import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/join/join_group_input_and_buttons.dart';
import 'package:spending_share/ui/helpers/fab/create_group_fab.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class JoinPage extends StatefulWidget {
  JoinPage({Key? key, required this.firestore, required this.color}) : super(key: key);

  final FirebaseFirestore firestore;
  final MaterialColor color;

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SpendingShareAppBar(titleText: 'join_group'.tr),
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(h(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'no_groups'.tr,
                      style: TextStyleConstants.body_2_medium,
                    ),
                    SizedBox(height: h(8)),
                    Text(
                      'paste_code_here'.tr,
                      style: TextStyleConstants.sub_1,
                    ),
                    SizedBox(height: h(16)),
                    JoinGroupInputAndButtons(firestore: widget.firestore, color: widget.color),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: CreateGroupFab(firestore: widget.firestore, color: widget.color),
        bottomNavigationBar: SpendingShareBottomNavigationBar(
          key: const Key('bottom_navigation'),
          selectedIndex: 1,
          firestore: widget.firestore,
          color: widget.color,
        ),
      ),
    );
  }
}
