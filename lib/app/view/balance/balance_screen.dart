import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/balance/bloc/transaction_cubit.dart';
import 'package:jetu.driver/app/widgets/app_loader.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/graphql_wrapper/query_wrapper.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BalanceScreen extends StatelessWidget {
  final String userId;
  final bool showBackButton;

  const BalanceScreen({
    Key? key,
    required this.userId,
    required this.showBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit(
        client: injection(),
      )..init(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: const Text(
            'Мой баланс',
            style: TextStyle(
              color: AppColors.black,
            ),
          ),
          centerTitle: true,
          leading: showBackButton
              ? GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: AppColors.black,
                  ),
                )
              : null,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QueryWrapper<JetuDriverModel>(
                queryString: JetuAuthQuery.fetchUserInfo(),
                variables: {"userId": userId},
                dataParser: (json) => JetuDriverModel.fromJson(
                  json,
                  name: 'jetu_drivers_by_pk',
                ),
                contentBuilder: (JetuDriverModel data) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: 12.h,
                      bottom: 24.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${data.amount ?? '0.0'} ₸',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (data.amount > 500)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: statusColor('green'),
                                ),
                                child: const Text(
                                  'Вы сможете принимать заказы',
                                ),
                              )
                            else
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: statusColor('red'),
                                    ),
                                    child: const Text(
                                      'Ваш баланс менее 500 ₸\n Пожалуйста, пополните, написав нашему менеджеру',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  GestureDetector(
                                    onTap: () => launchUrl(
                                      Uri.parse(AppConst.whatsAppSupport),
                                    ).then(
                                      (value) =>
                                          Navigator.of(context).pop(false),
                                    ),
                                    child: AppButtonV1(
                                      height: 24.h,
                                      bgColor: AppColors.green,
                                      text: 'Написать Ватсап',
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              Text(
                'История транзакций:',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const AppLoader();
                    }
                    if (state.transactionModel.isEmpty) {
                      return Center(
                        child: Text(
                          'Нет транзакций',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.transactionModel.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactionModel[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${transaction.amount} ₸',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                            ),
                            child: Text(
                              DateFormat('HH:mm, MMM d, yyyy', 'ru')
                                  .format(transaction.createdAt!),
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          trailing: Text(
                            '${transaction.type}',
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'green':
        return AppColors.green.withOpacity(0.2);
      case 'red':
        return AppColors.red.withOpacity(0.2);
      default:
        return AppColors.blue.withOpacity(0.2);
    }
  }
}
