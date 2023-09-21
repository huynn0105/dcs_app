import 'package:dcs_app/data/datasources/dtos/create_client_account/create_client_account_dto.dart';
import 'package:dcs_app/global/router.dart';
import 'package:dcs_app/presentation/blocs/create_account_bloc/create_account_bloc.dart';
import 'package:dcs_app/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:dcs_app/utils/constants.dart';
import 'package:dcs_app/utils/validate_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dcs_app/presentation/screens/common/custom_text_field.dart';
import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/dialog_utils.dart';
import 'package:dcs_app/utils/enum.dart';
import 'package:dcs_app/utils/loading_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
import 'package:get/get.dart';

import '../common/text_button.dart';

part 'widgets/app_bar.dart';

class AddAccountScreenArgument {
  final int? id;
  final String accountName;
  final String? usernameOrEmail;
  final bool isRequestAccount;

  const AddAccountScreenArgument({
    this.id,
    required this.accountName,
    this.usernameOrEmail,
    this.isRequestAccount = false,
  });
}

class AddAccountScreen extends StatefulWidget {
  final AddAccountScreenArgument argument;
  const AddAccountScreen({
    super.key,
    required this.argument,
  });

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  late TextEditingController _accountNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  final GlobalObjectKey<FormState> _formKeyAccountName =
      const GlobalObjectKey<FormState>(AppText.accountName);
  final GlobalObjectKey<FormState> _formKeyAccountNumber =
      const GlobalObjectKey<FormState>(AppText.accountNumber);
  final GlobalObjectKey<FormState> _formKeyEmail =
      const GlobalObjectKey<FormState>(AppText.email);
  final GlobalObjectKey<FormState> _formKeyUsername =
      const GlobalObjectKey<FormState>(AppText.username);

  @override
  void initState() {
    _accountNameController =
        TextEditingController(text: widget.argument.accountName);
    _accountNumberController = TextEditingController();
    _usernameController =
        TextEditingController(text: widget.argument.usernameOrEmail);
    _emailController = TextEditingController();

    context
        .read<CreateAccountBloc>()
        .add(GetRequirementByAccountEvent(id: widget.argument.id));

    super.initState();
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateAccountBloc, CreateAccountState>(
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
                  AppText.addSuccessfully,
                ),
              ),
            );
            Get.offAndToNamed(MyRouter.home);
          }
        } else if (state.success == false &&
            state.message?.isNotEmpty == true) {
          await DialogUtils.showContinueDialog(
            type: DialogType.error,
            title: AppText.error,
            body: state.message,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: BlocBuilder<CreateAccountBloc, CreateAccountState>(
            builder: (context, state) {
              return _AppBar(
                onCancel: () {
                  Get.back();
                  context
                      .read<CreateAccountBloc>()
                      .add(GetRequirementByAccountEvent());
                },
                onPressed: () {
                  if (widget.argument.isRequestAccount) {
                    if (_validateRequestAccount()) {
                      context.read<CreateAccountBloc>().add(
                            CreateRequestAccountButtonPressedEvent(
                              accountName: _accountNameController.text.trim(),
                              accountNumber:
                                  _accountNumberController.text.trim(),
                              usernameOrEmail: _usernameController.text.trim(),
                            ),
                          );
                    }
                  } else {
                    if (_validateClientAccount(state.formTextFields)) {
                      context.read<CreateAccountBloc>().add(
                            CreateClientAccountButtonPressedEvent(
                              accountId: widget.argument.id!,
                              username: _usernameController.text.trim(),
                              email: _emailController.text.trim(),
                              clientRequirements: state.formTextFields
                                  .map(
                                    (e) => ClientRequirementDtos(
                                      id: e.accountDto.id,
                                      value: e.controller.text.trim(),
                                    ),
                                  )
                                  .toList(),
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
                            readOnly: widget.argument.isRequestAccount == true
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
                        if (widget.argument.isRequestAccount) ...[
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Form(
                              key: _formKeyAccountNumber,
                              child: CustomTextField(
                                title: AppText.accountNumber,
                                controller: _accountNumberController,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.number,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Form(
                              key: _formKeyUsername,
                              child: CustomTextField(
                                title: AppText.username1,
                                textInputAction: TextInputAction.next,
                                controller: _usernameController,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: Form(
                              key: _formKeyEmail,
                              child: CustomTextField(
                                title: AppText.email,
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                textInputType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value?.isNotEmpty == true) {
                                    return ValidateUtils.isValidEmail(value!);
                                  }
                                  return null;
                                },
                              ),
                            ),
                          )
                        ],
                        BlocBuilder<CreateAccountBloc, CreateAccountState>(
                            builder: (context, state) {
                          if (state.formTextFields.isNotEmpty &&
                              !widget.argument.isRequestAccount) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Form(
                                    key: _formKeyUsername,
                                    child: CustomTextField(
                                        isRequired: true,
                                        title: AppText.username1,
                                        textInputAction: TextInputAction.next,
                                        controller: _usernameController,
                                        validator: (value) {
                                          if (value?.isNotEmpty != true) {
                                            return AppText.plsEnterUsername;
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                                ...state.formTextFields
                                    .where((e) =>
                                        e.accountDto.name.toLowerCase() !=
                                        AppText.username1.toLowerCase())
                                    .map((e) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: Form(
                                      key: e.formKey,
                                      child: CustomTextField(
                                        title: e.accountDto.name,
                                        isRequired: true,
                                        textInputAction: TextInputAction.done,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        controller: e.controller,
                                        validator: (value) {
                                          if (value?.isNotEmpty != true) {
                                            return 'Please enter ${e.accountDto.name}';
                                          }
                                          if (value?.isNotEmpty == true &&
                                              e.accountDto.name
                                                  .contains('mail')) {
                                            return ValidateUtils.isValidEmail(
                                                value!);
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  );
                                }).toList()
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
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
    return _formKeyAccountName.currentState?.validate() == true &&
        _formKeyEmail.currentState?.validate() == true;
  }

  bool _validateClientAccount(List<FormTextField> requirements) {
    bool validate = true;
    for (var requirement in requirements) {
      if (requirement.formKey.currentState?.validate() == false) {
        validate = false;
      }
    }
    return validate && _formKeyUsername.currentState?.validate() == true;
  }
}
