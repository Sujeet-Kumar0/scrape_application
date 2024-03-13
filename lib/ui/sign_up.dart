import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/viewmodels/signup_viewmodel.dart';

import '../firebase_implemention/firebase_auth_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late SignupViewModel _model;

  @override
  void initState() {
    _model = Provider.of<SignupViewModel>(context, listen: false);
    _model.initialize();

    _model.fullNameController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();

    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.phoneNumberController ??= TextEditingController();
    _model.phoneNumberFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Create an account',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Full Name',
                        controller: _model.fullNameController,
                        focusNode: _model.fullNameFocusNode,
                        validator: _model.fullNameControllerValidator,
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.name],
                        keyboardType: TextInputType.name,
                      ),
                      _buildTextField(
                        label: 'Email',
                        controller: _model.emailAddressController,
                        focusNode: _model.emailAddressFocusNode,
                        validator: _model.emailAddressControllerValidator,
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        label: 'Phone Number',
                        controller: _model.phoneNumberController,
                        focusNode: _model.phoneNumberFocusNode,
                        validator: _model.phoneNumberControllerValidator,
                        textInputAction: TextInputAction.next,
                        autofillHints: [AutofillHints.telephoneNumber],
                        keyboardType: TextInputType.phone,
                        maxLength: 13,
                      ),
                      _buildTextField(
                        label: 'Password',
                        controller: _model.passwordController,
                        focusNode: _model.passwordFocusNode,
                        validator: _model.passwordControllerValidator,
                        textInputAction: TextInputAction.done,
                        // obscureText: true,
                        autofillHints: [AutofillHints.newPassword],
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => _model.passwordVisibility =
                                !_model.passwordVisibility,
                          ),
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            _model.passwordVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 18,
                          ),
                        ),
                      ),
                      _buildTextField(
                        label: 'Confirm Password',
                        controller: _model.confirmPasswordController,
                        focusNode: _model.confirmPasswordFocusNode,
                        validator: _model.confirmPasswordControllerValidator,
                        textInputAction: TextInputAction.done,
                        // obscureText: true,
                        autofillHints: [AutofillHints.newPassword],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            ),
                            elevation: MaterialStateProperty.all<double>(0),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
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

  void _submitForm() async {
    HapticFeedback.lightImpact();
    if (_formKey.currentState!.validate()) {
      final user = await signUpWithEmailandPassword(
        _model.emailAddressController!.text,
        _model.passwordController!.text,
      );
      if (user == null) {
        return;
      }
      _model.updateUserRecord(user);
      context.go('/');
    }
  }
}
