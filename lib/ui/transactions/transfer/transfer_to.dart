import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/ui/transactions/transfer/add_transfer.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/ui/helpers/member_item.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import '../../../models/user.dart';
import '../../helpers/change_notifiers/transaction_change_notifier.dart';

class TransferTo extends StatelessWidget {
  const TransferTo({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    return Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
      return Scaffold(
        appBar: SpendingShareAppBar(titleText: 'transfer_to'.tr),
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: Column(children: [
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: firestore.collection('groups').doc(createTransactionChangeNotifier.groupId).snapshots().switchMap((group) {
                    return CombineLatestStream.list(
                        group.data()!['members'].map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                  }),
                  builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                    if (memberListSnapshot.hasData) {
                      return SingleChildScrollView(
                        child: Column(
                            children: memberListSnapshot.data!.map((m) {
                          var member = Member.fromDocument(m);
                          if (member.userFirebaseId != null && member.userFirebaseId == currentUser.userFirebaseId) {
                            return const SizedBox.shrink();
                          }
                          return MemberItem(
                            member: member,
                            onClick: () {
                              createTransactionChangeNotifier.clearTo();
                              createTransactionChangeNotifier.addTo(m.reference, createTransactionChangeNotifier.value);
                              Get.to(() => AddTransfer(firestore: firestore));
                            },
                            color: createTransactionChangeNotifier.color!,
                          );
                        }).toList()),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            ),
          ]),
        ),
        bottomNavigationBar: SpendingShareBottomNavigationBar(
          selectedIndex: 1,
          firestore: firestore,
          color: createTransactionChangeNotifier.color!,
        ),
      );
    });
  }
}
