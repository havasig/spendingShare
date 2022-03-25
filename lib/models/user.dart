import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String name;
  Color color;
  String icon;
  String defaultCurrency;
  String adminId;
  List<String> memberIds;

  /*
  members
  admin
   */

  User({
    required this.name,
    required this.defaultCurrency,
    required this.color,
    required this.icon,
    required this.adminId,
    required this.memberIds,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? currentUserFirebaseAuthId = auth.currentUser?.uid;

    return User(
      name: doc['name'],
      color: doc['color'],
      icon: doc['icon'],
      defaultCurrency: doc['defaultCurrency'],
      adminId: doc['adminId'],
      memberIds: doc['memberIds'],
    );
  }
}
