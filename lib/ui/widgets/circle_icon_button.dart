import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class CircleIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String color;
  final String? icon;
  final String? name;
  final double width;

  const CircleIconButton({
    Key? key,
    this.onTap,
    required this.color,
    this.icon,
    this.name,
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
                color: globals.colors[color]?[globals.circleShade] ?? Colors.orange[globals.circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(1000),
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(h(width)),
                  child: Icon(
                    globals.icons[icon] ?? Icons.group,
                    size: h(width),
                    color: globals.colors[color]?[globals.iconShade] ?? Colors.orange[globals.iconShade],
                  ),
                ),
              ),
            )),
        if (name != null)
          Container(
            alignment: Alignment.center,
            width: width * 3,
            child: Text(
              name!,
              style: TextStyleConstants.body_2_medium,
              textAlign: TextAlign.center,
            ),
          )
      ],
    );
  }
}
