import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/verification/bloc/verification_cubit.dart';
import 'package:jetu.driver/app/widgets/app_loader.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

class UploadPhoto extends StatelessWidget {
  const UploadPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        title: Text(
          'Загрузка фото',
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0.w,
        ),
        child: SingleChildScrollView(
          child: BlocConsumer<VerificationCubit, VerificationState>(
            listener: (context, state) async {
              if (state.success) {
                await context.router.pushAndPopUntil(
                  WriteUsScreen(phone: state.phone, checkStatus: true),
                  predicate: (Route<dynamic> route) => false,
                );
              }

              if (state.isLoading) {
                context.loaderOverlay.show(
                  widget: const AppOverlayLoader(),
                );
              }

              if (!state.isLoading) {
                context.loaderOverlay.hide();
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  UploadPhotoItem(
                    text: '1. Фото водительского удостоверения',
                    examplePhotoUrl:
                        'https://photos-kl.kcdn.kz/kolesa-read/2019/10/07/new-dr-license-1-1-full.jpg',
                    selectedFile: (file) =>
                        context.read<VerificationCubit>().setImage1(
                              file,
                            ),
                  ),
                  UploadPhotoItem(
                    text: '2. Фото тех паспорта автомобиля',
                    examplePhotoUrl:
                        'https://avatars.dzeninfra.ru/get-zen_doc/62191/pub_5ba203c0c071d300ab518e24_5ba203d84b69b700aa90818a/scale_1200',
                    selectedFile: (file) =>
                        context.read<VerificationCubit>().setImage2(
                              file,
                            ),
                  ),
                  UploadPhotoItem(
                    text: '3. Селфи с водительским удостоверением',
                    examplePhotoUrl:
                        'https://mintra.com/assets/documents/photo-id.jpg',
                    selectedFile: (file) =>
                        context.read<VerificationCubit>().setImage3(
                              file,
                            ),
                  ),
                  SizedBox(height: 24.h),
                  GestureDetector(
                    onTap: () async {
                      if (state.image1 != null &&
                          state.image2 != null &&
                          state.image3 != null) {
                        context.read<VerificationCubit>().sendData();
                      }
                    },
                    child: AppButtonV1(
                      isActive: state.image1 != null &&
                          state.image2 != null &&
                          state.image3 != null,
                      text: 'Отправить на проверку',
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class UploadPhotoItem extends StatefulWidget {
  final String text;
  final String examplePhotoUrl;
  final Function(File?) selectedFile;

  UploadPhotoItem({
    Key? key,
    required this.text,
    required this.examplePhotoUrl,
    required this.selectedFile,
  }) : super(key: key);

  @override
  State<UploadPhotoItem> createState() => _UploadPhotoItemState();
}

class _UploadPhotoItemState extends State<UploadPhotoItem> {
  final ImagePicker picker = ImagePicker();

  File? imageFile;

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(source: source, maxWidth: 1920);
      if (pickedImage == null) return;
      final String fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);
      setState(() {});
      widget.selectedFile.call(imageFile);
      //await _uploadImage(fileName, imageFile);
    } catch (err) {
      log('err: $err');
    }
  }

  showImageSelectionBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(16.r),
          right: Radius.circular(16.r),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Выберите способ добавления фото",
                ),
                SizedBox(height: 20.h),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  title: const Text("Сфотографировать"),
                  trailing: const Icon(Icons.photo_camera_outlined),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  title: const Text("Загрузить из галереи"),
                  trailing: const Icon(Icons.photo_library_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        photoType(
          widget.text,
          examplePhotoUrl: widget.examplePhotoUrl,
          isUploaded: imageFile != null,
        ),
        pickPhotoArea(context),
      ],
    );
  }

  Widget pickPhotoArea(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(16.r),
          color: AppColors.black,
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            height: context.sizeScreen.width * 0.3,
            width: context.sizeScreen.width * 0.6,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  )
                : TextButton(
                    onPressed: () => showImageSelectionBottomSheet(context),
                    child: const Text('Загрузить'),
                  ),
          ),
        ),
      ),
    );
  }

  Widget photoType(
    String text, {
    required String examplePhotoUrl,
    bool isUploaded = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        if (!isUploaded)
          TextButton(
            onPressed: () => launchUrl(
              Uri.parse(examplePhotoUrl),
            ),
            child: const Text('См. пример'),
          )
        else
          TextButton(
            onPressed: () {
              setState(
                () => imageFile = null,
              );
              widget.selectedFile.call(imageFile);
            },
            child: const Text(
              "Удалить",
              style: TextStyle(
                color: AppColors.red,
              ),
            ),
          )
      ],
    );
  }
}
