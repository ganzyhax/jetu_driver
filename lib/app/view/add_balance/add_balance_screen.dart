import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/widgets/app_bar/app_bar_default.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../resourses/app_colors.dart';

class AddBalanceScreen extends StatefulWidget {
  const AddBalanceScreen({Key? key}) : super(key: key);

  @override
  State<AddBalanceScreen> createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  TextEditingController priceController = TextEditingController();

  Future<void> addAmount() async {
    try {
      final queryParameters = {
        "driver_id": "6ij4TNvmojRxK2gTDOCR7u50g793",
        "amount": priceController.text,
      };

      var url = Uri.https(
        'api-jetu.vercel.app',
        'api/v1/add_balance',
        queryParameters,
      );

      final res = await http.get(url);
    } catch (r) {
      log('error: ${r}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(
        title: "Пополнить баланс",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            TextField(
              style: TextStyle(
                fontSize: 36.sp,
                color: AppColors.black,
              ),
              controller: priceController,
              autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {},
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: ListView(
                children: [
                  InkWell(
                    onTap: () async {
                      await addAmount();
                      SuccessBottomSheet.open(
                        context,
                        done: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: Container(
                      height: 70,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/kaspi_logo.jpg',
                                width: 56,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Kaspi.kz",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () async{
                      await addAmount();
                      SuccessBottomSheet.open(
                        context,
                        done: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: Container(
                      height: 70,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/forte_logo.png',
                                width: 56,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Visa.....3445",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InkWell(
                    onTap: () {
                      context.router.push(
                        const AddCardScreen(),
                      );
                    },
                    child: Container(
                      height: 70,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/add_card_icon.svg',
                                width: 56,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Привязать карту",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessBottomSheet {
  static Future<String?> open(
    BuildContext context, {
    required VoidCallback done,
  }) async {
    return await showMaterialModalBottomSheet(
      context: context,
      expand: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                16,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: context.viewScreen.bottom + 10,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h),
                    Lottie.asset(
                      'assets/lottie/success.json',
                      repeat: false,
                      height: context.sizeScreen.height * 0.2,
                    ),
                    const Text(
                      "Оплата прошла успешно 🎉",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: () {
                        context.router.pushAndPopUntil(
                          const HomeScreen(),
                          predicate: (Route<dynamic> route) => false,
                        );
                      },
                      child: const AppButtonV1(
                        text: "Готов",
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
