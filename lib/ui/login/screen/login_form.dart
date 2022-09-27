import 'dart:developer';

import 'package:blog_app/core/constant/text_styles.dart';
import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/snackbar.dart';
import 'package:blog_app/ui/home/screens/home_page.dart';
import 'package:blog_app/ui/login/bloc/login.dart';
import 'package:blog_app/ui/register/bloc/register.dart';
import 'package:blog_app/ui_components/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late LoginBloc loginBloc;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _userName;
  late String _password;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onLoginButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      _formKey.currentState!.save();
      // SharedPreferenceHelper.setToken('$_userName$_password');

      loginBloc.add(LoginButtonPressed(
        context: context,
        username: _userName,
        password: _password,
        loginWithGoogle: false,
      ));
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  void _redirectToForgotPassword() {
    _fieldFocusChange(context, _passwordFocus, FocusNode());
    _formKey.currentState!.reset();
    setState(() {
      _autoValidateMode = AutovalidateMode.disabled;
    });
    // Navigator.pushNamed(context, ForgotPasswordPage.tag);
  }

  void _redirectToRegistrationPage() {
    _fieldFocusChange(context, _passwordFocus, FocusNode());
    _formKey.currentState!.reset();
    setState(() {
      _autoValidateMode = AutovalidateMode.disabled;
    });
    Navigator.pushNamed(context, RegisterPage.tag);
  }

  String? _validatePassword(String? val) {
    if (val!.trim().isEmpty) {
      return Strings.message.kEnterPassword;
    } else if (!Validator.isValidPassword(val)) {
      return Strings.message.kEnterValidPassword;
    } else {
      return null;
    }
  }

  String? _validateEmail(String? val) {
    if (val!.trim().isEmpty) {
      return Strings.message.kEnterEmail;
    } else if (!Validator.isValidEmail(val)) {
      return Strings.message.kEnterValidEmail;
    } else {
      return null;
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

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
      key: _scaffoldKey,
      listener: (context, state) {
        log.info('===> listener $state');

        if (state is LoginFailure) {
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
        } else if (state is LoginSuccess) {
          _autoValidateMode = AutovalidateMode.disabled;
          showToast(Strings.message.kLoginSuccess, context);
          Navigator.pushReplacementNamed(context, HomePage.tag);
        }
      },
      builder: (context, state) => Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) => _userName = value?.trim() ?? "",
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _emailFocus, _passwordFocus);
                          },
                          validator: _validateEmail,
                          decoration: TextStyles.getInputDecoration().copyWith(
                            hintText: Strings.hint.kEmail,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          obscureText: true,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.go,
                          onSaved: (value) => _password = value?.trim() ?? "",
                          onFieldSubmitted: (term) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _onLoginButtonPressed();
                          },
                          validator: _validatePassword,
                          decoration: TextStyles.getInputDecoration().copyWith(
                            hintText: Strings.hint.kPassword,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: CustomAppButton(
                                showLoader: state is LoginLoading,
                                text: Strings.button.kLogin,
                                textColor: Colors.white,
                                backgroundColor: Colors.blue,
                                onPressed: _onLoginButtonPressed,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: CustomAppButton(
                                text: Strings.button.kLoginWithGoogle,
                                textColor: Colors.white,
                                backgroundColor: Colors.blue,
                                onPressed: _handleSignIn,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _redirectToRegistrationPage,
                          child: Text(
                            Strings.label.kRegister,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
}
