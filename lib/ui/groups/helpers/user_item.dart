import 'package:flutter/material.dart';
import 'package:spending_share/models/user.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class UserItem extends StatelessWidget {
  const UserItem({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.brown.shade800,
          child: Text(user.name[0]),
        ),
        SizedBox(width: w(8)),
        Text(user.name),
      ],
    );
  }
}
