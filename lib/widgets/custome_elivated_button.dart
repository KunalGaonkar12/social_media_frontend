import 'package:flutter/material.dart';

import '../config/colorpalette.dart';
import '../config/font/font.dart';


class CustomElivatedButton extends StatelessWidget {
  CustomElivatedButton({ required this.buttonText,required this.callback,this.loading=false});
  String buttonText;
  bool? loading;
  VoidCallback callback;


  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: callback,
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(ColorPalette.primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        child:loading!?CircularProgressIndicator(color: Colors.white,):Text(buttonText,
            style: RobotoFonts.medium(color: Colors.white,fontSize: 16)),
      ),
    );
  }
}
