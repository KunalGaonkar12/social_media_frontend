import 'package:flutter/material.dart';
import 'package:models/user/user_model.dart';
import 'package:provider/provider.dart';
import 'package:social_media/config/colorpalette.dart';
import 'package:social_media/features/follow_unfollow/follow_unfollow_provider.dart';

import '../config/font/font.dart';

class UserCard extends StatelessWidget {
  User user;
  Function()? onTapDown;

  UserCard({required this.user,this.onTapDown});

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<FollowUnFollowProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height / 70),
        child: Row(
          children: [
            SizedBox(
              width: width / 30,
            ),
            Container(
              height: height / 14,
              child: ClipRRect(
                child: Image.asset("assets/images/default_profile_pic.jpg",
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(
              width: width / 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: width / 2.4,
                    child: Text(
                      user.userName,
                      style: RobotoFonts.medium(
                          color: Color(0xffDDDDDD), fontSize: width / 26),
                    )),
                SizedBox(
                  height: height / 90,
                ),
                Text(
                  user.fullName,
                  style: RobotoFonts.regular(
                      color: Color(0xff919191), fontSize: width / 30),
                ),
              ],
            ),
            SizedBox(
              width: width / 18,
            ),
            _buildButton(height,width),
            SizedBox(
              width: width / 30,
            ),
          ],
        ),
      ),
    );
  }


  _buildButton(double height,double width){

   return GestureDetector(
     onTap: onTapDown,
     child: Container(
          width: width / 3.8,
          height: height / 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: user.isFollowed
                ? Color(0xff1D1D1D):ColorPalette.primaryColor,
          ),
          child: Center(
            child: Text(
              "${user.isFollowed ? "UnFollow" : "Follow"}",
              style: RobotoFonts.regular(
                  color: user.isFollowed
                      ? Colors.white
                      : Color(0xffD0D0D0),
                  fontSize: width / 28),
            ),
          )),
   );
  }
}
