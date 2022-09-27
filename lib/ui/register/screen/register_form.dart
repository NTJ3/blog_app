import 'dart:developer';

import 'package:blog_app/core/constant/text_styles.dart';
import 'package:blog_app/core/index.dart';
import 'package:blog_app/core/util/snackbar.dart';
import 'package:blog_app/ui/home/screens/home_page.dart';
import 'package:blog_app/ui/login/screen/login_page.dart';
import 'package:blog_app/ui/register/bloc/register.dart';
import 'package:blog_app/ui_components/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RegisterBloc registerBloc;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _userName;
  late String _password;
  late String _email;

  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of<RegisterBloc>(context);
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onRegisterButtonPressed() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      _formKey.currentState!.save();
      // SharedPreferenceHelper.setToken('$_userName$_password');

      registerBloc.add(RegisterButtonPressed(
        context: context,
        username: _userName,
        password: _password,
        email: _email,
      ));
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  void _redirectToLoginPage() {
    _fieldFocusChange(context, _passwordFocus, FocusNode());
    _formKey.currentState!.reset();
    setState(() {
      _autoValidateMode = AutovalidateMode.disabled;
    });
    Navigator.pushNamed(context, LoginPage.tag);
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
  Widget build(BuildContext context) => BlocConsumer<RegisterBloc,
          RegisterState>(
      key: _scaffoldKey,
      listener: (context, state) {
        log.info('===> listener $state');
        if (state is RegisterFailure) {
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
        } else if (state is RegisterSuccess) {
          _autoValidateMode = AutovalidateMode.disabled;
          showToast(Strings.message.kRegistrationSuccess, context);
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
                          focusNode: _usernameFocus,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) => _userName = value?.trim() ?? "",
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _usernameFocus, _emailFocus);
                          },
                          validator: Validator.validateUserName,
                          decoration: TextStyles.getInputDecoration().copyWith(
                            hintText: Strings.hint.kUserName,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) => _email = value?.trim() ?? "",
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _emailFocus, _passwordFocus);
                          },
                          validator: Validator.validateEmail,
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
                            _onRegisterButtonPressed();
                          },
                          validator: Validator.validatePassword,
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
                                showLoader: state is RegisterLoading,
                                text: Strings.button.kRegister,
                                textColor: Colors.white,
                                backgroundColor: Colors.blue,
                                onPressed: _onRegisterButtonPressed,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: CustomAppButton(
                                text: Strings.button.kRegisterWithGoogle,
                                textColor: Colors.white,
                                backgroundColor: Colors.blue,
                                onPressed: _handleSignIn,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _redirectToLoginPage,
                          child: Text(
                            '${Strings.label.kAlreadyMember}? \t  Go ${Strings.label.kBackToLogin}',
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
