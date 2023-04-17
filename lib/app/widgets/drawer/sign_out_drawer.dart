import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SignOutDrawer extends StatelessWidget {
  const SignOutDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(Ionicons.log_out_outline),
            minLeadingWidth: 20.0,
            title: Text(
              'Войти',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => context.router.push(
              const LoginScreen(),
            ),
          ),
          const Spacer(),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(
              Ionicons.document_outline,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'Политика конфиденциальности',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () =>
                launchUrl(Uri.parse('http://eduu.tilda.ws/privacy_policy')),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(
              Ionicons.information,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'О нас',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () =>
                launchUrl(Uri.parse('https://instagram.com/hacker.atyrau')),
          ),
          ListTile(
            iconColor: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: const Icon(
              Ionicons.help_outline,
            ),
            minLeadingWidth: 20.0,
            title: Text(
              'Служба поддержки',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () => launchUrl(
              Uri.parse('whatsapp://send?phone=77058895658'),
            ),
          ),
        ],
      ),
    );
  }
}
