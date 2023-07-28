import 'package:dcs_app/domain/models/portfolio.dart';
import 'package:dcs_app/presentation/providers/home_provider/home_provider.dart';
import 'package:dcs_app/utils/color_util.dart';
import 'package:dcs_app/utils/loading_util.dart';
import 'package:dcs_app/utils/text_style_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../common/text_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider homeProvider;
  @override
  void initState() {
    super.initState();
    homeProvider = context.read<HomeProvider>();
    Future.delayed(Duration.zero, () async {
      await LoadingUtils.show();
      homeProvider.getPortfolios();
      await LoadingUtils.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Portfolio Account',
          style: TextStyleUtil.bold(16),
        ),
        leadingWidth: 70.w,
        leading: Selector<HomeProvider, bool>(
            selector: (context, homeProvider) => homeProvider.showChecked,
            builder: (_, value, __) {
              return value
                  ? CustomTextButton(
                      onPressed: () {
                        homeProvider.showChecked = false;
                        homeProvider.clearPortfoliosSelected();
                      },
                      textButton: 'Cancel')
                  : CustomTextButton(
                      onPressed: () async {
                        final accounts = await homeProvider.syncAccount();
                        if (accounts.isNotEmpty) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    Consumer<HomeProvider>(
                                      builder: (context, homeProvider, __) {
                                        return ElevatedButton(
                                            onPressed: homeProvider
                                                    .portfoliosSelected.isEmpty
                                                ? null
                                                : () {
                                                    homeProvider
                                                        .addAccountSyncToPortfolio();
                                                    Navigator.pop(context);
                                                  },
                                            child: const Text('OK'));
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        homeProvider.clearPortfoliosSelected();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                  title: const Text('Accounts'),
                                  content: Container(
                                    width: double.maxFinite,
                                    constraints: BoxConstraints(
                                      maxHeight: 600.h,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: accounts
                                          .map((e) => _Item(account: e))
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'All accounts have been synchronized',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      textButton: 'Sync',
                    );
            }),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        actions: [
          Selector<HomeProvider, bool>(
              selector: (_, homeProvder) => homeProvder.showChecked,
              builder: (_, value, __) {
                return value
                    ? CustomTextButton(
                        onPressed: () {
                          context.read<HomeProvider>().deletePortfolio();
                        },
                        textButton: 'Delete',
                      )
                    : CustomTextButton(
                        onPressed: () {
                          context.read<HomeProvider>().showChecked = true;
                        },
                        textButton: 'Select',
                      );
              }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(CupertinoIcons.search),
                hintText: 'Search',
                hintStyle: TextStyleUtil.regular(13).copyWith(
                  color: const Color(0xFF969696),
                ),
                isDense: true,
                filled: true,
                focusColor: ColorUtil.blue,
                fillColor: const Color(0xFFEFEFEF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Consumer<HomeProvider>(builder: (_, vm, __) {
            return Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  right: 16.w,
                  left: 16.w,
                ),
                itemBuilder: (context, index) => _PortfolioItem(
                  portfolio: vm.portfolios[index],
                ),
                itemCount: vm.portfolios.length,
                separatorBuilder: (_, __) => SizedBox(
                  height: 10.h,
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: Selector<HomeProvider, bool>(
        selector: (_, homeProvider) => homeProvider.showChecked,
        builder: (context, value, _) {
          return !value
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: ColorUtil.blue,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Icon(Icons.add),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.account,
  });

  final Portfolio account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<HomeProvider>().selectPortfolio(account);
            },
            icon: Consumer<HomeProvider>(builder: (_, homeProvider, __) {
              return Icon(
                homeProvider.portfoliosSelected.contains(account)
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_off,
                color: ColorUtil.blue,
              );
            }),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorUtil.grey,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountType,
                    style: TextStyleUtil.bold(13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    account.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleUtil.regular(12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  const _PortfolioItem({
    required this.portfolio,
  });

  final Portfolio portfolio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Selector<HomeProvider, bool>(
            selector: (_, homeProvider) => homeProvider.showChecked,
            builder: (_, value, __) {
              return value
                  ? IconButton(
                      onPressed: () {
                        context.read<HomeProvider>().selectPortfolio(portfolio);
                      },
                      icon: Consumer<HomeProvider>(
                        builder: (_, homeProvider, __) {
                          return Icon(
                            homeProvider.portfoliosSelected.contains(portfolio)
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_off,
                            color: ColorUtil.blue,
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink();
            }),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorUtil.grey,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolio.accountType,
                      style: TextStyleUtil.bold(13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      portfolio.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleUtil.regular(12),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
