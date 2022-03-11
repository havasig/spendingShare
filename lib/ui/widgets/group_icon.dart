import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupIcon extends StatelessWidget {
  final VoidCallback onTap;
  const GroupIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency, //Makes it usable on any background color, thanks @IanSmith
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigoAccent, width: 4.0),
            color: Colors.indigo[900],
            shape: BoxShape.circle,
          ),
          child: InkWell(
            //This keeps the splash effect within the circle
            borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Icon(
                Icons.message,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
