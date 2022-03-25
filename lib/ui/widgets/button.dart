import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';

class Button extends StatelessWidget {
  const Button(
      {required this.onPressed,
      this.text = '',
      this.width,
      this.height,
      this.textColor = ColorConstants.textBlack,
      this.buttonColor = ColorConstants.defaultOrange,
      this.prefixWidget,
      this.suffixWidget,
      this.borderSide,
      Key? key,
      this.textStyle})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final Color textColor;
  final Color buttonColor;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final BorderSide? borderSide;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      side: borderSide,
      onPrimary: textColor,
      primary: buttonColor,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    TextStyle _textStyle = textStyle ?? TextStyleConstants.body_2_medium.copyWith(color: textColor);

    Widget? _prefixWidget = prefixWidget;
    Widget? _suffixWidget = suffixWidget;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_prefixWidget != null) _prefixWidget,
            if (text != '' && _prefixWidget != null) const Spacer(),
            if (text != '') Text(text, style: _textStyle),
            if (text != '' && _suffixWidget != null) const Spacer(),
            if (_suffixWidget != null) _suffixWidget,
          ],
        ),
      ),
    );
  }
}
