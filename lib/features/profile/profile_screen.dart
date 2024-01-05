import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:models/user/user_model.dart' as user;
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_media/features/profile/profile_provider.dart';
import 'package:social_media/widgets/multiOptionAlert.dart';

import '../../config/colorpalette.dart';
import '../../config/font/font.dart';
import '../login/login_provider.dart';

class ProfileScreen extends StatefulWidget {
  user.User? LoggedInUser;

  ProfileScreen(this.LoggedInUser, {Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    var prov = Provider.of<ProfileProvider>(context, listen: false);
    var loginProv = Provider.of<LoginProvider>(context, listen: false);
    prov.init(loginProv.loggedInUser!.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<ProfileProvider>(builder: (context, prov, _) {
      return Scaffold(
        appBar: _buildAppBar(height, width),
        body: _buildBody(height, width, prov),
        backgroundColor: ColorPalette.themeColor,
      );
    });
  }

  //To create app bar
  _buildAppBar(double height, double width) {
    return PreferredSize(
        preferredSize: Size.fromHeight(height / 14),
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Colors.white10.withOpacity(0.03))),
            ),
            child: AppBar(
              // leading: Text("Social",style:RobotoFonts.bold(color: Colors.white,fontSize: 20)),
              backgroundColor: Color(0xff0C0C13),
              title: Text(widget.LoggedInUser!.userName,
                  style: RobotoFonts.semiBold(
                      color: ColorPalette.hintTestColor, fontSize: 20)),
              toolbarHeight: height / 14,
              actions: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return MultiOptionAlertDialog(
                            title: "Logout!",
                            content: "Do you want to logout?",
                            primaryActionText: "Yes",
                            secondaryActionText: "No",
                            onPressedPrimary: () {
                              context.go("/");
                            },
                            onPressedSecondary: () {
                              context.pop();
                            },
                          );
                        });
                  },
                  child: SvgPicture.asset("assets/images/turnoff.svg",
                      height: height / 34),
                ),
                SizedBox(
                  width: width / 20,
                ),
              ],
            )));
  }

  _buildBody(double height, double width, ProfileProvider prov) {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 25, vertical: height / 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height / 11,
                child: ClipRRect(
                  child: Image.asset(
                    "assets/images/default_profile_pic.jpg",
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(height: height / 70),
              Text(
                widget.LoggedInUser!.fullName,
                style:
                    RobotoFonts.regular(fontSize: 15, color: Color(0xffDDDDDD)),
              ),
              Text(
                widget.LoggedInUser!.email,
                style:
                    RobotoFonts.regular(fontSize: 15, color: Color(0xffDDDDDD)),
              ),
              SizedBox(height: height / 50),
              Text(
                "My Posts",
                style: RobotoFonts.bold(fontSize: 15, color: Color(0xffDDDDDD)),
              ),
              SizedBox(height: height / 70),
              prov.isLoading
                  ? Skeletonizer(
                  enabled: true,
                  containersColor: Color(0xff0C0C14),
                  effect: ShimmerEffect(baseColor: Colors.white.withOpacity(0.05),highlightColor: Colors.grey.withOpacity(0.13),),
                      child: GridView.builder(
                        shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            width: width,
                            height: height / 2.5,
                            child: Image.asset(
                                "assets/images/default_feed_image.jpg",fit: BoxFit.cover),
                          );
                        },))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: prov.myPosts.length,
                      itemBuilder: (context, index) {
                        var post = prov.myPosts[index];
                        Uint8List bytes = base64.decode(post.imageUrl);
                        return Container(
                          width: width,
                          height: height / 2.5,
                          child: bytes.isNotEmpty
                              ? Image.memory(bytes, fit: BoxFit.cover)
                              : Image.asset(
                                  "assets/images/default_feed_image.jpg"),
                        );
                      },
                    )
            ],
          )),
    );
  }
}
