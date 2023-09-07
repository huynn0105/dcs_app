part of '../select_account_screen.dart';

class _AccountItem extends StatelessWidget {
  const _AccountItem({
    required this.accountItem,
  });

  final AccountResponse accountItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Get.toNamed(
                  MyRouter.addAccount,
                  preventDuplicates: false,
                  arguments: AddAccountScreenArgument(
                    id: accountItem.id,
                    accountName: accountItem.name,
                    isRequestAccount: false,
                  ),
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        accountItem.name,
                        style: TextStyleUtils.bold(12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 10.w),
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
