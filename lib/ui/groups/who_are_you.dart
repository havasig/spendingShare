import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/helpers/user_item.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/ui/widgets/create_group_fab.dart';
import 'package:spending_share/ui/widgets/dialogs/error_dialog.dart';
import 'package:spending_share/ui/widgets/dialogs/user_is_taken_dialog.dart';
import 'package:spending_share/ui/widgets/input_field.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import 'group_details_page.dart';

class WhoAreYou extends StatelessWidget {
  const WhoAreYou({Key? key, required this.firestore, required this.group}) : super(key: key);

  final Stream<DocumentSnapshot<Map<String, dynamic>>> group;
  final FirebaseFirestore firestore;

  CollectionReference get users => firestore.collection('users');

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SpendingShareAppBar(
        titleText: 'who-are-you'.tr,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: group,
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text('empty view');
                      } else {
                        List<dynamic> memberDocumentReferences = snapshot.data?.get('members');
                        return Column(
                            children: memberDocumentReferences.map((m) {
                          DocumentReference member = m;
                          return FutureBuilder(
                            future: member.get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                var b = User.fromDocument(snapshot.data! as DocumentSnapshot);
                                return UserItem(user: b);
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ); //UserItem(user: user);
                        }).toList());
                      }
                    }),

                /*ListView.builder(
                  itemCount: group.memberIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: users.doc(group.memberIds[index]).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          User user = User.fromDocument(snapshot.data!);
                          return UserItem(user: user);
                        }

                        return Text("loading");
                      },
                    );
                  },
                ),*/
              ),
              const Spacer(),
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
                onPressed: () {
                  Get.to(() => GroupDetailsPage(firestore: firestore));
                },
                text: 'join'.tr,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        key: const Key('bottom_navigation'),
        selectedIndex: 1,
        firestore: firestore,
      ),
    );
  }
}
