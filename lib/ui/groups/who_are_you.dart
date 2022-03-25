import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/create_group_fab.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class WhoAreYou extends StatelessWidget {
  const WhoAreYou({Key? key, required this.firestore, required this.group}) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> group;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        titleText: 'my-groups'.tr,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO list memebers

                      Text(
                        'none-of-these'.tr,
                        style: TextStyleConstants.sub_1,
                      ),
                      SizedBox(height: h(16)),
                      InputField(
                        key: const Key('join_input_field'),
                        focusNode: focusNode,
                        hintText: 'join'.tr,
                        labelText: 'join'.tr,
                        prefixIcon: const Icon(
                          Icons.group_add,
                          color: ColorConstants.defaultOrange,
                        ),
                      ),
                      SizedBox(height: h(16)),
                      Button(
                        key: const Key('join_button'),
                        onPressed: () {},
                        text: 'join'.tr,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const CreateGroupFab(),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }
}
