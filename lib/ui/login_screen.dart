import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // late StreamSubscription<bool> _keyboardVisibilitySubscription;
  // bool _isKeyboardVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: Text(
                  'Sign In',
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                            child: Text(
                              'Email',
                            ),
                          ),
                          TextFormField(
                            // controller: _model.emailAddressController,
                            // focusNode: _model.emailAddressFocusNode,
                            autofillHints: [AutofillHints.email],
                            textInputAction: TextInputAction.next,
                            obscureText: false,
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
                              filled: true,
                              // fillColor: FlutterFlowTheme.of(context)
                              //     .secondaryBackground,
                            ),
                            // style: FlutterFlowTheme.of(context)
                            //     .bodyMedium
                            //     .override(
                            //       fontFamily: 'Manrope',
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w500,
                            //       lineHeight: 1,
                            //     ),
                            minLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            // cursorColor:
                            //     FlutterFlowTheme.of(context).primary,
                            // validator: _model
                            //     .emailAddressControllerValidator
                            //     .asValidator(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                            child: Text(
                              'Password',
                            ),
                          ),
                          TextFormField(
                            // controller: _model.passwordController,
                            // focusNode: _model.passwordFocusNode,
                            autofillHints: [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            // obscureText: !_model.passwordVisibility,
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
                              filled: true,
                              // fillColor: FlutterFlowTheme.of(context)
                              //     .secondaryBackground,
                              // suffixIcon: InkWell(
                              //   // onTap: () => setState(
                              //   //   () => _model.passwordVisibility =
                              //   //       !_model.passwordVisibility,
                              //   // ),
                              //   focusNode: FocusNode(skipTraversal: true),
                              //   // child: Icon(
                              //   //   _model.passwordVisibility
                              //   //       ? Icons.visibility_outlined
                              //   //       : Icons.visibility_off_outlined,
                              //   //   color: FlutterFlowTheme.of(context)
                              //   //       .secondaryText,
                              //   //   size: 18,
                              // ),
                            ),
                          ),
                          // style: FlutterFlowTheme.of(context)
                          //     .bodyMedium
                          //     .override(
                          //       fontFamily: 'Manrope',
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w500,
                          //       lineHeight: 1,
                          //     ),
                          // // cursorColor:
                          // //     FlutterFlowTheme.of(context).primary,
                          // // validator: _model
                          // //     .passwordControllerValidator
                          // //     .asValidator(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    // GoRouter.of(context).prepareAuthEvent();

                    // final user = await authManager.signInWithEmail(
                    //   context,
                    //   _model.emailAddressController.text,
                    //   _model.passwordController.text,
                    // );
                    // if (user == null) {
                    //   return;
                    // }

                    // context.goNamedAuth('Dashboard', context.mounted);
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text('Sign In'),
                  // options: FFButtonOptions(
                  //   width: double.infinity,
                  //   height: 50,
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  //   iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  //   color: FlutterFlowTheme.of(context).primary,
                  //   textStyle: FlutterFlowTheme.of(context).titleSmall,
                  //   elevation: 0,
                  //   borderSide: BorderSide(
                  //     color: Colors.transparent,
                  //     width: 1,
                  //   ),
                  //   borderRadius: BorderRadius.circular(25),
                  // ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                        child: Text(
                          'I don\'t remember my password',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 48),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Text(
                            'Don\'t have an account yet?',
                            // style: FlutterFlowTheme.of(context).labelLarge,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {},
                          child: Text('Create Account'),
                          // options: FFButtonOptions(
                          //   width: double.infinity,
                          //   height: 50,
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          //   iconPadding:
                          //       EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          //   color: FlutterFlowTheme.of(context).accent1,
                          //   textStyle: FlutterFlowTheme.of(context).bodyMedium,
                          //   elevation: 0,
                          //   borderSide: BorderSide(
                          //     color: FlutterFlowTheme.of(context).primary,
                          //     width: 2,
                          //   ),
                          //   borderRadius: BorderRadius.circular(25),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
