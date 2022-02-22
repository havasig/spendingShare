import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spending_share/ui/constants/color_constants.dart';
import 'package:spending_share/ui/constants/text_style_constants.dart';

class Button extends StatelessWidget {
  Button(
      {required this.onPressed,
        this.text = '',
        this.width = 200,
        this.height = 50,
        this.textColor = ColorConstants.textBlack,
        this.buttonColor = ColorConstants.defaultOrange,
        this.prefixWidget,
        this.suffixWidget,
        this.borderSide,
        Key? key,
        this.textStyle})
      : super(key: key);

  VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final Color textColor;
  final Color buttonColor;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final BorderSide? borderSide;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      side: borderSide,
      onPrimary: textColor,
      primary: buttonColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    textStyle = textStyle ?? TextStyleConstants.body_2_medium.copyWith(color: textColor);

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
            if (text != '' && _prefixWidget != null) const SizedBox(width: 8),
            if (text != '') Text(text, style: textStyle),
            if (text != '' && _suffixWidget != null) const SizedBox(width: 8),
            if (_suffixWidget != null) _suffixWidget,
          ],
        ),
      ),
    );
  }
}

class ButtonPage extends StatelessWidget {
  const ButtonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Button(
                  onPressed: snackbar,
                  text: 'Hello world',
                ),
                const SizedBox(height: 20),
                Button(
                  onPressed: snackbar,
                  text: 'Hello world',
                  buttonColor: ColorConstants.defaultOrange.withOpacity(0.2),
                  textColor: ColorConstants.defaultOrange,
                ),
                const SizedBox(height: 20),
                Button(
                  onPressed: snackbar,
                  text: 'Hello world',
                  buttonColor: ColorConstants.lightGray,
                  textColor: ColorConstants.white.withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                Button(
                  onPressed: snackbar,
                  text: 'Hello world',
                  buttonColor: ColorConstants.lightGray,
                  textColor: ColorConstants.white.withOpacity(0.8),
                  borderSide: BorderSide(
                      color: ColorConstants.white.withOpacity(0.3)
                  ),
                ),
                const SizedBox(height: 20),
                Button(
                  onPressed: snackbar,
                  text: 'Hello world',
                  buttonColor: ColorConstants.backgroundBlack,
                  textColor: ColorConstants.white.withOpacity(0.8),
                  borderSide: BorderSide(
                      color: ColorConstants.white.withOpacity(0.2)
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void snackbar() {
    Get.snackbar("OnPressed", "On pressed working");
  }
}
