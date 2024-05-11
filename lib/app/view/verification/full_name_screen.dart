import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/verification/bloc/verification_cubit.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/text_field_input.dart';

class FullNameScreen extends StatefulWidget {
  const FullNameScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FullNameScreen> createState() => _FullNameScreenState();
}

class _FullNameScreenState extends State<FullNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _carController = TextEditingController();
  final TextEditingController _carColorController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(updateState);
    _surnameController.addListener(updateState);
    _carController.addListener(updateState);
    _carColorController.addListener(updateState);
    _carNumberController.addListener(updateState);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _surnameController.dispose();
    _nameController.dispose();
    _carController.dispose();
    _carColorController.dispose();
    _carNumberController.dispose();
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          'Информация о вас',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18.sp,
          ),
        ),
        leading: GestureDetector(
          onTap: () => context.router.pop(),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.black,
          ),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0.w,
            ),
            child: ListView(children: [
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                  ),
                  child: Text(
                    'Обезательно',
                    style: TextStyle(
                      color: AppColors.black.withOpacity(0.67),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: TextFieldInput(
                      hintText: 'Имя',
                      textInputType: TextInputType.text,
                      textEditingController: _nameController,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: TextFieldInput(
                      hintText: 'Фамилия',
                      textInputType: TextInputType.text,
                      textEditingController: _surnameController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: TextFieldInput(
                      hintText: 'Машина',
                      textInputType: TextInputType.text,
                      textEditingController: _carController,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: TextFieldInput(
                      hintText: 'Цвет машины',
                      textInputType: TextInputType.text,
                      textEditingController: _carColorController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              TextFieldInput(
                hintText: 'Номер машины',
                textInputType: TextInputType.text,
                textEditingController: _carNumberController,
                align: TextAlign.center,
              ),
              SizedBox(height: 36.h),
              GestureDetector(
                onTap: () {
                  final userInfo = {
                    "name": _nameController.text,
                    "surname": _surnameController.text,
                    "car_model": _carController.text,
                    "car_color": _carColorController.text,
                    "car_number": _carNumberController.text,
                  };
                  context.read<VerificationCubit>().setUserInfo(userInfo);
                  context.router.popAndPush(
                    const UploadPhoto(),
                  );
                },
                child: AppButtonV1(
                  isActive: _nameController.text.isNotEmpty &&
                      _surnameController.text.isNotEmpty &&
                      _carController.text.isNotEmpty &&
                      _carColorController.text.isNotEmpty &&
                      _carNumberController.text.isNotEmpty,
                  isLoading: state.isLoading,
                  text: 'Cледующий',
                ),
              ),
              SizedBox(height: 12.h),
            ]),
          );
        },
      ),
    );
  }
}
