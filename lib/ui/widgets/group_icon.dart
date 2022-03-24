import 'package:flutter/material.dart';
import 'package:spending_share/utils/globals.dart' as globals;

class GroupIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final String icon;
  final String color;

  const GroupIcon({
    Key? key,
    required this.onTap,
    required this.name,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int circleShade = 500;
    int iconShade = 100;
    return Wrap(
      children: [
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.pink[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.pink[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.red[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.red[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.teal[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.teal[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.green[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.green[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.lightBlue[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.lightBlue[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.orange[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.orange[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.purple[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.purple[iconShade],
                  ),
                ),
              ),
            )),
        Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.blueGrey[circleShade],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                //This keeps the splash effect within the circle
                borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    globals.icons[icon] ?? Icons.ac_unit,
                    size: 30.0,
                    color: Colors.blueGrey[iconShade],
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
