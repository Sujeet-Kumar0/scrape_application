import 'package:flutter/material.dart';

class CustomInputDecoration {
  final String? hintText;
  final Widget? suffixIcon;

  const CustomInputDecoration({this.hintText, this.suffixIcon});

  InputDecoration getDecoration(BuildContext context) {
    return InputDecoration(
      hintText: hintText,
      labelText: null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0x00000000),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      fillColor: const Color(0xfff6f6f6),
      filled: true,
      suffixIcon: suffixIcon,
    );
  }
}

class CustomTextField extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool obscureText;

  const CustomTextField({
    required this.context,
    required this.label,
    this.hintText,
    this.controller,
    this.validator,
    this.textInputAction,
    this.autofillHints,
    this.keyboardType,
    this.maxLength,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    _defaultValidator(value) {
      if (value == null || value.isEmpty) {
        return 'This field cannot be empty';
      }
      return null;
    }

    return Padding(
      padding: EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          TextFormField(
            controller: controller,
            validator: validator ?? _defaultValidator,
            textInputAction: textInputAction ?? TextInputAction.done,
            autofillHints: autofillHints,
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: CustomInputDecoration(
                    suffixIcon: suffixIcon, hintText: hintText)
                .getDecoration(context),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
            cursorColor: Theme.of(context).colorScheme.primary,
            obscureText: obscureText,
          ),
        ],
      ),
    );
  }
}
