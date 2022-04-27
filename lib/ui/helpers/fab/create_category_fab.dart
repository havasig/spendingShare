import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/widgets/dialogs/create_category_dialog.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class CreateCategoryFab extends StatelessWidget {
  const CreateCategoryFab({Key? key, required this.firestore, required this.color, required this.groupId}) : super(key: key);

  final FirebaseFirestore firestore;
  final String color;
  final String groupId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FloatingActionButton(
        key: const Key('create_category'),
        tooltip: 'create_category',
        backgroundColor: globals.colors[color],
        splashColor: ColorConstants.lightGray,
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateCategoryDialog(color: color);
            }).then((value) async {
          var categoryReference = await firestore.collection('categories').add({
            'name': value,
            'transactions': [],
          });

          var group = await firestore.collection('groups').doc(groupId).get();
          var newCategoryReferenceList = group.data()!['categories'];
          newCategoryReferenceList.add(categoryReference);

          await firestore.collection('groups').doc(groupId).set({'categories': newCategoryReferenceList}, SetOptions(merge: true));
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}
