import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_media/features/login/login_provider.dart';
import '../../config/colorpalette.dart';
import '../../config/font/font.dart';
import '../../widgets/custome_elivated_button.dart';
import '../../widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    var prov = Provider.of<LoginProvider>(context, listen: false);
    prov.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<LoginProvider>(builder: (context, prov, _) {
      return Scaffold(
        backgroundColor: ColorPalette.themeColor,
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 24),
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 10),
                        // const  SizedBox(height: 80),
                        _buildLogo(),
                        SizedBox(
                          height: height / 10,
                        ),
                        Align(
                          child: _buildLoginTitle(),
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          // height: 18,
                          height: height / 32,
                        ),
                        Form(
                            key: prov.loginKey,
                            child: Column(
                              children: [
                                TextFieldWidget(
                                    hintText: "Email",
                                    controller: prov.loginEmailController,
                                    validate: (value) {
                                      return prov.validateLoginForm(
                                          value!, loginFormField.email);
                                    }),
                                SizedBox(
                                  height: height / 30,
                                ),
                                TextFieldWidget(
                                    hintText: "Password",
                                    controller: prov.loginPasswordController,
                                    validate: (value) {
                                      return prov.validateLoginForm(
                                          value!, loginFormField.password);
                                    },
                                    enableObsecureText: true,
                                  toggleObsecure: prov.obsecureText,
                                  onTapObscure: (){
                                      prov.toggleObsecureText();
                                  },
                                ),
                                SizedBox(
                                  height: height / 120,
                                ),
                                _buildForgotSection(prov),
                                SizedBox(
                                  height: height / 40,
                                ),
                                CustomElivatedButton(
                                  buttonText: 'Login',
                                  loading: prov.loading,
                                  callback: () async {
                                    if (prov.loginKey.currentState
                                            ?.validate() ==
                                        true) {
                                      await prov.login();
                                      if (prov.loggedIn) {
                                        context.go("/Home");
                                      }
                                    }
                                  },
                                ),
                              ],
                            )),
                        SizedBox(
                          height: height / 180,
                        ),
                        _buildSignupOption()
                      ],
                    ),
                  ),
                ))),
      );
    });
  }

  //To create logo
  _buildLogo() {
    return Container(
      height: MediaQuery.of(context).size.height / 9,
      width: MediaQuery.of(context).size.width / 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          child:
              ClipOval(child: SvgPicture.asset("assets/images/app_logo.svg")),
          backgroundColor: ColorPalette.primaryColor,
        ),
      ),
    );
  }

  //To create Remember me  and Forgot pass section
  _buildForgotSection(LoginProvider prov) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
              value: prov.reminderCheck,
              onChanged: (value) {
                prov.reminderCheck = value!;
                setState(() {});
              },
              activeColor: Colors.blue,
              side: const BorderSide(
                width: 1,
                color: Color(0xffB6B6B6),
              )),
        ),
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          child: Text(
            "Remember me",
            style: RobotoFonts.regular(
              fontSize: 14,
              color: Color(0xff575757),
            ),
          ),
        ),
        const Spacer(),
        TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: RobotoFonts.regular(
                fontSize: 14,
                color: ColorPalette.primaryBlue,
              ),
            ))
      ],
    );
  }

  //To create login title
  _buildLoginTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: RobotoFonts.semiBold(
              fontSize: 18, color: ColorPalette.headingColor.withOpacity(0.8)),
        ),
        const SizedBox(
          width: 18,
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


  //To create sign up option if not registered
  _buildSignupOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
            style: RobotoFonts.regular(
                color: ColorPalette.hintTestColor, fontSize: 14)),
        TextButton(
            onPressed: () {
              context.go('/Signup');
            },
            child: Text(
              'Sign Up',
              style: RobotoFonts.medium(
                  fontSize: 16, color: ColorPalette.primaryBlue),
            ))
      ],
    );
  }
}
