import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MenuSettingScreen extends StatelessWidget {
  const MenuSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        const AssetImage('assets/images/dcs_logo.png'),
                    radius: 30.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locator<AuthRepository>().getUser?.username ?? '',
                          style: TextStyleUtils.bold(15),
                        ),
                        Text(
                          locator<AuthRepository>().email,
                          style: TextStyleUtils.regular(13),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30.r,
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              ListTile(
                leading: SvgPicture.asset('assets/images/edit.svg'),
                title: Text(
                  'Edit profile',
                  style: TextStyleUtils.regular(13),
                ),
              ),
              ListTile(
                leading: SvgPicture.asset('assets/images/manage.svg'),
                title: Text(
                  'Manage',
                  style: TextStyleUtils.regular(13),
                ),
              ),
              ListTile(
                leading: SvgPicture.asset('assets/images/settings.svg'),
                title: Text(
                  'Setting',
                  style: TextStyleUtils.regular(13),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {
                  DialogUtils.showOkCancelDialog(
                      title: AppText.logout,
                      body: AppText.logoutMsg,
                      btnOkText: AppText.logout,
                      onOK: () {
                        context.read<AuthBloc>().add(UserLoggedOut());
                        Get.back();
                        Get.back();
                      });
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    fixedSize: Size(180.w, 55.w),
                    side: const BorderSide(
                      color: ColorUtils.blue,
                    )),
                child: Text(
                  AppText.logout,
                  style: TextStyleUtils.medium(13).copyWith(
                    color: ColorUtils.blue,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
