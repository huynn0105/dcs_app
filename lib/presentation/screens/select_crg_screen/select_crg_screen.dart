import 'package:dcs_app/data/datasources/dtos/crg_response/crg_response.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/presentation/blocs/select_crg_bloc/select_crg_bloc.dart';
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
part 'widgets/cgr_item.dart';
part 'widgets/dialog.dart';

class SelectCRGScreen extends StatefulWidget {
  const SelectCRGScreen({super.key});

  @override
  State<SelectCRGScreen> createState() => _SelectCRGScreenState();
}

class _SelectCRGScreenState extends State<SelectCRGScreen> {
  late final TextEditingController controller;
  final Debouncer _debouncer = Debouncer();
  @override
  void initState() {
    controller = TextEditingController();
    context.read<SelectCRGBloc>().add(SelectCRGInitEvent());
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
      body:
          BlocBuilder<SelectCRGBloc, SelectCRGState>(builder: (context, state) {
        if (state is SelectCRGLoaded) {
          final List<CRGResponse> listCRG = controller.text.isEmpty
              ? state.listCRGs
              : state.listCRGsSearched.isNotEmpty
                  ? state.listCRGsSearched
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
                          .read<SelectCRGBloc>()
                          .add(SelectCRGSearchEvent(searchQuery: value)),
                    );
                  },
                ),
              ),
              Expanded(
                child: listCRG.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: listCRG.length,
                        itemBuilder: (context, index) {
                          return _CRGItem(crgItem: listCRG[index]);
                        },
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
                                  id: 0,
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
        } else if (state is SelectCRGFailed) {
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
                    context.read<SelectCRGBloc>().add(SelectCRGInitEvent());
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
