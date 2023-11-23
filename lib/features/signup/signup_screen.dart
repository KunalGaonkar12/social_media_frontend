import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media/features/signup/signup_provider.dart';
import '../../config/colorpalette.dart';
import '../../config/font/font.dart';
import '../../widgets/custome_elivated_button.dart';
import '../../widgets/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  @override
  void initState() {
  var prov=Provider.of<SignUpProvider>(context,listen: false);
  prov.init();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Consumer<SignUpProvider>(builder: (context,prov,_){
      return  Scaffold(
        backgroundColor: ColorPalette.themeColor,
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width/24),
              child:
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height/10),
                      // const  SizedBox(height: 80),
                      _buildLogo(),
                      SizedBox(
                        height: height/10,
                      ),
                      Align(
                        child: _buildLoginTitle(),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        // height: 18,
                        height: height/32,
                      ),
                      Form(
                        key: prov.signUpKey,
                          child: Column(
                            children: [
                              TextFieldWidget(hintText: "Full Name",labelText: "Full name",controller: prov.fullNameController,
                                  validate: (value){
                                    return prov.validateSignupForm(value!, formField.fullName);
                              }),
                              SizedBox(
                                height: height/30,
                              ),
                              TextFieldWidget(hintText: "User Name",labelText: "User Name",controller: prov.userNameController,validate: (value){
                                return prov.validateSignupForm(value!, formField.userName);
                              },),
                              SizedBox(
                                height: height/30,
                              ),
                              TextFieldWidget(hintText: "Email",labelText: "Email",controller: prov.emailController,validate: (value){
                                return prov.validateSignupForm(value!, formField.email);
                              },),
                              SizedBox(
                                height: height/30,
                              ),
                              TextFieldWidget(hintText: "Password",labelText: "Password",controller: prov.signUpPasswordController,validate: (value){
                                return prov.validateSignupForm(value!, formField.password);
                              },enableObsecureText: true,toggleObsecure: prov.obsecureText,onTapObscure: (){
                                prov.toggleObsecureText();
                              },),
                              SizedBox(
                                height: height/30,
                              ),
                              CustomElivatedButton(
                                buttonText: 'Sign Up',
                                loading: prov.loading,
                                callback: ()async{
                                  // print(prov.fullNameController.text);
                                  // print(prov.emailController.text);
                                  // print(prov.signUpPasswordController.text);
                                  // print(prov.signUpKey.currentState?.validate());
                                  if(prov.signUpKey.currentState?.validate()==true){
                                   await  prov.authentication();
                                   if(prov.signedUp){
                                     context.go("/");
                                   }

                                  }
                                },
                              )
                            ],
                          )),
                      SizedBox(
                        height: height/180,
                      ),
                      _buildSignupOption()
                    ],
                  ),
                ),
              )

            )),
      );
    });
  }

  //To create logo
  _buildLogo(){
    return  Container(
      height: MediaQuery.of(context).size.height/9,
      width: MediaQuery.of(context).size.width/5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child: ClipOval(child: SvgPicture.asset("assets/images/app_logo.svg")),
          backgroundColor: ColorPalette.primaryColor,
        ),
      ),
    );
  }

//To create signup title
  _buildLoginTitle(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sign Up",
          style: RobotoFonts.semiBold(
              fontSize: 18, color: ColorPalette.headingColor.withOpacity(0.8)),
        ),
       const SizedBox(
          width:18,
          // width:24,
          child: Divider(
            color: ColorPalette.primaryColor,
            thickness: 3,
            height: 5,
          ),
        ),
      ],
    );
  }


  //To create login option if already have an account
  _buildSignupOption(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Do you have an account?",
            style: RobotoFonts.regular(
                color: ColorPalette.hintTestColor, fontSize: 14)),
        TextButton(
            onPressed: () {
            context.go("/");
            },
            child: Text(
              'Login',
              style: RobotoFonts.medium(
                  fontSize: 16, color: ColorPalette.primaryBlue),
            ))
      ],
    );
  }

}
