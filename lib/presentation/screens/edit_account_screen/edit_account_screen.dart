import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/presentation/blocs/create_account_bloc/create_account_bloc.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dcs_app/domain/models/account.dart';
import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/presentation/screens/common/custom_text_field.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:get/get.dart';

import '../common/text_button.dart';

part 'widgets/app_bar.dart';

class EditAccountScreenArgument {
  final Account account;

  const EditAccountScreenArgument({
    required this.account,
  });
}

class EditAccountScreen extends StatefulWidget {
  final EditAccountScreenArgument argument;
  const EditAccountScreen({
    super.key,
    required this.argument,
  });

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late TextEditingController _accountNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _usernameController;
  final GlobalKey<FormState> _formKeyAccountName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAccountNumber = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyUsername = GlobalKey<FormState>();
  final FocusNode _focusAccountName = FocusNode();
  final FocusNode _focusAccountNumber = FocusNode();
  final FocusNode _focusUsername = FocusNode();

  @override
  void initState() {
    _accountNameController =
        TextEditingController(text: widget.argument.account.accountName);
    _accountNumberController =
        TextEditingController(text: widget.argument.account.username);
    _usernameController =
        TextEditingController(text: widget.argument.account.username);
    _focusAccountName.addListener(_onFocusAccountName);
    _focusAccountNumber.addListener(_onFocusAccountNumber);
    _focusUsername.addListener(_onFocusUsername);

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

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _usernameController.dispose();
    _focusAccountName.removeListener(_onFocusAccountName);
    _focusAccountNumber.removeListener(_onFocusAccountNumber);
    _focusUsername.removeListener(_onFocusUsername);
    _focusAccountName.dispose();
    _focusAccountNumber.dispose();
    _focusUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAccountBloc, CreateAccountState>(
      listener: (context, state) async {
        if (state is CreateAccountLoading) {
          await LoadingUtils.show();
        } else {
          await LoadingUtils.dismiss();
        }

        if (state is CreateAccountSucceeded) {
          if (mounted) {
            context.read<HomeBloc>().add(HomeInitEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  AppText.editSuccessfully,
                ),
              ),
            );
            Get.offAndToNamed(MyRouter.home);
          }
        } else if (state is CreateAccountFailed) {
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
                  _formKeyUsername.currentState?.validate() == true) {
                context.read<CreateAccountBloc>().add(
                      EditAccountButtonPressedEvent(
                        accountName: _accountNameController.text,
                        accountNumber: _accountNumberController.text,
                        usernameOrEmail: _usernameController.text,
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
                            textInputAction: TextInputAction.next,
                            readOnly: true,
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
