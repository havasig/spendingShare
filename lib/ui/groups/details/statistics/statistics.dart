import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:spending_share/ui/widgets/button.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class Statistics extends StatelessWidget {
  const Statistics({Key? key, required this.color}) : super(key: key);

  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('TODO Statistics'),
        Text('there_are_no_statistics'.tr),
        // TODO statistics
        /*Column(
                      children: List.generate(
                        group['transactions'].length > 5 ? 5 : group['transactions'].length,
                        (index) => FutureBuilder<DocumentSnapshot>(
                          future: group['transactions'][index].get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              var transaction = spending_share_transaction.Transaction.fromDocument(snapshot.data!);
                              return Text(transaction.databaseId);
                            }
                            return OnFutureBuildError(snapshot);
                          },
                        ),
                      ),
                    ),*/
        Center(
          child: Button(
            onPressed: () {},
            text: 'show_all_statistics'.tr,
            textColor: color,
            buttonColor: color.withOpacity(0.2),
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ),
      ],
    );
  }
}
