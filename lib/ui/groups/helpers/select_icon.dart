import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

import 'create_group_change_notifier.dart';

class SelectIcon extends StatefulWidget {
  const SelectIcon({Key? key, required this.defaultIcon}) : super(key: key);

  final String defaultIcon;

  @override
  _SelectIconState createState() => _SelectIconState();
}

class _SelectIconState extends State<SelectIcon> {
  int selectedIndex = 0;

  @override
  void initState() {
    globals.icons.keys.toList().asMap().forEach((index, value) => {if (value == widget.defaultIcon) selectedIndex = index});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [Text('group_icon'.tr)],
        ),
        SizedBox(height: h(6)),
        SizedBox(
          height: h(150),
          child: Consumer<CreateGroupChangeNotifier>(builder: (_, createGroupChangeNotifier, __) {
            return GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: h(8),
                  mainAxisSpacing: h(8),
                ),
                itemCount: globals.icons.length,
                itemBuilder: (BuildContext ctx, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        createGroupChangeNotifier.setIcon(globals.icons.keys.toList()[index], globals.icons.values.toList()[index]);
                        selectedIndex = index;
                      },
                      child: Icon(
                        globals.icons.values.toList()[index],
                        size: h(34),
                        color: selectedIndex == index ? createGroupChangeNotifier.color[globals.circleShade] : null,
                      ),
                    ),
                  );
                });
          }),
        ),
      ],
    );
  }
}