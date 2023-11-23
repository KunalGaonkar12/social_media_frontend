import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:models/post/post_model.dart';
import 'package:provider/provider.dart';
import 'package:social_media/config/font/font.dart';

import '../features/feeds/feeds_screen_provider.dart';

class FeedsCard extends StatelessWidget {
  final Post post;
  final GestureTapCallback? onTap;

   FeedsCard({Key? key, required this.post, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Consumer<FeedsScreenProvider>(builder:(context,prov,_){
      return  Container(
          decoration: BoxDecoration(
            color:Color(0xff0C0C14),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 0.8), // changes the shadow direction
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height/35,
              ),
              _buildProfileInfo(height,width),
              SizedBox(
                height: height/35,
              ),
              _buildImage(height,width,prov),
              SizedBox(
                height: height/40,
              ),
              _buildActionBar(height,width),
              SizedBox(
                height: height/36,
              ),
              _buildDetails(height,width,context),
              SizedBox(
                height: height/45,
              ),
            ],
          )
      );
    });



  }

  _buildProfileInfo(double height,double width){
    return Row(
      children: [
        SizedBox(
          width:width/20,
        ),
        Container(height: width/11,
          child: ClipRRect(
            child:Image.asset("assets/images/default_profile_pic.jpg",fit: BoxFit.fill,),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        SizedBox(
          width: width/26,
        ),
        Text(post.userName,style: RobotoFonts.medium(color: Color(0xffDDDDDD),fontSize: width/26),)
      ],
    );
  }

  _buildImage(double height,double width,FeedsScreenProvider prov){
    Uint8List bytes = base64.decode(post.imageUrl);
    return Container(
      width:width,height: height/2.5,
      child: bytes.isNotEmpty?Image.memory(bytes,fit: BoxFit.cover):Image.asset("assets/images/default_feed_image.jpg"),
    );
  }

  _buildActionBar(double height,double width){
    return Row(
      children: [
        SizedBox(
          width:width/20,
        ),
        GestureDetector(
          child: SvgPicture.asset("assets/images/unlike_icom.svg",height: height/30),
        ) ,
        SizedBox(
          width: width/20,
        ),
        GestureDetector(
          child: SvgPicture.asset("assets/images/comment.svg",height: height/30),
        ),SizedBox(
          width: width/20,
        ),
        GestureDetector(
          child: SvgPicture.asset("assets/images/share.svg",height: height/30),
        )
      ],
    );
  }

  _buildDetails(double height,double width,BuildContext context){
    bool isMoreVisible=true;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: width/20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child:
                Text(post.caption,
                    style: RobotoFonts.regular(fontSize: width/28,color: Color(0xffA7A7A7)),maxLines: post.enableMore?100:2,overflow: TextOverflow.ellipsis),
          ),
          Visibility(
            visible: isMoreVisible,
            child: GestureDetector(onTap: onTap,child: Text("more",style: RobotoFonts.regular(color: Color(0xff919191),fontSize: width/30)),),
          ),
          SizedBox(height: height/60,),
          Text("view all 200 comments",style: RobotoFonts.regular(fontSize: width/30,color: Color(0xffDDDDDD))),
          SizedBox(height: height/60,),
          Text(DateFormat('dd MMM yyyy').format(post.date??DateTime.now()),style: RobotoFonts.regular(fontSize: width/30,color: Color(0xff919191)))

        ],
      ),
    );
  }
}
