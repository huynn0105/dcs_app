import 'dart:io';

import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/presentation/screens/add_account_screen/add_account_screen.dart';
import 'package:dcs_app/presentation/screens/edit_account_screen/edit_account_screen.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_utils.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../common/text_button.dart';
part 'widgets/app_bar.dart';
part 'widgets/item.dart';
part 'widgets/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    context.read<HomeBloc>().add(HomeInitEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.success == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.isEdit == true
                    ? AppText.editSuccessfully
                    : AppText.addSuccessfully,
              ),
            ),
          );
        }
        if (state.success == false) {
          DialogUtils.showContinueDialog(
            type: DialogType.error,
            title: AppText.error,
            body: state.message,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: const _AppBar(),
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeInitEvent());
          },
          child: Column(
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (_, state) {
                  if (state.loading == true) {
                    return Padding(
                      padding: EdgeInsets.only(top: 1.sh / 3),
                      child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: ColorUtils.blue,
                          size: 60.r,
                        ),
                      ),
                    );
                  } else {
                    final accounts = searchController.text.isNotEmpty
                        ? state.accountsSearched
                        : state.accounts;
                    return accounts.isNotEmpty
                        ? Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _Search(
                                  controller: searchController,
                                ),
                                SizedBox(height: 20.h),
                                ...accounts
                                    .map((account) => _AccountItem(
                                          account: account,
                                        ))
                                    .toList()
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 30.h),
                            child: Text(
                              AppText.noData,
                              style: TextStyleUtils.regular(14),
                            ),
                          );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: '1',
              onPressed: () {
                context.read<AuthBloc>().add(UserLoggedOut());
              },
              child: const Icon(Icons.logout),
            ),
            const SizedBox(height: 10),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return !state.showChecked
                    ? FloatingActionButton(
                        heroTag: '2',
                        onPressed: () {
                          Get.toNamed(MyRouter.selectCRG);
                        },
                        backgroundColor: ColorUtils.blue,
                        elevation: 0,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(Icons.add),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
