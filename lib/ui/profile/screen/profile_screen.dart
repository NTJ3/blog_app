import 'dart:developer';

import 'package:blog_app/core/constant/text_styles.dart';
import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/singletone.dart';
import 'package:blog_app/core/util/snackbar.dart';
import 'package:blog_app/ui/home/screens/home_page.dart';
import 'package:blog_app/ui/login/screen/login_page.dart';
import 'package:blog_app/ui/profile/bloc/profile.dart';
import 'package:blog_app/ui/profile/model/user.dart';
import 'package:blog_app/ui_components/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ProfileBloc profileBloc;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = '';
  String _email = '';
  UserModel _currentUser = new UserModel();
  final bool _editProfile = false;

  @override
  void initState() {
    super.initState();

    profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(GetProfile(uid: Singleton.instance.getUser().id));
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onProfileUpdateButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      _formKey.currentState!.save();

      profileBloc.add(
        ProfileUpdateButtonPressed(
          context: context,
          username: _userName,
          email: _email,
          uid: _currentUser.id,
        ),
      );
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  void _handleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
        serverClientId:
            '976571806521-sarnbm6o8se5fk3kba8rd5r19fb4nvb8.apps.googleusercontent.com',
        scopes: [
          'email',
        ]);

    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.signOut();
    }

    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await (googleSignInAccount?.authentication)!;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      log.info('FIREABASE USER ${firebaseUser.toString()}');

      if (firebaseUser != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;

        log.severe('===> DOC documents $documents');
      }
    } catch (error) {
      log.shout(error, error);
    }
  }

  _onLogOut() {
    profileBloc.add(Logout());
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<ProfileBloc, ProfileState>(
      key: _scaffoldKey,
      listener: (context, state) {
        log.info('===> listener $state');
        if (state is ProfileUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  state.error,
                  textAlign: TextAlign.center,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ProfileUpdateSuccess) {
          _autoValidateMode = AutovalidateMode.disabled;
          showToast(Strings.message.kRegistrationSuccess, context);
          Navigator.pushReplacementNamed(context, HomePage.tag);
        } else if (state is LogOutSuccess) {
          Navigator.pushReplacementNamed(context, LoginPage.tag);
        } else if (state is LogOutFailure) {
          showToast(state.error, context);
        }
      },
      builder: (context, state) => SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(Singleton.instance.getUser().id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          width: 25,
                          height: 25,
                          child: LoadingIndicator(),
                        );
                      } else {
                        var data = snapshot.data?.data();

                        UserModel user = UserModel().fromJson(data!);

                        return Text(
                            '\nUserName: ${user.username}\n\nEmail: ${user.email}');
                      }
                    },
                  ),
                  SizedBox(height: 25),
                  CustomAppButton(
                    showLoader: state is LogOutLoading,
                    text: Strings.button.kLogout,
                    textColor: Colors.white,
                    backgroundColor: Colors.blue,
                    onPressed: _onLogOut,
                  ),
                  !_editProfile
                      ? Container()
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Strings.hint.kUserName),
                            ),
                            TextFormField(
                              initialValue: _userName,
                              focusNode: _usernameFocus,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              onSaved: (value) =>
                                  _userName = value?.trim() ?? "",
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _usernameFocus, _emailFocus);
                              },
                              validator: Validator.validateUserName,
                              decoration:
                                  TextStyles.getInputDecoration().copyWith(
                                hintText: Strings.hint.kUserName,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Strings.hint.kEmail),
                            ),
                            TextFormField(
                              initialValue: _email,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onSaved: (value) => _email = value?.trim() ?? "",
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(
                                    context, _emailFocus, _passwordFocus);
                              },
                              validator: Validator.validateEmail,
                              decoration:
                                  TextStyles.getInputDecoration().copyWith(
                                hintText: Strings.hint.kEmail,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            SizedBox(height: 24.0),
                            CustomAppButton(
                              showLoader: state is ProfileLoading,
                              text: Strings.button.kUpdate,
                              textColor: Colors.white,
                              backgroundColor: Colors.blue,
                              onPressed: _onProfileUpdateButtonPressed,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ));
}
