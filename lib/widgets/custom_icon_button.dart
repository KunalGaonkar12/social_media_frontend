import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  double height;
  double width;
  GestureTapCallback? onTap;
  IconData icon;
   CustomIconButton({required this.width,required this.height,this.onTap,required this.icon}) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
          height: height/20,
          width: width/11,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black.withOpacity(0.2)
          ),
          child: Align(
              alignment: Alignment.center,
              child: Icon(icon,color: Colors.white.withOpacity(0.8),size: width/15,))),
    );
  }
}
