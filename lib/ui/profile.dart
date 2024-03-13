import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrape_application/components/saved_address.dart';
import 'package:scrape_application/domain/address_repository.dart';
import 'package:scrape_application/model/address_model.dart';
import 'package:scrape_application/model/user_profile.dart';
import 'package:scrape_application/viewmodels/profile_view_model.dart';
import 'package:scrape_application/viewmodels/saved_address_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/edit_profile_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    String phoneNumber = viewModel.contactSupportNumber;

    return GestureDetector(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: EdgeInsets.all(24),
          child: FutureBuilder<UserProfile>(
            future: viewModel.getUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userProfile = snapshot.data!;
                final profileName = userProfile.profileName ??
                    viewModel.getCurrentUserDisplayName();
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 6),
                        child: Text(
                          viewModel.getProfileGreeting(DateTime.now()),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    Text(
                      profileName,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Visibility(
                      visible: viewModel.isLoggedIn,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 24, 0, 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 6),
                                  child: Text(
                                    userProfile.phoneNumber,
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 6, 0, 0),
                                  child: Text(
                                    userProfile.userEmail,
                                    textAlign: TextAlign.start,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              'Edit Profile',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return EditProfileDialog(
                                      userProfile: userProfile);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: viewModel.isLoggedIn,
                      replacement: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 12, 16, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.push('/login');
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFFFFFFF),
                                  width: 0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.login,
                                        // color: Theme.of(context).secondaryText,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        'Log In or Sign-up',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 12, 16, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3,
                                    color: Color(0x33000000),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color(0xFFFFFFFF),
                                  width: 0,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.edit_location,
                                        // color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 24,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        'Saved Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () => SavedAddressDialog.show(context),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: RichText(
                          text: TextSpan(
                            text: 'Contact Support @ ',
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: phoneNumber,
                                style: TextStyle(
                                  color: Colors
                                      .blue, // Make the phone number blue for indicating it's tappable
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchPhoneDialer(context, phoneNumber);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: viewModel.isLoggedIn,
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 40),
                          child: ElevatedButton(
                            onPressed: () {
                              print('Logging Out ...');
                              viewModel.logOut();
                              // viewModel.getCurrentUserDisplayName();
                              // viewModel.getUserProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFFFFF),
                              padding: EdgeInsets.zero,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                width: 110,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors
                                        .black, // Change the color according to your theme
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _launchPhoneDialer(BuildContext context, String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
