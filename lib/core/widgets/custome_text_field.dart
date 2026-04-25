import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class CustomeTextField extends StatefulWidget {
  final String? hint;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final bool obscureText;
  final Text? label;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final int? maxLength;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool? isDense;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Widget? suffix;
  final Function()? onTap;

  final bool? enabled;

  const CustomeTextField({
    super.key,
    this.hint,
    this.onChanged,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.obscureText = false,
    this.label,
    this.hintStyle,
    this.controller,
    this.maxLength,
    this.labelStyle,
    this.floatingLabelStyle,
    this.maxLines = 1,
    this.validator,
    this.readOnly = false,
    this.isDense,
    this.labelText,
    this.floatingLabelBehavior,
    this.suffix,
    this.onTap,
    this.enabled,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomeTextField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double horizontalPadding = screenSize.width * 0.8 < 400 ? 16 : 32;
    final double textSize = screenSize.width < 600 ? 15 : 17;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        enabled: widget.enabled ?? true,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: _showPassword ? false : widget.obscureText,
        validator: widget.validator,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          floatingLabelBehavior: widget.floatingLabelBehavior,
          errorStyle: AppTextStyles.size16W600,
          isDense: widget.isDense,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                )
              : widget.suffixIcon,
          label: widget.label,
          floatingLabelStyle: widget.floatingLabelStyle,
          labelStyle: widget.labelStyle,
          prefixIcon: widget.prefixIcon,
          hintText: widget.hintText,
          hintStyle:
              widget.hintStyle?.copyWith(fontSize: textSize) ??
              AppTextStyles.size16W700.copyWith(
                fontSize: textSize,
                color: AppColors.primary,
              ),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: buildBorder(),
          border: buildBorder(),
          focusedBorder: buildBorder(AppColors.primary),
          suffix: widget.suffix,
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(2),
      borderSide: BorderSide(color: color ?? AppColors.primary),
    );
  }
}
