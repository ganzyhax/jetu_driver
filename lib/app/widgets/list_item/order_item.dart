import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/widgets/button/rounded_button.dart';
import 'package:jetu.driver/app/widgets/list_item/user_avatar.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return InkWell(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.only(
          top: 12.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserAvatar(avatarUrl: model.user?.avatarUrl),
                SizedBox(height: 4.h),
                Text(
                  model.user?.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '⭐ ${model.user?.rating ?? ''} ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.aPointAddress ?? 'не указан',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    model.bPointAddress ?? 'не указан',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${model.cost ?? 'не указан'} ₸',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  if (model.createdAt != null ?? false)
                    Text(
                      DateFormat('HH:mm a').format(model.createdAt!),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 2.h),
                  if (model.comment?.isNotEmpty ?? false)
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
                  SizedBox(height: 6.h),
                  const Divider(height: 0),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                model.service?.title ?? '',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showPhone) ...[
              SizedBox(width: 12.w),
              RoundedButton(
                icon: Ionicons.call,
                onPressed: () => launchUrl(
                  Uri.parse("tel://${model.user?.phone}"),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
