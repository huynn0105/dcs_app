part of '../select_crg_screen.dart';

class _CRGItem extends StatelessWidget {
  const _CRGItem({
    required this.crgItem,
  });

  final CRGResponse crgItem;

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
                    id: crgItem.id,
                    accountName: crgItem.name,
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
                        crgItem.name,
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
