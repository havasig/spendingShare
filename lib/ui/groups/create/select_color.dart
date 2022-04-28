import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/helpers/change_notifiers/create_group_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class SelectColor extends StatefulWidget {
  const SelectColor({Key? key, required this.defaultColor}) : super(key: key);

  final MaterialColor defaultColor;

  @override
  State<SelectColor> createState() => _SelectColorState();
}

class _SelectColorState extends State<SelectColor> {
  int selectedIndex = 0;

  @override
  void initState() {
    globals.colors.values.toList().asMap().forEach((index, value) => {if (value == widget.defaultColor) selectedIndex = index});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [Text('group_color'.tr)],
        ),
        SizedBox(height: h(6)),
        SizedBox(
          height: h(38),
          child: Consumer<CreateGroupChangeNotifier>(builder: (_, createGroupChangeNotifier, __) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: globals.colors.length,
              itemBuilder: (context, index) {
                MaterialColor value = globals.colors.values.elementAt(index);

                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Material(
                      type: MaterialType.transparency,
                      child: Ink(
                        decoration: BoxDecoration(
                            color: value[globals.circleShade] ?? Colors.orange[globals.circleShade],
                            shape: BoxShape.circle,
                            border: selectedIndex == index
                                ? Border.all(color: value[globals.iconShade] ?? Colors.orange[globals.iconShade]!, width: h(3))
                                : Border.all(color: value[globals.circleShade] ?? Colors.orange[globals.iconShade]!, width: h(3))),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          onTap: () {
                            setState(() {
                              createGroupChangeNotifier.setColor(value);
                              selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(h(12)),
                            child: const SizedBox.shrink(),
                          ),
                        ),
                      )),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
