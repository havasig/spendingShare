import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';

class MyAppBar extends AppBar {
  final String titleText;
  final bool hasBack;
  final VoidCallback? onBack;
  final Widget? titleWidget;
  final Widget? suffixWidget;
  final double size;

  MyAppBar({
    Key? key,
    this.titleText = "",
    this.hasBack = true,
    this.onBack,
    this.titleWidget,
    this.suffixWidget,
    this.size = 56,
  })  : preferredSize = Size.fromHeight(size),
        super(
          key: key,
          title: Text(titleText, style: TextStyleConstants.body_1.copyWith(fontWeight: FontWeight.bold)),
          bottom: PreferredSize(preferredSize: Size.fromHeight(size), child: titleWidget ?? const SizedBox.shrink()),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.backgroundBlack,
          leading: hasBack
              ? IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    onBack != null ? onBack.call() : Get.back();
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: ColorConstants.white,
                  ),
                  iconSize: 40,
                )
              : null,
          actions: [suffixWidget ?? const SizedBox.shrink()],
        );

  @override
  final Size preferredSize;
}
