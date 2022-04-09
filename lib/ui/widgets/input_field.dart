import 'package:flutter/material.dart';
import 'package:spending_share/ui/constants/color_constants.dart';

class InputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final Color color;
  final Color focusColor;
  final Color errorColor;
  Color labelColor;
  final Icon? prefixIcon;
  final bool enabled;
  bool isPasswordField;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  bool? obscureText;
  final String? Function(String?)? validator;

  InputField({
    Key? key,
    required this.focusNode,
    this.validator,
    this.initialValue,
    this.prefixIcon,
    this.textEditingController,
    this.hintText = '',
    this.labelText = '',
    this.enabled = true,
    this.isPasswordField = false,
    this.textInputType = TextInputType.text,
    // TODO remove all these?
    this.color = ColorConstants.white,
    this.focusColor = ColorConstants.defaultOrange,
    this.errorColor = Colors.red,
    this.labelColor = Colors.white,
    this.textCapitalization = TextCapitalization.none,
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
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            if (hasFocus) {
              widget.labelColor = widget.focusColor;
              passVisibilityColor = widget.focusColor;
            } else {
              widget.labelColor = widget.color;
              passVisibilityColor = widget.color;
            }
          });
        },
        child: TextFormField(
          validator: widget.validator,
          initialValue: widget.initialValue,
          textCapitalization: widget.textCapitalization,
          controller: widget.textEditingController,
          obscureText: widget.obscureText!,
          enabled: widget.enabled,
          cursorColor: widget.focusColor,
          focusNode: widget.focusNode,
          keyboardType: widget.textInputType,
          style: TextStyle(color: widget.enabled ? null : ColorConstants.darkGray),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            fillColor: ColorConstants.darkGray,
            filled: true,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    color: passVisibilityColor,
                    icon: Icon(widget.obscureText! ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText!;
                      });
                    },
                  )
                : null,
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
            labelStyle: TextStyle(color: widget.focusNode!.hasFocus ? widget.focusColor : widget.color),
            hintText: widget.hintText,
            focusColor: widget.color,
          ),
        ),
      ),
    );
  }
}
