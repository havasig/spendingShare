import 'package:flutter/material.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({Key? key, required this.member, required this.onClick}) : super(key: key);

  final Member member;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onClick.call();
        },
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: h(12)),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    child: Text(member.name[0]),
                  ),
                  SizedBox(width: w(8)),
                  Text(member.name),
                ],
              ),
            ),
          ],
        ));
  }
}
