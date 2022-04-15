import 'package:flutter/material.dart';
import 'package:spending_share/models/group.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class GroupIcon extends StatelessWidget {
  final VoidCallback onTap;
  final Group group;
  final double width;

  const GroupIcon({
    Key? key,
    required this.onTap,
    required this.group,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: globals.colors[group.color]?[globals.circleShade] ?? Colors.orange[globals.circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(h(width)),
                  child: Icon(
                    globals.icons[group.icon] ?? Icons.group,
                    size: 30,
                    color: globals.colors[group.color]?[globals.iconShade] ?? Colors.orange[globals.iconShade],
                  ),
                ),
              ),
            )),
        Container(
          alignment: Alignment.center,
          width: width * 2 + 30,
          child: Text(
            group.name,
            style: TextStyleConstants.body_2_medium,
          ),
        )
      ],
    );
  }
}
