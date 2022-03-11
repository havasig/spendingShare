import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/my_groups.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class SpendingShareBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const SpendingShareBottomNavigationBar({required this.selectedIndex, Key? key}) : super(key: key);

  @override
  _SpendingShareBottomNavigationBarState createState() => _SpendingShareBottomNavigationBarState();
}

class _SpendingShareBottomNavigationBarState extends State<SpendingShareBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: h(64),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        color: ColorConstants.lightGray,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              //TODO: Navigation
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart,
                  color: widget.selectedIndex == 0 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "statistics".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 0 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.offAll(() => MyGroupsPage(), transition: Transition.noTransition);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group,
                  color: widget.selectedIndex == 1 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "groups".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 1 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              //TODO: Navigation
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  color: widget.selectedIndex == 2 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "settings".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 2 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              //TODO: Navigation
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle,
                  color: widget.selectedIndex == 3 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "profile".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 3 ? ColorConstants.defaultOrange : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}