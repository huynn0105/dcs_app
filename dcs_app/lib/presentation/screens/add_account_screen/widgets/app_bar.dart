part of '../add_account_screen.dart';
class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.onPressed,
    required this.onCancel,
  });
  final VoidCallback onCancel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80.w,
          child: CustomTextButton(
            onPressed: onCancel,
            textButton: AppText.cancel,
          ),
        ),
        Text(
          AppText.addAccount,
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
