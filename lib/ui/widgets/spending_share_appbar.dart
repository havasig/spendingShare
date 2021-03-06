import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class SpendingShareAppBar extends AppBar {
  final String titleText;
  final String forwardText;
  final bool hasBack;
  final bool hasForward;
  final VoidCallback? onBack;
  final Function? onForward;
  final Widget? titleWidget;
  final Widget? suffixWidget;

  SpendingShareAppBar({
    Key? key,
    this.titleText = '',
    this.forwardText = '',
    this.hasBack = true,
    this.hasForward = false,
    this.onBack,
    this.onForward,
    this.titleWidget,
    this.suffixWidget,
  }) : super(
          key: key,
          title: Text(titleText, style: TextStyleConstants.body_1.copyWith(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.darkGray,
          leadingWidth: w(100),
          leading: hasBack
              ? GestureDetector(
                  onTap: () {
                    onBack != null ? onBack.call() : Get.back();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_left,
                        size: h(35),
                        color: ColorConstants.white,
                      ),
                      Text(
                        'back'.tr, //backText.tr,
                        style: TextStyleConstants.body_1.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : null,
          actions: [
            hasForward
                ? GestureDetector(
                    key: Key(forwardText),
                    onTap: () {
                      onForward?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          Text(
                            forwardText,
                            style: TextStyleConstants.body_1.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: h(35),
                            color: ColorConstants.white,
                          ),
                        ],
                      ),
                    ),
                  )
                : (suffixWidget ?? const SizedBox.shrink())
          ],
        );
}
