import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/widgets/button/rounded_button.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resourses/app_icons.dart';

class OrderItem extends StatelessWidget {
  final JetuOrderModel model;
  final VoidCallback? onTap;
  final bool showPhone;

  const OrderItem({
    Key? key,
    required this.model,
    this.onTap,
    this.showPhone = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(model.user!.avatarUrl.toString());
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 8.h,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (model.user?.avatarUrl == '' || model.user?.avatarUrl == null)
                    ? Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image: AssetImage('assets/images/jetu_logo.jpeg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      )
                    : Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: DecorationImage(
                            image:
                                NetworkImage(model.user!.avatarUrl.toString()),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                      ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.user?.name ?? 'Не указано',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (model.createdAt != null ?? false)
                      Text(
                        DateFormat('HH:mm a').format(model.createdAt!),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 2.w),
                Text(
                  '⭐ ${model.user?.rating ?? '0.0'} ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(),
                if (showPhone) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      model.service?.title ?? '',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  RoundedButton(
                    icon: Ionicons.call,
                    onPressed: () {
                      launchUrl(
                        Uri.parse("tel://${model.user?.phone}"),
                      );
                    },
                  )
                ]
              ],
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: context.sizeScreen.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.pointAIcon),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          model.aPointAddress ?? 'не указан',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.pointBIcon),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          model.bPointAddress ?? 'не указан',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Image.asset(
                        (model.currency.toString() == 'Наличные')
                            ? AppIcons.cashIcon
                            : (model.currency.toString().contains('Kaspi')
                                ? 'assets/images/kaspi_logo.jpg'
                                : 'assets/images/halyk_logo.jpg'),
                        width: 24,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        (model.currency.toString() == 'Наличные')
                            ? 'Оплата наличными: ${model.cost ?? 'не указан'} тг'
                            : (model.currency.toString().contains('Kaspi'))
                                ? 'Kaspi Bank'
                                : 'Halyk Bank',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    model.comment ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
