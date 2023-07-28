import 'package:dcs_app/utils/color_util.dart';
import 'package:dcs_app/utils/text_style_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.textInputAction,
    this.textInputType,
    this.autofillHints,
  });
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String title;
  final TextEditingController? controller;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyleUtil.bold(13),
        ),
        SizedBox(height: 6.w),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofillHints: widget.autofillHints,
          controller: widget.controller,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          style: TextStyleUtil.regular(13),
          validator: widget.validator,
          decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
                : null,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: BorderSide(
                color: ColorUtil.grey,
              ),
            ),
            errorStyle: TextStyleUtil.regular(10),
          ),
        ),
      ],
    );
  }
}
