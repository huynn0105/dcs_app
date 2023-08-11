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
  final String? accountType;
  final bool isRequestAccount;

  const AddAccountScreenArgument({
    this.id,
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
  final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyUsername = GlobalKey<FormState>();

  @override
  void initState() {
    _accountNameController =
        TextEditingController(text: widget.argument?.accountName);
    _accountNumberController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();

    if (widget.argument?.id != null) {
      context
          .read<CreateAccountBloc>()
          .add(GetRequirementByAccountEvent(id: widget.argument!.id!));
    }

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
                  AppText.addSuccessfully,
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
          title: BlocBuilder<CreateAccountBloc, CreateAccountState>(
            builder: (context, state) {
              return _AppBar(
                onPressed: () {
                  if (state is CreateAccountLoaded) {
                    if (_validate(state.formTextFields)) {
                      context.read<CreateAccountBloc>().add(
                            CreateAccountButtonPressedEvent(
                              accountName: _accountNameController.text,
                              accountNumber: _accountNumberController.text,
                              usernameOrEmail: _usernameController.text,
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

                        if (widget.argument?.isRequestAccount == true) ...[
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
                          if (state is CreateAccountLoaded) {
                            return Column(
                              children: [
                                !state.formFieldNames.contains(
                                        AppText.accountNumber.toLowerCase())
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: Form(
                                          key: _formKeyAccountNumber,
                                          child: CustomTextField(
                                            title: AppText.accountNumber,
                                            controller:
                                                _accountNumberController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.number,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                !state.formFieldNames.contains(
                                  AppText.username1.toLowerCase(),
                                )
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: Form(
                                          key: _formKeyUsername,
                                          child: CustomTextField(
                                            title: AppText.username1,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: _usernameController,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                state.formFieldNames
                                        .contains(AppText.email.toLowerCase())
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 16.h),
                                        child: Form(
                                          key: _formKeyEmail,
                                          child: CustomTextField(
                                            title: AppText.email,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: _emailController,
                                            validator: (value) {
                                              if (value?.isNotEmpty == true) {
                                                return ValidateUtils
                                                    .isValidEmail(value!);
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                ...state.formTextFields.map((e) {
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

  bool _validate(List<FormTextField> requirements) {
    bool validate = true;
    for (var requirement in requirements) {
      if (requirement.formKey.currentState?.validate() == false) {
        validate = false;
      }
    }
    return _formKeyAccountName.currentState?.validate() == true &&
        validate &&
        _formKeyEmail.currentState?.validate() == true &&
        _formKeyEmail.currentState?.validate() == true;
  }
}
