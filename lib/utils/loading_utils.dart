import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingUtils {
  static Future<void> show() async {
    if (!EasyLoading.isShow) {
      await EasyLoading.show(maskType: EasyLoadingMaskType.black);
    }
  }

  static Future<void> dismiss() async {
    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
  }
}
