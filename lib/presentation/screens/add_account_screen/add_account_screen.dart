import 'package:dcs_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/presentation/screens/common/custom_text_field.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';

import '../common/text_button.dart';

part 'widgets/app_bar.dart';

class AddAccountScreenArgument {
  final String accountName;
  final String? accountType;
  final bool isRequestAccount;

  const AddAccountScreenArgument({
    required this.accountName,
    this.accountType,
    this.isRequestAccount = false,
  });
}

class AddAccountScreen extends StatefulWidget {
  final AddAccountScreenArgument? argument;
  const AddAccountScreen({
    super.key,
    this.argument,
  });

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  late TextEditingController _accountNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  final GlobalKey<FormState> _formKeyAccountName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAccountNumber = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyUsername = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final FocusNode _focusAccountName = FocusNode();
  final FocusNode _focusAccountNumber = FocusNode();
  final FocusNode _focusUsername = FocusNode();
  final FocusNode _focusEmail = FocusNode();

  @override
  void initState() {
    _accountNameController =
        TextEditingController(text: widget.argument?.accountName);
    _accountNumberController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _focusAccountName.addListener(_onFocusAccountName);
    _focusAccountNumber.addListener(_onFocusAccountNumber);
    _focusUsername.addListener(_onFocusUsername);
    _focusEmail.addListener(_onFocusEmail);

    super.initState();
  }

  void _onFocusAccountName() {
    if (!_focusAccountName.hasFocus) {
      _formKeyAccountName.currentState?.validate();
    }
  }

  void _onFocusAccountNumber() {
    if (!_focusAccountNumber.hasFocus) {
      _formKeyAccountNumber.currentState?.validate();
    }
  }

  void _onFocusUsername() {
    if (!_focusUsername.hasFocus) _formKeyUsername.currentState?.validate();
  }

  void _onFocusEmail() {
    if (!_focusEmail.hasFocus) _formKeyEmail.currentState?.validate();
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _focusAccountName.removeListener(_onFocusAccountName);
    _focusAccountNumber.removeListener(_onFocusAccountNumber);
    _focusUsername.removeListener(_onFocusUsername);
    _focusEmail.removeListener(_onFocusUsername);
    _focusAccountName.dispose();
    _focusAccountNumber.dispose();
    _focusUsername.dispose();
    _focusEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) async {
        if (state.loading == true) {
          await LoadingUtils.show();
        } else if (state.loading == false) {
          await LoadingUtils.dismiss();
        }
        if (state.success == true) {
          if (mounted) {
            Navigator.pop(context);
          }
        } else if (state.success == false) {
          DialogUtils.showContinueDialog(
            type: DialogType.error,
            title: AppText.error,
            body: state.message,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: _AppBar(
            onPressed: () {
              if (_formKeyAccountName.currentState?.validate() == true &&
                  _formKeyEmail.currentState?.validate() == true) {
                context.read<HomeBloc>().add(
                      CreateAccountEvent(
                        accountName: _accountNameController.text,
                        accountNumber: _accountNumberController.text,
                        email: _emailController.text,
                        username: _usernameController.text,
                      ),
                    );
              }
            },
          ),
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: ColorUtils.grey,
                        width: 1,
                      ),
                    ),
                    margin: EdgeInsets.all(16.r),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKeyAccountName,
                          child: CustomTextField(
                            title: AppText.accountName,
                            readOnly: widget.argument?.isRequestAccount == true
                                ? false
                                : true,
                            textInputAction: TextInputAction.next,
                            controller: _accountNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppText.plsEnterAccountName;
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          AppText.plsEnterOneOrMore,
                          style: TextStyleUtils.regular(11),
                        ),
                        SizedBox(height: 16.h),
                        Form(
                          key: _formKeyAccountNumber,
                          child: CustomTextField(
                            title: AppText.accountNumber,
                            controller: _accountNumberController,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Form(
                          key: _formKeyUsername,
                          child: CustomTextField(
                            title: AppText.usernameOrEmail,
                            textInputAction: TextInputAction.next,
                            controller: _usernameController,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Form(
                        //   key: _formKeyEmail,
                        //   child: CustomTextField(
                        //     title: 'Email',
                        //     textInputAction: TextInputAction.done,
                        //     textInputType: TextInputType.emailAddress,
                        //     controller: _emailController,
                        //     validator: (value) {
                        //       if (value?.isNotEmpty == true) {
                        //         return ValidateUtils.isValidEmail(value!);
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
