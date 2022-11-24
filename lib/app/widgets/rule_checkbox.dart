import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class RuleCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool)? onTap;

  const RuleCheckbox({
    Key? key,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity: VisualDensity.standard,
      onChanged: (value) => onTap?.call(value!),
      title: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Text(
                'Я прочитал и согласен с',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.black,
                ),
              ),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () async => await launchUrl(
                    Uri.parse('https://eduu.tilda.ws/terms_of_use')),
                child: Text(
                  'пользовательское соглашение ',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 11.sp,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            WidgetSpan(
              child: Text(
                'и даю даю согласие на',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.black,
                ),
              ),
            ),
            WidgetSpan(
              child: GestureDetector(
                onTap: () async => await launchUrl(
                    Uri.parse('https://www.freeprivacypolicy.com/privacy/view/ff8fed2dd3b1f40c3df93ac707d2ecb4')),
                child: Text(
                  'обработку персональных данных',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 11.sp,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
