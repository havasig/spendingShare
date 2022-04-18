import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/ui/groups/create/select_currency.dart';
import 'package:spending_share/ui/helpers/change_notifiers/currency_change_notifier.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key, required this.firestore, required this.color, required this.currency}) : super(key: key);

  final FirebaseFirestore firestore;
  final String color;
  final String currency;

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  @override
  Widget build(BuildContext context) {
    SpendingShareUser currentUser = Provider.of(context);
    CreateTransactionChangeNotifier _createTransactionChangeNotifier = CreateTransactionChangeNotifier(widget.currency);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SpendingShareAppBar(titleText: 'add_transaction'.tr),
        body: Padding(
          padding: EdgeInsets.all(h(16)),
          child: ChangeNotifierProvider(
            create: (context) => _createTransactionChangeNotifier as CreateChangeNotifier,
            child: Column(
              children: [
                SizedBox(height: h(6)),
                SelectCurrency(currency: currentUser.currency),
                const Spacer(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SpendingShareBottomNavigationBar(
          selectedIndex: 1,
          firestore: widget.firestore,
          color: widget.color,
        ),
      ),
    );
  }
}
