import 'package:dcs_app/presentation/providers/login_provider/login_provider.dart';
import 'package:dcs_app/utils/color_util.dart';
import 'package:dcs_app/utils/dialog_util.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_util.dart';
import 'package:dcs_app/utils/text_style_util.dart';
import 'package:dcs_app/utils/validate_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  final GlobalKey<FormState> _formKeyPwd = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final FocusNode _focusPwd = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  late LoginProvider loginProvider;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _focusPwd.addListener(_onFocusPwd);
    _focusEmail.addListener(_onFocusEmail);
    loginProvider = context.read<LoginProvider>();
    super.initState();
  }

  void _onFocusPwd() {
    if (!_focusPwd.hasFocus) _formKeyPwd.currentState?.validate();
  }

  void _onFocusEmail() {
    if (!_focusEmail.hasFocus) _formKeyEmail.currentState?.validate();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _focusPwd.removeListener(_onFocusPwd);
    _focusEmail.removeListener(_onFocusEmail);
    _focusPwd.dispose();
    _focusEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: AutofillGroup(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height / 4),
                Image.asset('assets/images/dcs_logo.png'),
                SizedBox(height: 40.w),
                Form(
                  key: _formKeyEmail,
                  child: CustomTextField(
                    autofillHints: const [AutofillHints.email],
                    title: 'Email',
                    controller: _emailController,
                    validator: (value) {
                      if (value?.isNotEmpty == true) {
                        return ValidateUtil.isValidEmail(value!);
                      } else {
                        return 'Please enter email';
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.w),
                Form(
                  key: _formKeyPwd,
                  child: CustomTextField(
                    title: 'Password',
                    autofillHints: const [AutofillHints.password],
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 40.w),
                OutlinedButton(
                  onPressed: () async {
                    if (_formKeyEmail.currentState?.validate() == true &&
                        _formKeyPwd.currentState?.validate() == true) {
                      await LoadingUtils.show();
                      final result = await loginProvider.login(
                          _emailController.text, _passwordController.text);
                      await LoadingUtils.dismiss();
                      if (result) {
                        DialogUtils.showOkDialog(
                          type: DialogType.success,
                          title: 'Login Successfuly',
                        );
                      } else {
                        DialogUtils.showOkDialog(
                            type: DialogType.error, title: 'Login Failed');
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ColorUtil.blue,
                    fixedSize: Size(180.w, 60.h),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyleUtil.medium(13).copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
