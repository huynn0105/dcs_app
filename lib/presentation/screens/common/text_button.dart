import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.textButton,
  });

  final String textButton;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      icon: Text(textButton,
          style: TextStyleUtils.medium(13).copyWith(
            color: ColorUtils.blue,
          ),
          textAlign: TextAlign.center),
    );
  }
}
