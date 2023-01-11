import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/list_item/user_avatar.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderPaymendScreen extends StatelessWidget {
  final PanelController panelController;
  final JetuOrderModel model;

  const OrderPaymendScreen({
    Key? key,
    required this.panelController,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      panelController: panelController,
      panel: Container(
        child: Column(
          children: [
            BottomSheetTitle(
              title: 'Ожидание оплаты клиента',
              isLargeTitle: true,
            ),
            SizedBox(height: 4.h),
            Text(
              'Получите оплату наличними 💵',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 12.h),
            UserAvatar(
              avatarUrl: model.user?.avatarUrl,
              size: 46,
            ),
            SizedBox(height: 4.h),
            Text(
              '${model.user?.name ?? ''} ${model.user?.surname ?? ''}',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12.sp),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Поездка',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${model.cost ?? 'не указан'} ₸',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Налог',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '+0.0 ₸',
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.6),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итог',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${model.cost ?? 'не указан'} ₸',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => context.read<OrderCubit>().changeStatusOrder(
                    model.id,
                    status: 'finished',
                  ),
              child: AppButtonV1(
                text: 'Оплата наличными получена',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
