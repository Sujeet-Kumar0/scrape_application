import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        // backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: // Generated code for this Column Widget...
              Align(
            alignment: AlignmentDirectional(0, 0),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Text(
                      'Create an account',
                      // style: FlutterFlowTheme.of(context).displaySmall,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                                child: Text(
                                  'Full Name',
                                  // style:FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                              TextFormField(
                                // controller: _model.fullNameController,
                                // focusNode: _model.fullNameFocusNode,
                                autofillHints: [AutofillHints.name],
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                obscureText: false,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).alternate,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  // fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                                // cursorColor:FlutterFlowTheme.of(context).primary,
                                // validator: _model.fullNameControllerValidator.asValidator(context),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                                child: Text(
                                  'Email',
                                  // style:FlutterFlowTheme.of(context).bodyMedium,
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
                                      // color: FlutterFlowTheme.of(context).alternate,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color:FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  // fillColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                                // cursorColor:FlutterFlowTheme.of(context).primary,
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                                child: Text(
                                  'Password',
                                  // style:FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ),
                              TextFormField(
                                // controller: _model.passwordController,
                                // focusNode: _model.passwordFocusNode,
                                autofillHints: [AutofillHints.newPassword],
                                textInputAction: TextInputAction.done,
                                // obscureText: !_model.passwordVisibility,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).alternate,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      // color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  // fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  // suffixIcon: InkWell(
                                  //   onTap: () => setState(
                                  //     () => _model.passwordVisibility =
                                  //         !_model.passwordVisibility,
                                  //   ),
                                  //   focusNode: FocusNode(skipTraversal: true),
                                  //   child: Icon(
                                  //     _model.passwordVisibility
                                  //         ? Icons.visibility_outlined
                                  //         : Icons.visibility_off_outlined,
                                  //     color: FlutterFlowTheme.of(context)
                                  //         .secondaryText,
                                  //     size: 18,
                                  //   ),
                                  // ),
                                ),
                                // style: FlutterFlowTheme.of(context)
                                //     .bodyMedium
                                //     .override(
                                //       fontFamily: 'Manrope',
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w500,
                                //       lineHeight: 1,
                                //     ),
                                // cursorColor:
                                //     FlutterFlowTheme.of(context).primary,
                                // validator: _model.passwordControllerValidator
                                //     .asValidator(context),
                              ),
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
                        // final user = await authManager.createAccountWithEmail(
                        //   context,
                        //   _model.emailAddressController.text,
                        //   _model.passwordController.text,
                        // );
                        // if (user == null) {
                        //   return;
                        // }
                        // await UsersRecord.collection.doc(user.uid).update({
                        //   ...createUsersRecordData(
                        //     displayName: _model.fullNameController.text,
                        //     diet: FFAppState().userDiet,
                        //   ),
                        //   ...mapToFirestore(
                        //     {
                        //       'allergens': FFAppState().userAllergens,
                        //       'ingredient_dislikes':
                        //           FFAppState().userIngredientDislikes,
                        //     },
                        //   ),
                        // });
                        // logFirebaseEvent('Button_navigate_to');
                        // context.goNamedAuth('Dashboard', context.mounted);
                      },
                      child: Text('Create Account'),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   child: StreamBuilder<List<CompanyInformationRecord>>(
                        //     stream: queryCompanyInformationRecord(
                        //       singleRecord: true,
                        //     ),
                        //     builder: (context, snapshot) {
                        //       // Customize what your widget looks like when it's loading.
                        //       if (!snapshot.hasData) {
                        //         return Center(
                        //           child: SizedBox(
                        //             width: 50,
                        //             height: 50,
                        //             child: CircularProgressIndicator(
                        //               valueColor: AlwaysStoppedAnimation<Color>(
                        //                 FlutterFlowTheme.of(context).primary,
                        //               ),
                        //             ),
                        //           ),
                        //         );
                        //       }
                        //       List<CompanyInformationRecord>
                        //           richTextCompanyInformationRecordList =
                        //           snapshot.data!;
                        //       // Return an empty Container when the item does not exist.
                        //       if (snapshot.data!.isEmpty) {
                        //         return Container();
                        //       }
                        //       final richTextCompanyInformationRecord =
                        //           richTextCompanyInformationRecordList
                        //                   .isNotEmpty
                        //               ? richTextCompanyInformationRecordList
                        //                   .first
                        //               : null;
                        //       return InkWell(
                        //         splashColor: Colors.transparent,
                        //         focusColor: Colors.transparent,
                        //         hoverColor: Colors.transparent,
                        //         highlightColor: Colors.transparent,
                        //         onTap: () async {
                        //           logFirebaseEvent(
                        //               'ONBOARDING_CREATE_ACCOUNT_RichText_t8sm7');
                        //           logFirebaseEvent('RichText_launch_u_r_l');
                        //           await launchURL(
                        //               richTextCompanyInformationRecord!
                        //                   .termsURL);
                        //         },
                        //         child: RichText(
                        //           textScaleFactor:
                        //               MediaQuery.of(context).textScaleFactor,
                        //           text: TextSpan(
                        //             children: [
                        //               TextSpan(
                        //                 text:
                        //                     'By clicking \"Create Account,\" you agree to MealPlanner\'s ',
                        //                 style: FlutterFlowTheme.of(context)
                        //                     .bodySmall,
                        //               ),
                        //               TextSpan(
                        //                 text: 'Terms of Use',
                        //                 style: FlutterFlowTheme.of(context)
                        //                     .bodySmall
                        //                     .override(
                        //                       fontFamily: 'Manrope',
                        //                       decoration:
                        //                           TextDecoration.underline,
                        //                     ),
                        //               ),
                        //               TextSpan(
                        //                 text: '.',
                        //                 style: TextStyle(),
                        //               )
                        //             ],
                        //             style:
                        //                 FlutterFlowTheme.of(context).bodySmall,
                        //           ),
                        //           textAlign: TextAlign.center,
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
