import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:models/user/user_model.dart' as user;
import 'package:services/services/connection_manager.dart';
import 'package:services/services/graphql_services.dart';
import 'package:social_media/config/font/font.dart';

import '../../config/keys.dart';

enum loginFormField { email, password }

class LoginProvider with ChangeNotifier {
  bool reminderCheck = false;
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GraphQLService _graphQlService=GraphQLService();
  bool loading = false;
  bool loggedIn = false;
  bool obsecureText=true;
  user.User? loggedInUser;


  //To initialise the default values of variables
  init() {
    loading = false;
    loggedIn = false;
    obsecureText=true;
    // loginPasswordController.clear();
    loginPasswordController.text="kunal123";
    loginEmailController.text="kunalgaonkar102@gmail.com";
    // loginEmailController.clear();
  }


  //To toggle obsecureText
  toggleObsecureText(){
    obsecureText=!obsecureText;
    notifyListeners();
  }


  //To login using firebase email authentication and get user using from graphql api
  Future<void> login() async {
    loading = true;
    notifyListeners();
    UserCredential userCredential;
    bool isConnected = await ConnectionManager.isConnected();
    if (isConnected) {
      try {
        userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: loginEmailController.text,
            password: loginPasswordController.text);

          //To check if email is verified
        if(userCredential.user!.emailVerified){
          //To get the user using graphql api
          loggedInUser =  await _graphQlService.getUser(id:userCredential.user!.uid);
          if(loggedInUser!=null){
            _showSnackBar(
              "Login Successful",
              Colors.green,
            );
            loggedIn = true;
            notifyListeners();
          }else{
            _showSnackBar(
              "user not found",
              Colors.green,
            );
          }
        }else{
          _showSnackBar(
            "Verify your email,Verification mail has been sent",
            Colors.red,
          );
        }
      } on FirebaseAuthException catch (error) {
        _showSnackBar(error.code.toString().toLowerCase(), Colors.redAccent);
      } catch (error) {
        _showSnackBar(error.toString().toLowerCase(), Colors.redAccent);
      }
    } else {
      _showSnackBar(
        "Please check your internet connection",
        Colors.red,
      );
    }
    loading = false;
    notifyListeners();
  }

  //To show informative snack bar
  _showSnackBar(String value, Color color) {
    return Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      elevation: 3,
      content: Center(
          child: Text(
        value,
        style: RobotoFonts.regular(color: color, fontSize: 15),
      )),
      backgroundColor: Color(0xff0C0C14),
    ));
  }

  //To validate the login form
  String? validateLoginForm(String value, loginFormField type) {
    switch (type) {
      case (loginFormField.email):
        if (value.isEmpty) {
          return "Please enter email";
        } else {
          bool isValid = validateEmail(value);
          return isValid ? null : "Please enter valid email";
        }
      case loginFormField.password:
        if (value.isEmpty) {
          return "Please enter password";
        } else {
          return null;
        }
    }
  }

  //expression to validate email
  bool validateEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }
}
