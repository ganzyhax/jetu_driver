import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resourses/app_colors.dart';

class AppInputV1 extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final Color? bgColor;
  final Color? hintColor;
  final Color? valueColor;
  final Color? suffixColor;
  final Color? borderColor;
  final bool readOnly;
  final String? initText;
  final Function(String)? onChanged;
  final bool isActive;
  final FontWeight? textFontWeight;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  const AppInputV1({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.inputType = TextInputType.text,
    this.bgColor,
    this.hintColor,
    this.valueColor,
    this.suffixColor,
    this.borderColor,
    this.readOnly = false,
    this.initText,
    this.onChanged,
    this.isActive = true,
    this.textFontWeight,
    this.suffixIcon,
    this.onTap,
  }) : super(key: key);

  @override
  State<AppInputV1> createState() => _AppInputV1State();
}

class _AppInputV1State extends State<AppInputV1> {
  bool _passwordVisible = false;

  bool isPasswordType = false;

  @override
  void initState() {
    super.initState();

    isPasswordType = widget.inputType == TextInputType.visiblePassword;
    if (widget.initText != null) {
      widget.controller.text = widget.initText ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.w,
        strokeAlign: 0,
        color: widget.borderColor ?? AppColors.white.withOpacity(0.06),
      ),
      borderRadius: BorderRadius.circular(12.r),
    );

    return TextFormField(
      onTap: () => widget.onTap?.call(),
      enabled: widget.isActive,
      onChanged: (value) => widget.onChanged?.call(value),
      readOnly: widget.readOnly,
      keyboardType: widget.inputType,
      controller: widget.controller,
      cursorColor: AppColors.blue,
      obscureText: isPasswordType ? !_passwordVisible : false,
      style: TextStyle(
        color: widget.valueColor ?? AppColors.white,
        fontSize: 16.sp,
        fontWeight: widget.textFontWeight ?? FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.bgColor ?? AppColors.white.withOpacity(0.06),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor ?? AppColors.white.withOpacity(0.4),
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: isPasswordType
            ? IconButton(
                icon: SvgPicture.asset(
                  _passwordVisible
                      ? "assets/icons/show_pass_icon.svg"
                      : 'assets/icons/hide_pass_icon.svg',
                  color: widget.suffixColor ?? AppColors.white.withOpacity(0.4),
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
