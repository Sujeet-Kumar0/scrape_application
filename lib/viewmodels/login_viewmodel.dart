import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isAdmin = false;

  // bool get isAdmin => false;
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

  Future<void> checkAdmin(User? user) async {
    if (user != null) {
      String userId =
          user.uid; // Assuming 'id' is the field that contains the user ID

      // Get the reference to the admins collection
      CollectionReference adminsCollection =
          FirebaseFirestore.instance.collection('admins');

      // Query the admins collection to check if the user ID exists
      QuerySnapshot querySnapshot =
          await adminsCollection.where('userId', isEqualTo: userId).get();

      // Check if there's any document returned
      if (querySnapshot.docs.isNotEmpty) {
        log("the current User is A Admin");
        isAdmin = true;
        notifyListeners();
      } else {
        log("the current User is Not A Admin");

        isAdmin = false;
        notifyListeners();
      }
    } else {
      isAdmin = false;
      notifyListeners();
    }
  }
}
