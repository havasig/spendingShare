import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/ui/settings/settings_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class SpendingShareBottomNavigationBar extends StatefulWidget {
  const SpendingShareBottomNavigationBar({Key? key, required this.selectedIndex, required this.firestore, this.color = 'orange'})
      : super(key: key);

  final int selectedIndex;
  final FirebaseFirestore firestore;
  final String color;

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
                  color: widget.selectedIndex == 0 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "statistics".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 0 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.offAll(() => MyGroupsPage(firestore: widget.firestore), transition: Transition.noTransition);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group,
                  color: widget.selectedIndex == 1 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'groups'.tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 1 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => SettingsPage(firestore: widget.firestore));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  color: widget.selectedIndex == 2 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "settings".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 2 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
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
                  color: widget.selectedIndex == 3 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "profile".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 3 ? globals.colors[widget.color] : ColorConstants.white.withOpacity(0.6),
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
