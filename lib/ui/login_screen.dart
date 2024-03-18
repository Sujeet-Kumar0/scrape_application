import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/components/custom_text_field.dart';

import '../firebase_implemention/firebase_auth_services.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;
  final _formKey = GlobalKey<FormState>();

  late LoginViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Provider.of<LoginViewModel>(context, listen: false);
    _model.initState();

    if (!kIsWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }
    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    if (!kIsWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return kIsWeb
            ? Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        constraints.maxWidth > 400 ? 400 : double.infinity,
                  ),
                  child: _buildLoginScreen(context),
                ),
              )
            : _buildLoginScreen(context);
      },
    );
  }

  GestureDetector _buildLoginScreen(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      _buildForm(context),
                      _buildForgotPassword(context),
                      if (!kIsWeb)
                        if (!(_isKeyboardVisible ||
                            MediaQuery.viewInsetsOf(context).bottom > 0))
                          _buildCreateAccount(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTextFormField(
            context,
            labelText: 'Email',
            controller: _model.emailAddressController,
            focusNode: _model.emailAddressFocusNode,
            validator: _model.emailAddressControllerValidator,
            keyboardType: TextInputType.emailAddress,
            autofillHints: [AutofillHints.email],
            hintText: 'Enter your email',
          ),
          _buildTextFormField(
            context,
            labelText: 'Password',
            controller: _model.passwordController,
            focusNode: _model.passwordFocusNode,
            validator: _model.passwordControllerValidator,
            obscureText: !_model.passwordVisibility,
            keyboardType: TextInputType.visiblePassword,
            autofillHints: [AutofillHints.password],
            hintText: 'Enter your password',
            suffixIcon: InkWell(
              onTap: () => setState(() {
                _model.passwordVisibility = !_model.passwordVisibility;
              }),
              focusNode: FocusNode(skipTraversal: true),
              child: Icon(
                _model.passwordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child: ElevatedButton(
              onPressed: () async {
                HapticFeedback.lightImpact();
                if (_formKey.currentState!.validate()) {
                  try {
                    final user = await signInWithEmailandPassword(
                      _model.emailAddressController?.text,
                      _model.passwordController!.text,
                    );
                    if (user == null) {
                      const snackBar = SnackBar(
                        content: Text('Something Went Wrong'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
                  } catch (error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Sign-In Error'),
                          content: Text(error.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  if (kIsWeb) {
                    context.go('/dashboard');
                  } else {
                    context.go('/');
                  }
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                ),
                elevation: MaterialStateProperty.all<double>(0),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(
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
                child: const Text(
                  'Sign In',
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
    );
  }

  Widget _buildTextFormField(
    BuildContext context, {
    required String? labelText,
    required TextEditingController? controller,
    required FocusNode? focusNode,
    required String? Function(String?)? validator,
    required TextInputType? keyboardType,
    List<String>? autofillHints,
    String? hintText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
            child: Text(
              labelText!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofillHints: autofillHints,
            textInputAction: TextInputAction.next,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0x00000000),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondaryContainer,
              suffixIcon: suffixIcon,
            ),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
            minLines: 1,
            keyboardType: keyboardType,
            cursorColor: Theme.of(context).colorScheme.primary,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController _emailController = TextEditingController();
            return AlertDialog(
              title: Text("Please Enter Your Email:"),
              content: CustomTextField(
                context: context,
                label: "",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Email",
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_emailController.text.isEmpty) {}
                    // Close the dialog
                    Navigator.of(context).pop();
                    // Get the email entered by the user
                    String email = _emailController.text.trim();
                    // Reset password logic here
                    try {
                      await resetPassword(email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password reset email sent!'),
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send password reset email.'),
                        ),
                      );
                    }
                  },
                  child: Text('Reset Password'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
            child: Text(
              'I don\'t remember my password',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: Text(
              'Don\'t have an account yet?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              context.go('/sign-up');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.primaryContainer,
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              ),
              elevation: MaterialStateProperty.all<double>(0),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
