import 'package:flutter/material.dart';

Widget BuildTextField({
  required BuildContext context,
  required String label,
  required TextEditingController? controller,
  required FocusNode? focusNode,
  required String? Function(String?)? validator,
  required TextInputAction textInputAction,
  List<String>? autofillHints,
  TextInputType? keyboardType,
  int? maxLength,
  // bool obscureText = false,
  Widget? suffixIcon,
}) {
  return Padding(
    padding: EdgeInsets.only(top: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x00000000),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          cursorColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    ),
  );
}
