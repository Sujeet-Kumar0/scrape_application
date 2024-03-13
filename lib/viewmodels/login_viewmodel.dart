import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  late String? Function(String?) emailAddressControllerValidator;

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  // late String? Function(BuildContext, String?) passwordControllerValidator;

  // Initialization method
  void initState() {
    // Setup email address
    emailAddressFocusNode = FocusNode();
    emailAddressController = TextEditingController();
    emailAddressControllerValidator = _emailAddressControllerValidator;

    // Setup password
    passwordFocusNode = FocusNode();
    passwordController = TextEditingController();
    passwordVisibility = false;
    // passwordControllerValidator = _passwordControllerValidator;
  }

  // Disposal method
  @override
  void dispose() {
    unfocusNode.dispose();
    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();
    passwordFocusNode?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  // Validator for email address
  String? _emailAddressControllerValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // Validator for password
  String? passwordControllerValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }
}
