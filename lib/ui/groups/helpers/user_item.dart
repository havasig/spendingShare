import 'package:flutter/material.dart';
import 'package:spending_share/models/member.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({Key? key, required this.member, required this.onClick, required this.color, this.onDelete}) : super(key: key);

  final Member member;
  final Function onClick;
  final VoidCallback? onDelete;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onClick.call();
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: h(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color[globals.circleShade],
                    child: Text(member.name[0], style: TextStyle(color: color[globals.iconShade])),
                  ),
                  SizedBox(width: w(8)),
                  Text(member.name),
                ],
              ),
              onDelete != null
                  ? IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.close),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ));
  }
}
