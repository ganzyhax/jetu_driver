import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class AppInputUnderline extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEnabled;
  final bool autoFocus;
  final Function(String)? onChange;

  const AppInputUnderline({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isEnabled = false,
    this.autoFocus = false,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black.withOpacity(0.2),
      ),
    );

    return TextField(
      enabled: isEnabled,
      autofocus: autoFocus,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        disabledBorder: border,
        labelStyle: const TextStyle(
          color: Color(0xFF424242),
        ),
        enabledBorder: border,
        focusedBorder: border,
        border: border,
      ),
      onChanged: (value) {
        EasyDebounce.debounce(
          'search',
          const Duration(milliseconds: 500),
          () => onChange?.call(value),
        );
      },
      onSubmitted: (value) => onChange?.call(value),
    );
  }
}
