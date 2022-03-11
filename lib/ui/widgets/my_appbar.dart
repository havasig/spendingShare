import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';
import 'package:spending_share/utils/screen_util_helper.dart';

class MyAppBar extends AppBar {
  final String titleText;
  final String backText;
  final String forwardText;
  final bool hasBack;
  final bool hasForward;
  final VoidCallback? onBack;
  final VoidCallback? onForward;
  final Widget? titleWidget;
  final Widget? suffixWidget;

  MyAppBar({
    Key? key,
    this.titleText = '',
    this.backText = 'Back',
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
          backgroundColor: ColorConstants.backgroundBlack,
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
                        backText,
                        style: TextStyleConstants.body_1.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : null,
          actions: [
            hasForward
                ? GestureDetector(
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
