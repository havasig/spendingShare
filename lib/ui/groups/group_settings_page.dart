import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupSettingsPage extends StatelessWidget {
  const GroupSettingsPage({Key? key, required this.firestore}) : super(key: key);

  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Text('asd')],
      ),
    );
  }
}
