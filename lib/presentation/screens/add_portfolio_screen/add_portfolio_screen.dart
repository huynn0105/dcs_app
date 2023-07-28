import 'package:dcs_app/presentation/providers/home_provider/home_provider.dart';
import 'package:dcs_app/presentation/screens/common/custom_text_field.dart';
import 'package:dcs_app/utils/color_util.dart';
import 'package:dcs_app/utils/text_style_util.dart';
import 'package:dcs_app/utils/validate_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../common/text_button.dart';

class AddPortfolioScreen extends StatefulWidget {
  const AddPortfolioScreen({super.key});

  @override
  State<AddPortfolioScreen> createState() => _AddPortfolioScreenState();
}

class _AddPortfolioScreenState extends State<AddPortfolioScreen> {
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
    _accountNameController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leadingWidth: 70.w,
        title: Text(
          'Add Account',
          style: TextStyleUtil.bold(16),
        ),
        leading: CustomTextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          textButton: 'Cancel',
        ),
        actions: [
          CustomTextButton(
            onPressed: () {
              if (_formKeyAccountName.currentState?.validate() == true &&
                  _formKeyEmail.currentState?.validate() == true) {
                context.read<HomeProvider>().createAccount(
                      accountName: _accountNameController.text,
                      accountNumber: _accountNumberController.text,
                      email: _emailController.text,
                      username: _usernameController.text,
                    );
              }
            },
            textButton: 'Done',
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: ColorUtil.grey,
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
                    title: 'Account Name',
                    textInputAction: TextInputAction.next,
                    controller: _accountNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Account name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Please enter one or more of the following',
                  style: TextStyleUtil.regular(13),
                ),
                SizedBox(height: 16.h),
                Form(
                  key: _formKeyAccountNumber,
                  child: CustomTextField(
                    title: 'Account Number',
                    controller: _accountNumberController,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 16.h),
                Form(
                  key: _formKeyUsername,
                  child: CustomTextField(
                    title: 'Username',
                    textInputAction: TextInputAction.next,
                    controller: _usernameController,
                  ),
                ),
                SizedBox(height: 16.h),
                Form(
                  key: _formKeyEmail,
                  child: CustomTextField(
                    title: 'Email',
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    controller: _usernameController,
                    validator: (value) {
                      if (value?.isNotEmpty == true) {
                        return ValidateUtil.isValidEmail(value!);
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyleUtil.bold(13),
          ),
          SizedBox(
            width: 170.w,
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
