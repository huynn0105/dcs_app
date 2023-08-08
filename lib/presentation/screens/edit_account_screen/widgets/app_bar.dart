part of '../edit_account_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80.w,
          child: CustomTextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textButton: AppText.cancel,
          ),
        ),
        Text(
          AppText.editAccount,
          style: TextStyleUtils.bold(16),
        ),
        SizedBox(
          width: 80.w,
          child: CustomTextButton(
            onPressed: onPressed,
            textButton: AppText.done,
          ),
        )
      ],
    );
  }
}
