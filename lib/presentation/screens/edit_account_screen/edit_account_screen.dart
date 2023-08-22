import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';
import 'package:dcs_app/data/datasources/dtos/update_client_account/update_client_account_dto.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/presentation/blocs/account_detail_bloc/account_detail_bloc.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/validate_utils.dart';
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
  late TextEditingController _accountNameController,
      _accountNumberController,
      _usernameController,
      _nicknameController;

  final GlobalKey<FormState> _formKeyAccountName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAccountNumber = GlobalKey<FormState>();
  final FocusNode _focusAccountName = FocusNode();
  final FocusNode _focusAccountNumber = FocusNode();
  final FocusNode _focusUsername = FocusNode();
  late Account account;
  @override
  void initState() {
    account = widget.argument.account;
    _accountNameController = TextEditingController(text: account.accountName);
    _accountNumberController = TextEditingController();
    _nicknameController = TextEditingController(text: account.username);
    _usernameController = TextEditingController(text: account.username);
    _focusAccountName.addListener(_onFocusAccountName);
    _focusAccountNumber.addListener(_onFocusAccountNumber);
    context
        .read<AccountDetailBloc>()
        .add(AccountDetailInitEvent(account: account));
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

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _usernameController.dispose();
    _nicknameController.dispose();
    _focusAccountName.removeListener(_onFocusAccountName);
    _focusAccountNumber.removeListener(_onFocusAccountNumber);
    _focusAccountName.dispose();
    _focusAccountNumber.dispose();
    _focusUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountDetailBloc, AccountDetailState>(
      listener: (context, state) async {
        if (state.loading) {
          await LoadingUtils.show();
        } else {
          await LoadingUtils.dismiss();
        }

        if (state.success == true) {
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
        } else if (state.success == false &&
            state.message?.isNotEmpty == true) {
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
          title: BlocBuilder<AccountDetailBloc, AccountDetailState>(
            builder: (context, state) {
              return _AppBar(
                onPressed: () {
                  if (account.isRequest) {
                    if (_validateRequestAccount()) {
                      context.read<AccountDetailBloc>().add(
                            RequestAccountDetailUpdateEvent(
                              id: account.id,
                              accountNumber: _accountNameController.text.trim(),
                              username: _usernameController.text.trim(),
                              nickname: _nicknameController.text.trim(),
                            ),
                          );
                    }
                  } else {
                    if (_validateClientAccount(state.formTextFields)) {
                      context.read<AccountDetailBloc>().add(
                            AccountDetailUpdateEvent(
                              clientAccount: UpdateClientAccount(
                                id: account.id,
                                nickname: _nicknameController.text.trim(),
                                clientRequirements: state.formTextFields
                                    .map(
                                      (e) => ClientRequirementDtos(
                                        id: e.accountRequirement.id,
                                        value: e.controller.text.trim(),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                    }
                  }
                },
              );
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
                        SizedBox(height: 20.h),
                        CustomTextField(
                          title: AppText.nickname,
                          textInputAction: TextInputAction.next,
                          controller: _nicknameController,
                        ),
                        SizedBox(height: 20.h),
                        if (widget.argument.account.isRequest)
                          BlocBuilder<AccountDetailBloc, AccountDetailState>(
                            builder: (context, state) {
                              if (state.accountDetail != null) {
                                _accountNumberController.text = state
                                        .accountDetail!
                                        .clientAccount
                                        .accountNumber ??
                                    '';
                                _usernameController.text = state.accountDetail!
                                        .clientAccount.username ??
                                    '';
                                return Column(
                                  children: [
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
                                    CustomTextField(
                                      title: AppText.usernameOrEmail,
                                      textInputAction: TextInputAction.next,
                                      controller: _usernameController,
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                );
                              }
                              return SizedBox.fromSize();
                            },
                          ),
                        if (!widget.argument.account.isRequest)
                          BlocBuilder<AccountDetailBloc, AccountDetailState>(
                            builder: (context, state) {
                              if (state.formTextFields.isNotEmpty) {
                                return Column(
                                  children: state.formTextFields.map((e) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: Form(
                                        key: e.formKey,
                                        child: CustomTextField(
                                          title: e.accountRequirement
                                              .requirementName,
                                          isRequired: true,
                                          textInputAction: TextInputAction.done,
                                          textInputType:
                                              TextInputType.emailAddress,
                                          controller: e.controller,
                                          validator: (value) {
                                            if (value?.isNotEmpty != true) {
                                              return 'Please enter ${e.accountRequirement.requirementName}';
                                            }
                                            if (value?.isNotEmpty == true &&
                                                e.accountRequirement
                                                    .requirementName
                                                    .contains('mail')) {
                                              return ValidateUtils.isValidEmail(
                                                  value!);
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                              return SizedBox.fromSize();
                            },
                          ),
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

  bool _validateRequestAccount() {
    return _formKeyAccountNumber.currentState?.validate() == true;
  }

  bool _validateClientAccount(List<FormTextField> requirements) {
    bool validate = true;
    for (var requirement in requirements) {
      if (requirement.formKey.currentState?.validate() == false) {
        validate = false;
      }
    }
    return validate;
  }
}
