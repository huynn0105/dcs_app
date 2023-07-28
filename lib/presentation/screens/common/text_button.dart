import 'package:dcs_app/utils/color_util.dart';
import 'package:dcs_app/utils/text_style_util.dart';
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
      icon: Text(
        textButton,
        style: TextStyleUtil.medium(13).copyWith(
          color: ColorUtil.blue,
        ),
      ),
    );
  }
}
