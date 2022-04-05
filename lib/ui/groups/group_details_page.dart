import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/ui/widgets/spending_share_appbar.dart';
import 'package:spending_share/ui/widgets/spending_share_bottom_navigation_bar.dart';

class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({Key? key, required this.firestore, this.hasBack = true}) : super(key: key);

  final FirebaseFirestore firestore;
  final bool hasBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendingShareAppBar(
        hasBack: hasBack,
      ),
      body: Column(
        children: [Text('my group page')],
      ),
      bottomNavigationBar: SpendingShareBottomNavigationBar(
        firestore: firestore,
        selectedIndex: 1,
      ),
    );
  }
}
