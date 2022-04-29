import 'package:flutter/material.dart';
import 'package:spending_share/ui/widgets/tab.dart';

import '../../utils/screen_util_helper.dart';
import '../constants/color_constants.dart';

class TabNavigation extends StatefulWidget {
  final int initIndex;
  final MaterialColor color;
  final List<SpendingShareTab> tabs;

  const TabNavigation({this.initIndex = 0, required this.color, required this.tabs, Key? key}) : super(key: key);

  @override
  _TabNavigationState createState() => _TabNavigationState();
}

class _TabNavigationState extends State<TabNavigation> {
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.initIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: h(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: ColorConstants.lightGray,
              width: 1,
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.tabs.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(h(4)),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (widget.tabs[index].onSelect != null) widget.tabs[index].onSelect!(context);
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - h(8) * widget.tabs.length - h(34)) / widget.tabs.length,
                      decoration: BoxDecoration(
                        color: index == selectedIndex ? widget.color : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          widget.tabs[index].header,
                          style: TextStyle(color: index == selectedIndex ? ColorConstants.black : Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              })),
        ),
        const SizedBox(
          height: 8,
        ),
        widget.tabs[selectedIndex].content,
      ],
    );
  }
}
