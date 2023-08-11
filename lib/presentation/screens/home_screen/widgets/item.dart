part of '../home_screen.dart';

class _AccountItem extends StatelessWidget {
  const _AccountItem({
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
            return state.showChecked
                ? IconButton(
                    onPressed: () {
                      context
                          .read<HomeBloc>()
                          .add(AccountSelectedEvent(account: account));
                    },
                    icon: BlocBuilder<HomeBloc, HomeState>(
                      builder: (_, state) {
                        return Icon(
                          state.accountsSelected.contains(account)
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_off,
                          color: ColorUtils.blue,
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink();
          }),
          Expanded(
            child: InkWell(
              onTap: () {
                Get.toNamed(
                  MyRouter.editAccount,
                  arguments: EditAccountScreenArgument(account: account),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorUtils.grey,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 13.h),
                child: Row(
                  children: [
                    Expanded(
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
                            account.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleUtils.regular(12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
