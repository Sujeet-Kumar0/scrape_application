import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameController;
  String? Function(String?)? fullNameControllerValidator;
  String? _fullNameControllerValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Full name is required.';
    }

    return null;
  }

  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberController;
  String? Function(String?)? phoneNumberControllerValidator;
  String? _phoneNumberControllerValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Number is required.';
    }

    return null;
  }

  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(String?)? emailAddressControllerValidator;
  String? _emailAddressControllerValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Email is required.';
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for confirm password widget.
  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordController;
  String? Function(String?)? confirmPasswordControllerValidator;
  String? _confirmPasswordControllerValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required.';
    }

    if (val != passwordController!.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  late bool passwordVisibility;
  String? Function(String?)? passwordControllerValidator;
  String? _passwordControllerValidator(String? val) {
    if (val == null || val.isEmpty) {
      return 'Password is required.';
    }

    return null;
  }

  /// Initialization and disposal methods.

  void initialize() {
    fullNameControllerValidator = _fullNameControllerValidator;
    emailAddressControllerValidator = _emailAddressControllerValidator;
    passwordControllerValidator = _passwordControllerValidator;
    confirmPasswordControllerValidator = _confirmPasswordControllerValidator;
    phoneNumberControllerValidator = _phoneNumberControllerValidator;
    passwordVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    fullNameFocusNode?.dispose();
    fullNameController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();

    passwordFocusNode?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  /// Action blocks are added here.'
  void updateUserRecord(User user) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('Orders');

    final userData = {
      'phoneNumber': phoneNumberController!.text,
      'userName': fullNameController!.text,
      'email': emailAddressController!.text
    };
    try {
      await usersCollection.doc(user.uid).set(userData);
      await user.updateDisplayName(fullNameController!.text);
      await user.sendEmailVerification();
      // await user?.updatePhoneNumber(phoneNumberController!.text);
      // Print a success message
      log('User details added to Firestore successfully!');
      await ordersCollection.doc(user.uid).set(<String, dynamic>{});
      log('Setting Up completed successfully!');
    } catch (e) {
      // Print an error message if something goes wrong
      log('Error adding order details to Firestore: $e',stackTrace: StackTrace.current);
    }
  }

  /// Additional helper methods are added here.
}
