part of '../select_account_screen.dart';

class _RequestNewAccountDialog extends StatelessWidget {
  const _RequestNewAccountDialog({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      scrollable: true,
      insetPadding: EdgeInsets.all(16.r),
      actionsPadding: EdgeInsets.all(16.r),
      title: const Text(AppText.requestNewAccount),
      content: BlocBuilder<SelectAccountBloc, SelectAccountState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                AppText.dscIsContinually,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                title: AppText.accountName,
                controller: controller,
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(AppText.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              final result = context
                  .read<SelectAccountBloc>()
                  .searchAccount(controller.text);
              Navigator.pop(context);
              if (result.isNotEmpty) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return _RequestNewAccountSelect(
                        controller: controller,
                        result: result,
                      );
                    });
              } else {
                Get.toNamed(
                  MyRouter.addAccount,
                  arguments: AddAccountScreenArgument(
                    isRequestAccount: true,
                    accountName: controller.text.trim(),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorUtils.blue,
          ),
          child: const Text(
            AppText.next,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _RequestNewAccountSelect extends StatelessWidget {
  const _RequestNewAccountSelect({
    required this.controller,
    required this.result,
  });

  final TextEditingController controller;
  final List<AccountResponse> result;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      scrollable: true,
      insetPadding: EdgeInsets.all(16.r),
      actionsPadding: EdgeInsets.all(16.r),
      title: const Text(AppText.requestNewAccount),
      content: Column(
        children: [
          CustomTextField(
            title: AppText.accountName,
            controller: controller,
          ),
          const SizedBox(height: 20),
          const Text(
            AppText.weFoundAccount,
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 20),
          ...result.map((e) => _AccountItem(accountItem: e)).toList()
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(AppText.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(
              MyRouter.addAccount,
              preventDuplicates: false,
              arguments: AddAccountScreenArgument(
                accountName: controller.text.trim(),
                isRequestAccount: true,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorUtils.blue,
          ),
          child: const Text(
            AppText.next,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
