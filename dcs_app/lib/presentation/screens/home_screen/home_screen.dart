import 'dart:io';

import 'package:autofill_service/autofill_service.dart';
import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/data/datasources/local/database_constants.dart';
import 'package:dcs_app/data/datasources/local/database_manager.dart';
import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/domain/repositories/auth_repository.dart';
import 'package:dcs_app/global/locator.dart';
import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/presentation/screens/add_account_screen/add_account_screen.dart';
import 'package:dcs_app/presentation/screens/common/custom_button.dart';
import 'package:dcs_app/presentation/screens/edit_account_screen/edit_account_screen.dart';
import 'package:dcs_app/presentation/screens/menu_setting_screen/menu_setting_screen.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_utils.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../common/text_button.dart';
part 'widgets/app_bar.dart';
part 'widgets/item.dart';
part 'widgets/search.dart';
part 'widgets/account_response_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late TextEditingController searchController;
  final Debouncer debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    searchController = TextEditingController();
    context.read<HomeBloc>().add(HomeInitEvent());
    context.read<HomeBloc>().add(OnSaveAccountEvent());
    Future.delayed(Duration.zero, () async {
      final autofillRequest = (await AutofillService().status);
      final firstAutofiillRequest =
          DatabaseManager.readData(DatabaseConstant.autofiillRequest);
      if (autofillRequest == AutofillServiceStatus.disabled &&
          firstAutofiillRequest != true) {
        await DatabaseManager.saveData(DatabaseConstant.autofiillRequest, true);
        await DialogUtils.showOkCancelDialog(
            icon: "assets/images/dcs_logo.png",
            body:
                " Please enable DCS Service to save the username and account domain to my DCS Portfolio Accounts.",
            onOK: () async {
              Get.back();
              await AutofillService().requestSetAutofillService();
            });
      }

      if (Platform.isIOS) {
        sendDataToIOS();
      }
    });
  }

  void sendDataToIOS() {
    try {
      const platform = MethodChannel('com.app.DCSPortfolioPlus');
      final userData = locator<AuthRepository>().getUser!.toMap();
      platform.invokeMethod('sendUserDataToIOS', userData);
    } on PlatformException catch (e) {
      debugPrint("Error: ${e.message}");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    debouncer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<HomeBloc>().add(OnSaveAccountEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state.loading && (state.isDelete || state.isSave)) {
          await LoadingUtils.show();
        } else if (state.loading == false && (state.isDelete || state.isSave)) {
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

        if (state.success == true && state.isSave) {
          if (mounted) {
            if (state.accountsResponse.isNotEmpty) {
              if (state.accountsResponse.length == 1) {
                final account = state.accountsResponse.first;
                Get.toNamed(
                  MyRouter.addAccount,
                  arguments: AddAccountScreenArgument(
                    id: account.id,
                    accountName: account.name,
                    usernameOrEmail: state.usernameOrEmail ?? '',
                    isRequestAccount: false,
                  ),
                );
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        scrollable: true,
                        insetPadding: EdgeInsets.all(16.r),
                        actionsPadding: EdgeInsets.all(16.r),
                        title: const Text(AppText.selectAccount),
                        content: Column(
                          children: state.accountsResponse
                              .map((account) => _AccountItem(
                                    accountItem: account,
                                    onTap: () {
                                      Get.toNamed(
                                        MyRouter.addAccount,
                                        preventDuplicates: false,
                                        arguments: AddAccountScreenArgument(
                                          id: account.id,
                                          accountName: account.name,
                                          usernameOrEmail:
                                              state.usernameOrEmail ?? '',
                                          isRequestAccount: false,
                                        ),
                                      );
                                    },
                                  ))
                              .toList(),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(AppText.cancel),
                          ),
                        ],
                      );
                    });
              }
            } else {
              Get.toNamed(
                MyRouter.addAccount,
                arguments: AddAccountScreenArgument(
                  accountName: state.domain ?? '',
                  usernameOrEmail: state.usernameOrEmail ?? '',
                  isRequestAccount: true,
                ),
              );
            }
          }
          await AutofillService().onSaveComplete();
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
        drawer: Drawer(
          width: MediaQuery.of(context).size.width,
          shape: const RoundedRectangleBorder(),
          child: const MenuSettingScreen(),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeInitEvent());
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (_, state) {
              if (state.loading == true && !state.isDelete) {
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
                                    SearchEvent(textSearch: value.trim()),
                                  ));
                        },
                      ),
                    ),
                    accounts.isNotEmpty
                        ? Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                ...accounts
                                    .map((account) => _ClientAccountItem(
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
        floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return !state.showChecked
                ? FloatingActionButton(
                    onPressed: () {
                      Get.toNamed(MyRouter.selectAccount);
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
      ),
    );
  }
}
