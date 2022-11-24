import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AppBottomSheet extends StatelessWidget {
  final PanelController panelController;
  final Widget? panel;
  final Widget Function(ScrollController)? panelBuilder;

  const AppBottomSheet({
    Key? key,
    required this.panelController,
    this.panel,
    this.panelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      backdropEnabled: false,
      maxHeight: context.sizeScreen.height * 0.55,
      minHeight: context.sizeScreen.height * 0.2,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
      ),
      panelSnapping: true,
      snapPoint: 0.3,
      panelBuilder: panelBuilder,
      panel: panel,
    );
  }
}
