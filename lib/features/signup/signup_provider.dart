

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:services/services/connection_manager.dart';
import 'package:services/services/graphql_services.dart';

import '../../config/font/font.dart';
import '../../config/keys.dart';
enum formField{
  fullName,email,password,userName
}

class SignUpProvider with ChangeNotifier{

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  TextEditingController fullNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController signUpPasswordController= TextEditingController();
  TextEditingController userNameController= TextEditingController();
  GraphQLService _graphQlService=GraphQLService();

  GlobalKey<FormState> signUpKey= GlobalKey<FormState>();
  bool loading = false;
  bool signedUp = false;
  bool obsecureText=true;

  init(){
    reset();
    loading = false;
    signedUp = false;
    obsecureText=true;
  }

  reset(){
    fullNameController.clear();
    emailController.clear();
    signUpPasswordController.clear();
    userNameController.clear();
  }

  //To toggle obsecureText
  toggleObsecureText(){
    obsecureText=!obsecureText;
    notifyListeners();
  }


  //To validate the signup form
  String? validateSignupForm(String value,formField type){
    switch(type){
      case  (formField.fullName):
        if(value.isEmpty){
          return "Please enter fullname";
        }else{
          return null;
        }
      case formField.email:
        if(value.isEmpty){
          return "Please enter email";
        }else{
          bool isValid=validateEmail(value);
         return isValid ? null:"Please enter valid email";
        }
      case formField.password:
        if(value.isEmpty){
          return "Please enter password";
        }else{
          return null;
        }
        case formField.userName:
        if(value.isEmpty){
          return "Please enter username";
        }else{
          return null;
        }
    }
  }

  bool validateEmail(String value){
   return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }


  //To signup with email and create user using graphql api
  Future<void> authentication() async {
    loading = true;
    notifyListeners();
    UserCredential userCredential;
    bool isConnected = await ConnectionManager.isConnected();
    if (isConnected) {
      try {

        //To sign up using firebase email authentication
        userCredential = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: signUpPasswordController.text);


        await userCredential.user!.sendEmailVerification();

        //To add self as follower
        List<String> followers=[];
        followers.add(userCredential.user!.uid);

        //To create user using graphql api
       String result=await _graphQlService.createUser(email: userCredential.user!.email!, fullName: fullNameController.text, id: userCredential.user!.uid, userName: userNameController.text,followers: followers);

       if(result==userCredential.user!.uid){



         await firebaseFirestore
             .collection("Users")
             .doc(userCredential.user!.uid)
             .set({
           "email": userCredential.user!.email,
           "uid": userCredential.user!.uid,
           "full_name": fullNameController.text,
           "user_name": userNameController.text,
           "password": signUpPasswordController.text,
         });

         _showSnackBar("Verify your email and login", Colors.green);
         signedUp = true;
         notifyListeners();
       }
      } on FirebaseAuthException catch (error) {
        _showSnackBar(error.code.toString().toLowerCase(), Colors.redAccent);
      } catch (error) {
        _showSnackBar(error.toString().toLowerCase(), Colors.redAccent);
      }
    }else{
      _showSnackBar(
        "Please check your internet connection",
        Colors.red,
      );
    }
    loading = false;
    notifyListeners();
  }

  _showSnackBar(String value,Color color){
    return Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      elevation: 3,
      content: Center(
          child: Text(
            value,
            style: RobotoFonts.regular(color:color,fontSize: 15),
          )),
      backgroundColor: Color(0xff0C0C14),
    ));
  }


}