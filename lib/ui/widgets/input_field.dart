import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final String? errorText;
  final Color color;
  final Color focusColor;
  final Color errorColor;
  Color labelColor;
  Widget? suffixIcon;
  final Icon? prefixIcon;
  final bool enabled;
  bool hasGlow;
  bool isPasswordField;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final TextAlign textAlign;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;
  bool? obscureText;

  InputField({
    Key? key,
    this.hintText = '',
    this.labelText = '',
    this.initialValue,
    this.errorText,
    this.color = ColorConstants.white,
    this.focusColor = ColorConstants.defaultOrange,
    this.errorColor = Colors.red,
    this.labelColor = Colors.white,
    this.suffixIcon,
    this.prefixIcon,
    this.hasGlow = false,
    this.enabled = true,
    this.isPasswordField = false,
    this.textCapitalization = TextCapitalization.none,
    @required this.focusNode,
    this.textEditingController,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.onCompleted,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  Color passVisibilityColor = ColorConstants.white.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    widget.obscureText = widget.isPasswordField;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: widget.hasGlow
                ? ColorConstants.defaultOrange.withOpacity(0.2)
                : Colors.transparent,
            spreadRadius: 4,
            blurRadius: 10,
          )
        ]),
        child: Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              if (hasFocus) {
                widget.labelColor = widget.focusColor;
                passVisibilityColor = widget.focusColor;
                if (widget.suffixIcon is Icon) {
                  widget.suffixIcon = Icon((widget.suffixIcon as Icon).icon,
                      color: widget.focusColor);
                }
                widget.hasGlow = true;
              } else {
                widget.labelColor = widget.color;
                passVisibilityColor = widget.color;
                if (widget.suffixIcon is Icon) {
                  widget.suffixIcon = Icon((widget.suffixIcon as Icon).icon,
                      color: widget.color);
                }
                widget.hasGlow = false;
              }
            });
          },
          child: TextFormField(
            initialValue: widget.initialValue,
            textAlign: widget.textAlign,
            textCapitalization: widget.textCapitalization,
            controller: widget.textEditingController,
            obscureText: widget.obscureText!,
            enabled: widget.enabled,
            cursorColor: widget.focusColor,
            focusNode: widget.focusNode,
            keyboardType: widget.textInputType,
            onChanged: (String str) {
              widget.onChanged?.call(str);
            },
            style: TextStyle(
                color: widget.enabled ? null : ColorConstants.darkGray),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              fillColor: ColorConstants.darkGray,
              filled: true,
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                      color: passVisibilityColor,
                      icon: Icon(widget.obscureText!
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText!;
                        });
                      },
                    )
                  : widget.suffixIcon,
              prefixIcon: widget.isPasswordField
                  ? const Icon(
                      Icons.lock,
                      color: ColorConstants.defaultOrange,
                    )
                  : widget.prefixIcon,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.errorColor,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.focusColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.focusColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: widget.color,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              labelText: widget.labelText,
              labelStyle: TextStyle(
                  color: widget.focusNode!.hasFocus
                      ? widget.focusColor
                      : widget.color),
              hintText: widget.hintText,
              errorText: widget.errorText,
              focusColor: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

class InputFieldPage extends StatefulWidget {
  const InputFieldPage({Key? key}) : super(key: key);

  @override
  State<InputFieldPage> createState() => _InputFieldPageState();
}

class _InputFieldPageState extends State<InputFieldPage> {
  @override
  Widget build(BuildContext context) {
    FocusNode focusNode1 = FocusNode();
    FocusNode focusNode2 = FocusNode();
    FocusNode focusNode3 = FocusNode();
    FocusNode focusNode4 = FocusNode();
    final formGlobalKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Input Filed Page'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 50),
            InputField(
              focusNode: focusNode1,
              onChanged: (s) {},
              prefixIcon: const Icon(
                Icons.mail,
                color: ColorConstants.defaultOrange,
              ),
              labelText: 'Email address',
              hintText: 'Your email',
            ),
            const SizedBox(height: 50),
            InputField(
              labelText: 'Label Text',
              hintText: 'Hint Text',
              focusNode: focusNode2,
              isPasswordField: true,
            ),
            const SizedBox(height: 50),
            InputField(
              labelText: 'Label Text',
              hintText: 'Hint Text',
              focusNode: focusNode3,
              enabled: false,
              suffixIcon: Icon(
                Icons.accessibility,
                color: focusNode2.hasFocus
                    ? ColorConstants.defaultOrange
                    : ColorConstants.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String validatePassword(String value) {
  if ((value.length < 5) && value.isNotEmpty) {
    return 'Password should contain more than 5 characters';
  }
  return '';
}
