import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/color_utils.dart';
import 'custom_button.dart';

class CustomDialogActionButton {
  final VoidCallback? onPressed;
  final Color btnColor;
  final Color textColor;
  final String text;

  CustomDialogActionButton({
    this.onPressed,
    this.btnColor = ColorUtils.blue,
    this.textColor = Colors.white,
    this.text = '',
  });
}

class CustomDialog extends StatelessWidget {
  final String titleText;
  final Widget? content;
  final List<CustomDialogActionButton> actionButtons;
  final DialogType type;
  final String? icon;

  const CustomDialog({
    Key? key,
    this.titleText = '',
    this.content,
    this.actionButtons = const [],
    this.type = DialogType.error,
    this.icon,
  }) : super(key: key);

  List<Widget> _buildActionButtons() {
    return actionButtons.map((actionButton) {
      return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          child: CustomButton(
            height: 50.h,
            borderRadius: 8.r,
            onPressed: actionButton.onPressed,
            backgroundColor: actionButton.btnColor,
            child: Text(
              actionButton.text,
              style: TextStyleUtils.regular(14)
                  .copyWith(color: actionButton.textColor),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 24.0.h),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Image.asset(
                    icon!,
                    width: 70.w,
                    height: 70.w,
                  )
                : SvgPicture.asset(
                    type == DialogType.error
                        ? 'assets/images/alert_icon.svg'
                        : 'assets/images/sucess_icon.svg',
                  ),
            SizedBox(height: 10.h),
            titleText.isNotEmpty
                ? Text(
                    titleText,
                    style: TextStyleUtils.medium(16).copyWith(
                      color:
                          type == DialogType.error ? Colors.red : Colors.green,
                    ),
                  )
                : const SizedBox.shrink(),
            if (content != null) ...[
              SizedBox(height: 10.h),
              content!,
            ],
            SizedBox(height: 20.h),
            Row(
              children: _buildActionButtons(),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogSimple extends StatelessWidget {
  final String titleText;
  final String bodyText;
  final List<CustomDialogActionButton> actionButtons;
  final DialogType type;
  final String? icon;

  const CustomDialogSimple({
    Key? key,
    this.titleText = '',
    this.bodyText = '',
    required this.actionButtons,
    this.type = DialogType.error,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      titleText: titleText,
      icon: icon,
      type: type,
      content: Text(
        bodyText,
        style: TextStyleUtils.regular(14),
        textAlign: TextAlign.center,
      ),
      actionButtons: actionButtons,
    );
  }
}
