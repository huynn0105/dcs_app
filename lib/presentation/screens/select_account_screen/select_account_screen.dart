import 'package:dcs_app/data/datasources/dtos/account_response/account_response.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/presentation/blocs/select_account_bloc/select_account_bloc.dart';
import 'package:dcs_app/presentation/screens/add_account_screen/add_account_screen.dart';
import 'package:dcs_app/presentation/screens/common/custom_button.dart';
import 'package:dcs_app/presentation/screens/common/custom_text_field.dart';
import 'package:dcs_app/presentation/screens/common/text_button.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

part 'widgets/app_bar.dart';
part 'widgets/search.dart';
part 'widgets/account_item.dart';
part 'widgets/dialog.dart';

class SelectAccountScreen extends StatefulWidget {
  const SelectAccountScreen({super.key});

  @override
  State<SelectAccountScreen> createState() => _SelectAccountScreenState();
}

class _SelectAccountScreenState extends State<SelectAccountScreen> {
  late final TextEditingController controller;
  final Debouncer _debouncer = Debouncer();
  @override
  void initState() {
    controller = TextEditingController();
    context.read<SelectAccountBloc>().add(SelectAccountInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: _AppBar(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final TextEditingController controller =
                    TextEditingController();
                return _RequestNewAccountDialog(controller: controller);
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocBuilder<SelectAccountBloc, SelectAccountState>(
          builder: (context, state) {
        if (state is SelectAccountLoaded) {
          final List<AccountResponse> listAccount = controller.text.isEmpty
              ? state.listAccounts
              : state.listAccountsSearched.isNotEmpty
                  ? state.listAccountsSearched
                  : [];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 16.w,
                  left: 16.w,
                  bottom: 16.h,
                ),
                child: _Search(
                  controller: controller,
                  onChanged: (value) {
                    _debouncer.debounce(
                      const Duration(milliseconds: 300),
                      () => context
                          .read<SelectAccountBloc>()
                          .add(SelectAccountSearchEvent(searchQuery: value.trim())),
                    );
                  },
                ),
              ),
              Expanded(
                child: listAccount.isNotEmpty
                    ? RefreshIndicator(
                        onRefresh: () async {
                          controller.clear();
                          context
                              .read<SelectAccountBloc>()
                              .add(SelectAccountInitEvent(isRefresh: true));
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: listAccount.length,
                          itemBuilder: (context, index) {
                            return _AccountItem(
                                accountItem: listAccount[index]);
                          },
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            AppText.thereAreNoAccounts,
                            style: TextStyleUtils.regular(13)
                                .copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppText.toAddAnUnlisted,
                            style: TextStyleUtils.regular(13)
                                .copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(
                                MyRouter.addAccount,
                                arguments: AddAccountScreenArgument(
                                  accountName: controller.text.trim(),
                                  isRequestAccount: true,
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: ColorUtils.blue,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 12.h,
                              ),
                            ),
                            child: Text(
                              AppText.requestNewAccount,
                              style: TextStyleUtils.medium(13).copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
              )
            ],
          );
        } else if (state is SelectAccountFailed) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppText.anUnexpectedError,
                  style: TextStyleUtils.medium(14).copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: Text(
                    state.message,
                    style:
                        TextStyleUtils.regular(12).copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  child: Text(
                    AppText.tryAgain,
                    style:
                        TextStyleUtils.medium(13).copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    context
                        .read<SelectAccountBloc>()
                        .add(SelectAccountInitEvent());
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: ColorUtils.blue,
              size: 60.r,
            ),
          );
        }
      }),
    );
  }
}
