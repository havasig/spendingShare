import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_share/models/data/create_transaction_data.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/ui/helpers/member_item.dart';
import 'package:spending_share/ui/transactions/transfer/add_transfer.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

import '../../helpers/change_notifiers/transaction_change_notifier.dart';

class TransferTo extends StatelessWidget {
  const TransferTo({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTransactionChangeNotifier>(
      builder: (_, createTransactionChangeNotifier, __) => Consumer<CreateTransactionData>(
        builder: (_, createTransactionData, __) => Scaffold(
          appBar: SpendingShareAppBar(titleText: 'transfer_to'.tr),
          body: Padding(
            padding: EdgeInsets.all(h(16)),
            child: Column(children: [
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                    stream: firestore.collection('groups').doc(createTransactionData.groupId).snapshots().switchMap((group) {
                      return CombineLatestStream.list(
                          group.data()!['members'].map<Stream<DocumentSnapshot>>((member) => (member as DocumentReference).snapshots()));
                    }),
                    builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> memberListSnapshot) {
                      if (memberListSnapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                              children: memberListSnapshot.data!.map((m) {
                            var member = Member.fromDocument(m);
                            if (createTransactionData.member?.id == m.id) {
                              return const SizedBox.shrink();
                            }
                            return MemberItem(
                              key: Key(member.name+ '_member'),
                              member: member,
                              onClick: () {
                                createTransactionChangeNotifier.clearTo();
                                createTransactionChangeNotifier.addTo(m.reference, createTransactionChangeNotifier.value);
                                Get.to(() => AddTransfer(firestore: firestore));
                              },
                              color: createTransactionData.color,
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
            key: const Key('bottom_navigation'),
            selectedIndex: 1,
            firestore: firestore,
            color: createTransactionData.color,
          ),
        ),
      ),
    );
  }
}
