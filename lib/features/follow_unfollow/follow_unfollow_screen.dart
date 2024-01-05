import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/user/user_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_media/features/follow_unfollow/follow_unfollow_provider.dart';
import 'package:social_media/features/login/login_provider.dart';
import 'package:social_media/widgets/user_card.dart';

import '../../config/colorpalette.dart';
import '../../config/font/font.dart';
import '../../widgets/search_bar.dart';

class FollowUnFollowScreen extends StatefulWidget {
  User? user;

  FollowUnFollowScreen({this.user});

  @override
  State<FollowUnFollowScreen> createState() => _FollowUnFollowScreenState();
}

class _FollowUnFollowScreenState extends State<FollowUnFollowScreen> {

  //To set initial values
  @override
  void initState() {
    var prov = Provider.of<FollowUnFollowProvider>(context, listen: false);
    var loginProv = Provider.of<LoginProvider>(context, listen: false);
    prov.init(loginProv.loggedInUser!.id);
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
        length: 2,
        child:
            Consumer<FollowUnFollowProvider>(builder: (context, prov, child) {
          return MaterialApp(
            home: Scaffold(
              appBar: _buildAppBar(height, width),
              backgroundColor: ColorPalette.themeColor,
              body: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width / 30, vertical: height / 45),
                      child: CustomSearchBar(
                        controller: prov.searchController,
                        onChanged: (value) async {
                          int currentIndex =
                              DefaultTabController.of(context).index;
                          if (currentIndex == 0) {
                            await prov.onChangedSearch(value, prov.allUsers);
                          } else {
                            await prov.onChangedSearch(
                                value, prov.followedUsers);
                          }
                          },
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints.expand(height: 50),
                      child: TabBar(
                        enableFeedback: false,
                        indicatorColor: ColorPalette.primaryColor,
                        unselectedLabelColor: Color(0xff909090),
                        tabs: [
                          Tab(
                            child: Text(
                              "All Users(${prov.filteredAllUsers.length})",
                            ),
                          ),
                          Tab(
                            child: Text(
                                "Following(${prov.filteredFollowedUsers.length})"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 60,
                    ),
                    Expanded(
                      child: Container(
                        child: TabBarView(
                          children: [
                            _buildUserList(prov, prov.filteredAllUsers),
                            _buildUserList(prov, prov.filteredFollowedUsers),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  //to create app bar
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
              title: Text("Follow & UnFollow",
                  style: RobotoFonts.medium(
                      color: ColorPalette.hintTestColor, fontSize: width / 20)),
              toolbarHeight: height / 10,
            )));
  }


  //To build all user list and followed user list
  _buildUserList(FollowUnFollowProvider prov, List<User> users) {
    User user = User(
        id: "122345dfssf",
        fullName: "kunalgaokar",
        userName: "king123",
        email: "kunalgaonkar102@gmail.com");
    return prov.isLoading
        ? Skeletonizer(
           enabled: true,
      effect: ShimmerEffect(baseColor: Colors.white.withOpacity(0.05),highlightColor: Colors.grey.withOpacity(0.13),),
      containersColor: Colors.white.withOpacity(0.05),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return UserCard(
                  user: user,
                  onTapDown: () {},
                  );
                  },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.white10.withOpacity(0.03),
                    thickness: 2,
                  );
                },
                itemCount: 10),
          )
        : users.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  var user = users[index];
                return  UserCard(
                          user: user,
                          onTapDown: () async {
                            var loginProv = Provider.of<LoginProvider>(context, listen: false);
                            await prov.updateFollowUnFollow(
                                user.id, loginProv.loggedInUser!.id);
                          },
                        );
                      // : SizedBox.shrink();
                },
                separatorBuilder: (context, index) {
                 return Divider(
                          color: Colors.white10.withOpacity(0.03),
                          thickness: 2,
                        );

                },
                itemCount: users.length)
            : Center(
                child: Text("No Users",
                    style: RobotoFonts.medium(
                        color: Color(0xffDDDDDD), fontSize: 15)),
              );
  }

}
