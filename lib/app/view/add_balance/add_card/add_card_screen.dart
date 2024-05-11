import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/widgets/app_bar/app_bar_default.dart';

import '../../../resourses/app_colors.dart';
import '../../../widgets/button/app_button_v1.dart';
import '../../../widgets/input/app_input_v1.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardExpireController = TextEditingController();
  TextEditingController cvcController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(
        title: "Добавить карту",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Номер карты",
              style: TextStyle(
                color: Color(0xFF474A56),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            AppInputV1(
              readOnly: false,
              controller: cardNumberController,
              hintText: '1212 0103 6852 33 49',
              bgColor: AppColors.white,
              borderColor: AppColors.grey,
              valueColor: AppColors.black,
              hintColor: AppColors.grey,
              suffixColor: AppColors.blue,
              inputType: TextInputType.text,
            ),
            SizedBox(height: 12.h),
            const Text(
              "Имя владельца",
              style: TextStyle(
                color: Color(0xFF474A56),
                fontSize: 14,
                fontFamily: 'Mazzard',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            AppInputV1(
              readOnly: false,
              controller: cardNameController,
              hintText: 'Nulan Hacker',
              bgColor: AppColors.white,
              borderColor: AppColors.grey,
              valueColor: AppColors.black,
              hintColor: AppColors.grey,
              suffixColor: AppColors.blue,
              inputType: TextInputType.number,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Действует до",
                        style: TextStyle(
                          color: Color(0xFF474A56),
                          fontSize: 14,
                          fontFamily: 'Mazzard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      AppInputV1(
                        readOnly: false,
                        controller: cardExpireController,
                        hintText: 'MM / YY',
                        bgColor: AppColors.white,
                        borderColor: AppColors.grey,
                        valueColor: AppColors.black,
                        hintColor: AppColors.grey,
                        suffixColor: AppColors.blue,
                        inputType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Код CVV",
                        style: TextStyle(
                          color: Color(0xFF474A56),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      AppInputV1(
                        readOnly: false,
                        controller: cvcController,
                        hintText: '***',
                        bgColor: AppColors.white,
                        borderColor: AppColors.grey,
                        valueColor: AppColors.black,
                        hintColor: AppColors.grey,
                        suffixColor: AppColors.blue,
                        inputType: TextInputType.number,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                context.router.pop();
              },
              child: const AppButtonV1(
                text: "Добавить",
              ),
            )
          ],
        ),
      ),
    );
  }
}
