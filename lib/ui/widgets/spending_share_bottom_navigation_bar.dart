import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/ui/groups/my_groups_page.dart';
import 'package:spending_share/ui/profile/profile_page.dart';
import 'package:spending_share/ui/settings/settings_page.dart';
import 'package:spending_share/ui/statistics/statistics_page.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import 'package:spending_share/utils/screen_util_helper.dart';

class SpendingShareBottomNavigationBar extends StatefulWidget {
  SpendingShareBottomNavigationBar({Key? key, required this.selectedIndex, required this.firestore, this.color}) : super(key: key);

  final int selectedIndex;
  final FirebaseFirestore firestore;
  MaterialColor? color;

  @override
  _SpendingShareBottomNavigationBarState createState() => _SpendingShareBottomNavigationBarState();
}

class _SpendingShareBottomNavigationBarState extends State<SpendingShareBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    widget.color ??= globals.colors['default']!;
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
              if (widget.selectedIndex != 0) Get.offAll(() => StatisticsPage(firestore: widget.firestore, color: widget.color!));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bar_chart,
                  color: widget.selectedIndex == 0 ? widget.color : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "statistics".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 0 ? widget.color : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.offAll(() => MyGroupsPage(firestore: widget.firestore));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.group,
                  color: widget.selectedIndex == 1 ? widget.color : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(height: 4),
                Text(
                  'groups'.tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 1 ? widget.color : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.selectedIndex != 2) Get.offAll(() => SettingsPage(firestore: widget.firestore));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  color: widget.selectedIndex == 2 ? widget.color : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "settings".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 2 ? widget.color : ColorConstants.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.selectedIndex != 3) Get.offAll(() => ProfilePage(firestore: widget.firestore));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_circle,
                  color: widget.selectedIndex == 3 ? widget.color : ColorConstants.white.withOpacity(0.6),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "profile".tr,
                  style: TextStyleConstants.sub_1.copyWith(
                    fontSize: 10,
                    color: widget.selectedIndex == 3 ? widget.color : ColorConstants.white.withOpacity(0.6),
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
