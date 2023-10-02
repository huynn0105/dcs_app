import 'package:dcs_app/presentation/screens/common/custom_dialog.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'color_utils.dart';
import 'enum.dart';

class DialogUtils {
  static Future<void> showYesNoDialog({
    required String title,
    required VoidCallback onYes,
    String? body,
    VoidCallback? onNo,
    bool barrierDismissible = false,
  }) async {
    onNo = onNo ?? Get.back;
    await Get.dialog(AlertDialog(
      title: Text(
        title,
        style: TextStyleUtils.medium(14).copyWith(
          color: Colors.black,
        ),
      ),
      content: body != null
          ? Text(body,
              style: TextStyleUtils.medium(14).copyWith(
                color: Colors.black,
              ))
          : null,
      titleTextStyle: TextStyleUtils.bold(16).copyWith(
        color: Colors.black,
      ),
      contentTextStyle: TextStyleUtils.regular(16).copyWith(
        color: Colors.black,
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      actionsPadding: EdgeInsets.all(8.r),
      actions: [
        ElevatedButton(
          onPressed: onNo,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            minimumSize: Size(72.w, 36.h),
          ),
          child: Text(
            AppText.no,
            style: TextStyleUtils.regular(14).copyWith(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            onYes();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(72.w, 36.h),
            backgroundColor: ColorUtils.blue,
          ),
          child: Text(
            AppText.yes,
            style: TextStyleUtils.regular(14).copyWith(color: Colors.white),
          ),
        ),
      ],
    ));
  }

  static Future<void> showOkCancelDialog({
    String? title,
    String? body,
    VoidCallback? onOK,
    VoidCallback? onCancel,
    String? btnOkText,
    String? btnNoText,
    bool barrierDismissible = false,
    DialogType type = DialogType.error,
    String? icon,
  }) async {
    onOK = onOK ?? () => {Get.back()};
    onCancel = onCancel ?? () => {Get.back()};
    await Get.dialog(
      CustomDialogSimple(
        type: type,
        icon: icon,
        titleText: title ?? '',
        bodyText: body ?? '',
        actionButtons: [
          CustomDialogActionButton(
            btnColor: ColorUtils.greyAccent,
            textColor: Colors.white,
            text: btnNoText ?? AppText.cancel,
            onPressed: onCancel,
          ),
          CustomDialogActionButton(
            textColor: Colors.white,
            text: btnOkText ?? AppText.ok,
            onPressed: onOK,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showOkDialog({
    String? title,
    String? body,
    VoidCallback? onOK,
    bool barrierDismissible = false,
    DialogType type = DialogType.error,
  }) async {
    onOK ??= () => {Get.back()};

    await Get.dialog(
      CustomDialogSimple(
        type: type,
        titleText: title ?? "",
        bodyText: body ?? "",
        actionButtons: [
          CustomDialogActionButton(
            btnColor: ColorUtils.blue,
            textColor: Colors.white,
            text: AppText.ok,
            onPressed: onOK,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showRetryDialog({
    String? title,
    String? body,
    VoidCallback? onRetry,
    bool barrierDismissible = false,
  }) async {
    onRetry ??= () => {Get.back()};

    await Get.dialog(
      CustomDialogSimple(
        titleText: title ?? '',
        bodyText: body ?? '',
        actionButtons: [
          CustomDialogActionButton(
            textColor: Colors.white,
            text: AppText.retry,
            onPressed: onRetry,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showContinueDialog({
    String? title,
    String? body,
    VoidCallback? onOK,
    bool barrierDismissible = false,
    DialogType type = DialogType.error,
  }) async {
    onOK ??= () => {Get.back()};

    await Get.dialog(
      CustomDialogSimple(
        type: type,
        titleText: title ?? '',
        bodyText: body ?? '',
        actionButtons: [
          CustomDialogActionButton(
            textColor: Colors.white,
            text: AppText.lblContinue,
            onPressed: onOK,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<void> showContinueGoBackDialog({
    String? title,
    String? body,
    VoidCallback? onOK,
    VoidCallback? onCancel,
    bool barrierDismissible = false,
    DialogType type = DialogType.error,
  }) async {
    onOK = onOK ?? () => {Get.back()};
    onCancel = onCancel ?? () => {Get.back()};

    await Get.dialog(
      CustomDialogSimple(
        type: type,
        titleText: title ?? '',
        bodyText: body ?? '',
        actionButtons: [
          CustomDialogActionButton(
            btnColor: ColorUtils.greyAccent,
            textColor: Colors.white,
            text: AppText.back,
            onPressed: onCancel,
          ),
          CustomDialogActionButton(
            textColor: Colors.white,
            text: AppText.lblContinue,
            onPressed: onOK,
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
