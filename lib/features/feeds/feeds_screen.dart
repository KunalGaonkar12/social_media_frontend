import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_media/features/feeds/feeds_screen_provider.dart';
import 'package:social_media/features/login/login_provider.dart';

import '../../config/colorpalette.dart';
import '../../config/font/font.dart';
import '../../widgets/feeds_card.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  //To set the initial values
  @override
  void initState() {
    var prov = Provider.of<FeedsScreenProvider>(context, listen: false);
    var loginProv = Provider.of<LoginProvider>(context, listen: false);
    prov.init(loginProv.loggedInUser!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<FeedsScreenProvider>(builder: (context, prov, _) {
      return Scaffold(
        appBar: _buildAppBar(height, width),
        backgroundColor: ColorPalette.themeColor,
        body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width / 25, vertical: height / 45),
            child: prov.isLoading
                ? Skeletonizer(
                    enabled: true,
                    containersColor: Colors.grey.withOpacity(0.1),
                child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Post post=Post(userId: "", imageUrl: "", caption: "", userName: "");
                        return FeedsCard(
                          post: post,
                        );
                        },
                      itemCount: 5,
                    ))
                : prov.posts.isNotEmpty
                    ? Container(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            var post = prov.posts[index];
                            return FeedsCard(
                              post: post,
                            );
                          },
                          itemCount: prov.posts.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: width / 15,
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text("No Users",
                            style: RobotoFonts.medium(
                                color: Color(0xffDDDDDD), fontSize: 15)),
                      )),
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
              title: Text("Social",
                  style: RobotoFonts.semiBold(
                      color: ColorPalette.primaryColor, fontSize: 28)),
              toolbarHeight: height / 14,
              actions: [
                SvgPicture.asset("assets/images/notification.svg",
                    height: height / 34),
                SizedBox(
                  width: width / 12,
                ),
                GestureDetector(
                  onTap: (){
                    context.go("/");
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
}
