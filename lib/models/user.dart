import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  String name;
  String color;
  String icon;
  String defaultCurrency;

  User({
    required this.name,
    required this.defaultCurrency,
    required this.color,
    required this.icon,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? currentUserFirebaseAuthId = auth.currentUser?.uid;


    doc as DocumentSnapshot<Map<String, dynamic>>;
    return User(
      name: doc.data()?['name'] ?? '',
      color: doc.data()?['color'] ?? '',
      icon: doc.data()?['icon'] ?? '',
      defaultCurrency: doc.data()?['defaultCurrency'] ?? '',
    );
  }
}
