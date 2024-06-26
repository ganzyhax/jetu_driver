import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Size get sizeScreen => MediaQuery.of(this).size;

  EdgeInsets get viewScreen => MediaQuery.of(this).viewInsets;
}
