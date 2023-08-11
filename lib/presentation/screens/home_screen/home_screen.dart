import 'dart:io';

import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/presentation/screens/add_account_screen/add_account_screen.dart';
import 'package:dcs_app/presentation/screens/common/custom_button.dart';
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
import 'package:flutter_debouncer/flutter_debouncer.dart';
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
  final Debouncer debouncer = Debouncer();
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    context.read<HomeBloc>().add(HomeInitEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state.loading && state.isDelete) {
          await LoadingUtils.show();
        } else if (state.loading == false && state.isDelete) {
          await LoadingUtils.dismiss();
        }
        if (state.success == true && state.isDelete) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  AppText.deleteSuccessfully,
                ),
              ),
            );
          }
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
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (_, state) {
              if (state.loading == true) {
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: ColorUtils.blue,
                    size: 60.r,
                  ),
                );
              } else if (state.success == false && state.isDelete == false) {
                return Padding(
                  padding: EdgeInsets.only(top: 1.sh / 3),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          AppText.anUnexpectedError,
                          style: TextStyleUtils.medium(14)
                              .copyWith(color: Colors.red),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26.w),
                          child: Text(
                            state.message ?? '',
                            style: TextStyleUtils.regular(12)
                                .copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CustomButton(
                          child: Text(
                            AppText.tryAgain,
                            style: TextStyleUtils.medium(13)
                                .copyWith(color: Colors.white),
                          ),
                          onPressed: () {
                            context.read<HomeBloc>().add(HomeInitEvent());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final accounts = searchController.text.isNotEmpty
                    ? state.accountsSearched
                    : state.accounts;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 16.w,
                        left: 16.w,
                        bottom: 16.h,
                      ),
                      child: _Search(
                        controller: searchController,
                        onChanged: (value) {
                          debouncer.debounce(
                              const Duration(milliseconds: 300),
                              () => context.read<HomeBloc>().add(
                                    SearchEvent(textSearch: value),
                                  ));
                        },
                      ),
                    ),
                    accounts.isNotEmpty
                        ? Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              physics: const BouncingScrollPhysics(),
                              children: [
                                ...accounts
                                    .map((account) => _AccountItem(
                                          account: account,
                                        ))
                                    .toList()
                              ],
                            ),
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 1.sh / 3),
                              child: Text(
                                AppText.noData,
                                style: TextStyleUtils.regular(14),
                              ),
                            ),
                          ),
                  ],
                );
              }
            },
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
