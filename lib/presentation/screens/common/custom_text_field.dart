import 'package:dcs_app/utils/color_utils.dart';
import 'package:dcs_app/utils/text_style_utils.dart';
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
    this.onFieldSubmitted,
    this.onChanged,
    this.readOnly = false,
  });
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String title;
  final TextEditingController? controller;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

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
          style: TextStyleUtils.bold(13),
        ),
        SizedBox(height: 6.w),
        TextFormField(
          readOnly: widget.readOnly,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofillHints: widget.autofillHints,
          onChanged: widget.onChanged,
          controller: widget.controller,
          obscureText: _obscureText,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          style: TextStyleUtils.regular(13),
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
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
              borderSide: const BorderSide(
                color: ColorUtils.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(
                color: ColorUtils.blue,
              ),
            ),
            errorStyle: TextStyleUtils.regular(10),
          ),
        ),
      ],
    );
  }
}
