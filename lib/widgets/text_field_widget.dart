import 'package:flutter/material.dart';

import '../config/colorpalette.dart';
import '../config/font/font.dart';


class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({required this.hintText,required this.controller,this.validate,this.enableObsecureText=false,this.toggleObsecure=false,this.onTapObscure, this.labelText});

  String hintText;
 String? labelText;
  TextEditingController controller;
  bool enableObsecureText;
  bool toggleObsecure;
 String? Function(String?)? validate;
  VoidCallback? onTapObscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
  obscureText: toggleObsecure,
  validator: validate,
      style: RobotoFonts.regular(color: ColorPalette.hintTestColor.withOpacity(0.8),fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: ColorPalette.primaryColor),
        ),
        labelText: labelText??"",
        suffixIcon:enableObsecureText? IconButton(
          icon: Icon(toggleObsecure ? Icons.visibility : Icons.visibility_off),
          onPressed:onTapObscure
        ):null,
        labelStyle: RobotoFonts.regular(color:ColorPalette.hintTestColor.withOpacity(0.5),fontSize: 16 ),
        focusedBorder:  const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: ColorPalette.primaryColor),
        ),
        errorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
        border: InputBorder.none,
        hintStyle: RobotoFonts.regular(color: ColorPalette.hintTestColor.withOpacity(0.5),fontSize: 16),
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 3, color: ColorPalette.hintTestColor.withOpacity(0.2)),
        ),
      ),
    );
  }
}
