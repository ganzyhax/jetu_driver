import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_city/app_city_cubit.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/input/app_input_underline.dart';
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

class AppCitySelect extends StatelessWidget {
  final Function(String, String, String) onAddress;
  final bool showAddress;

  const AppCitySelect({
    Key? key,
    required this.onAddress,
    this.showAddress = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCityCubit(client: injection()),
      child: BlocBuilder<AppCityCubit, AppCityState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Закрыть'),
                ),
                CupertinoSearchTextField(
                  autofocus: true,
                  onChanged: (value) => context.read<AppCityCubit>()
                    ..search(
                      value,
                    ),
                ),
                SizedBox(
                  height: context.sizeScreen.height * 0.8,
                  child: ListView.builder(
                    itemCount: state.cityList.length,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    itemBuilder: (context, index) {
                      final city = state.cityList[index];
                      return InkWell(
                        onTap: () async {
                          String? address = '';
                          if (showAddress) {
                            address = await AppDetailSheet.open(
                              context,
                              widget: AppIntercityAddressInput(
                                title: city.title ?? '',
                              ),
                            );
                          }
                          await onAddress.call(
                            city.id ?? '',
                            city.title ?? '',
                            address ?? '',
                          );
                          Navigator.of(context).pop();
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6.h,
                            horizontal: 12.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city.title ?? '',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                city.address ?? '',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class AppIntercityAddressInput extends StatelessWidget {
  final String title;

  const AppIntercityAddressInput({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController address = TextEditingController();

    return Padding(
      padding: context.viewScreen,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetTitle(title: title),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            child: Column(
              children: [
                AppInputUnderline(
                  isEnabled: true,
                  autoFocus: true,
                  hintText: 'Адрес',
                  controller: address,
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(
                    address.text,
                  ),
                  child: const AppButtonV1(
                    text: 'Сохранить',
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
