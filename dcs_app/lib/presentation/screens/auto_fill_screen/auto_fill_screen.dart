import 'package:autofill_service/autofill_service.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AutoFillScreen extends StatefulWidget {
  const AutoFillScreen({super.key});

  @override
  State<AutoFillScreen> createState() => _AutoFillScreenState();
}

class _AutoFillScreenState extends State<AutoFillScreen> {
  bool enabled = false;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      enabled =
          (await AutofillService().status) == AutofillServiceStatus.enabled
              ? true
              : false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AutoFill"),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Android Oreo',
              style: TextStyleUtils.bold(16).copyWith(color: ColorUtils.blue),
            ),
            SizedBox(height: 14.h),
            Text('Autofill', style: TextStyleUtils.medium(14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Save username (recommended)',
                    style: TextStyleUtils.regular(12)),
                Switch(
                    value: enabled,
                    activeTrackColor: ColorUtils.blue,
                    onChanged: (value) async {
                      await AutofillService().requestSetAutofillService();
                      enabled = (await AutofillService().status) ==
                              AutofillServiceStatus.enabled
                          ? true
                          : false;
                      setState(() {});
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
