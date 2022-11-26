import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:pinput/pinput.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;
  final String verificationId;

  const VerifyScreen({
    Key? key,
    required this.phone,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.black,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OtpHeader(address: widget.phone),
                SizedBox(
                  height: 68.h,
                  child: Pinput(
                    length: 6,
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    defaultPinTheme: defaultPinTheme,
                    // onCompleted: (code) => context.read<AuthCubit>()
                    //   ..verify(
                    //     context: context,
                    //     verificationId: widget.verificationId,
                    //     code: code,
                    //     phone: widget.phone,
                    //   ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      height: 68.h,
                      width: 64.w,
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  // onTap: () => context.read<AuthCubit>()
                  //   ..verify(
                  //     context: context,
                  //     verificationId: widget.verificationId,
                  //     code: controller.text,
                  //     phone: widget.phone,
                  //   ),
                  child: AppButtonV1(
                    isActive: true,
                    isLoading: state.isLoading,
                    text: 'Отправить',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void login(String code) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: code);
    final UserCredential cr =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final String? firebaseToken = cr.user?.uid;
    // final String firebaseToken = await cr.user!.getIdToken();
    // print('firebaseToken: $firebaseToken ');

    // final QueryResult qe =
    // await runMutation({"firebaseToken": firebaseToken}).networkResult!;

    // print(qe.exception);
    // final String jwt = Login$Mutation.fromJson(qe.data! ).login.jwtToken;
    // final Box box = await Hive.openBox('user');
    // box.put("jwt", jwt);
    // context.read<JWTCubit>().login(jwt);
    if (!mounted) return;
    Navigator.pop(context);
  }
}

class OtpHeader extends StatelessWidget {
  final String address;

  const OtpHeader({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Верификация',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Введите код, отправленный на номер',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black.withOpacity(0.67),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '+7 $address',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.black.withOpacity(0.67),
          ),
        ),
        const SizedBox(height: 64)
      ],
    );
  }
}
