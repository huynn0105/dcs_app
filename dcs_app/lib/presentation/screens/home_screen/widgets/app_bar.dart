part of '../home_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 95.w,
          child: BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
            return state.showChecked
                ? CustomTextButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(ToggleShowCheckEvent());
                      context
                          .read<HomeBloc>()
                          .add(ClearSelectedAccountsEvent());
                    },
                    textButton: AppText.cancel,
                  )
                : Row(
                    children: [
                      SizedBox(width: 5.w),
                      IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.menu)),
                      // Platform.isAndroid
                      //     ? CustomTextButton(
                      //         onPressed: () async {
                      //           if (Platform.isAndroid) {
                      //             await _syncAllAccounts(context);
                      //           }
                      //         },
                      //         textButton: AppText.sync,
                      //       )
                      //     : const SizedBox.shrink(),
                    ],
                  );
          }),
        ),
        Text(
          AppText.portfolioAccount,
          style: TextStyleUtils.bold(16),
        ),
        SizedBox(
          width: 92.w,
          child: BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
            return state.accounts.isNotEmpty
                ? state.showChecked
                    ? CustomTextButton(
                        onPressed: () {
                          if (state.accountsSelected.isEmpty) {
                            context
                                .read<HomeBloc>()
                                .add(ToggleShowCheckEvent());
                          } else {
                            DialogUtils.showOkCancelDialog(
                                title: AppText.confirm,
                                body: AppText.confirmMsg,
                                onOK: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(const AccountDeletedEvent());
                                  Navigator.pop(context);
                                });
                          }
                        },
                        textButton: AppText.delete,
                      )
                    : CustomTextButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(ToggleShowCheckEvent());
                        },
                        textButton: AppText.select,
                      )
                : const SizedBox.shrink();
          }),
        ),
      ],
    );
  }

  // Future<void> _selectAccount(BuildContext context) async {
  //   await LoadingUtils.show();
  //   if (context.mounted) {
  //     await context.read<HomeBloc>().pickAccount(
  //       (call) async {
  //         if (call.method == 'account') {
  //           if (call.arguments != null) {
  //             Get.toNamed(
  //               MyRouter.addAccount,
  //               arguments: AddAccountScreenArgument(
  //                 id: 0,
  //                 accountName: call.arguments['account_name'],
  //                 usernameOrEmail: call.arguments['account_type'],
  //               ),
  //             );
  //           }
  //         }
  //       },
  //     );
  //   }
  //   await LoadingUtils.dismiss();
  // }

  // Future<void> _syncAllAccounts(BuildContext context) async {
  //   await LoadingUtils.show();
  //   if (context.mounted) {
  //     final accounts = await context.read<HomeBloc>().syncAccounts();

  //     await LoadingUtils.dismiss();
  //     if (accounts.isNotEmpty) {
  //       if (context.mounted) {
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               actions: [
  //                 BlocBuilder<HomeBloc, HomeState>(
  //                   builder: (context, state) {
  //                     return ElevatedButton(
  //                       onPressed: state.accountsSelected.isEmpty
  //                           ? null
  //                           : () {
  //                               context.read<HomeBloc>().add(
  //                                     AddAccountSyncToAccountsEvent(),
  //                                   );
  //                             },
  //                       child: const Text(AppText.ok),
  //                     );
  //                   },
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     context
  //                         .read<HomeBloc>()
  //                         .add(ClearSelectedAccountsEvent());
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text(AppText.cancel),
  //                 ),
  //               ],
  //               title: const Text(AppText.accounts),
  //               content: Container(
  //                 width: double.maxFinite,
  //                 constraints: BoxConstraints(
  //                   maxHeight: 600.h,
  //                 ),
  //                 child: ListView(
  //                   shrinkWrap: true,
  //                   children: accounts.map((e) => _Item(account: e)).toList(),
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text(
  //               AppText.allSync,
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context
                      .read<HomeBloc>()
                      .add(AccountSelectedEvent(account: account));
                },
                icon: Icon(state.accountsSelected.contains(account)
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_off),
                color: ColorUtils.blue,
              );
            },
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorUtils.grey,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.accountName,
                    style: TextStyleUtils.bold(13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    account.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleUtils.regular(12),
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
