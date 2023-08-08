import 'package:dcs_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:dcs_app/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:dcs_app/utils/validate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _focusPwd.addListener(_onFocusPwd);
    _focusEmail.addListener(_onFocusEmail);
    context.read<LoginBloc>().add(
          const LoginValidateEvent(
            password: false,
            username: false,
          ),
        );
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
    final authBloc = context.read<AuthBloc>();
    Future.delayed(Duration.zero, () async {
      if (authBloc.state is AuthFailure) {
        await DialogUtils.showOkDialog(
          title: AppText.error,
          body: (authBloc.state as AuthFailure).message,
        );
      }
    });

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state.loading) {
            await LoadingUtils.show();
          } else if (state.loading == false) {
            await LoadingUtils.dismiss();
          }
          if (state.success == false) {
            DialogUtils.showOkDialog(
              type: DialogType.error,
              title: AppText.error,
              body: state.message,
            );
          }
          if (state.success == true) {
            if (mounted) {
              context.read<AuthBloc>().add(AppLoaded());
            }
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height / 4),
                    Image.asset('assets/images/dcs_logo.png'),
                    SizedBox(height: 40.w),
                    SizedBox(
                      height: 120.w,
                      child: Form(
                        key: _formKeyEmail,
                        child: CustomTextField(
                          autofillHints: const [AutofillHints.email],
                          title: AppText.email,
                          controller: _emailController,
                          onFieldSubmitted: (value) {
                            _focusEmail.nextFocus();
                          },
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value?.isNotEmpty == true) {
                              return ValidateUtils.isValidEmail(value!);
                            } else {
                              return AppText.plsEnterEmail;
                            }
                          },
                          onChanged: (_) =>
                              context.read<LoginBloc>().add(LoginValidateEvent(
                                    username: _formKeyEmail.currentState
                                            ?.validate() ==
                                        true,
                                  )),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.w),
                    SizedBox(
                      height: 120.w,
                      child: Form(
                        key: _formKeyPwd,
                        child: CustomTextField(
                          title: AppText.password,
                          autofillHints: const [AutofillHints.password],
                          controller: _passwordController,
                          isPassword: true,
                          onFieldSubmitted: (_) {
                            _focusPwd.nextFocus();
                          },
                          onChanged: (_) =>
                              context.read<LoginBloc>().add(LoginValidateEvent(
                                    password:
                                        _formKeyPwd.currentState?.validate() ==
                                            true,
                                  )),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return  AppText.plsEnterPassword;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.w),
                    BlocBuilder<LoginBloc, LoginState>(builder: (_, state) {
                      return OutlinedButton(
                        onPressed: state.validate
                            ? () {
                                if (_formKeyEmail.currentState?.validate() ==
                                        true &&
                                    _formKeyPwd.currentState?.validate() ==
                                        true) {
                                  context.read<LoginBloc>().add(
                                        LoginWithButtonPressed(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                }
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: state.validate
                              ? ColorUtils.blue
                              : ColorUtils.grey,
                          fixedSize: Size(180.w, 60.h),
                        ),
                        child: Text(
                          AppText.login,
                          style: TextStyleUtils.medium(13).copyWith(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
