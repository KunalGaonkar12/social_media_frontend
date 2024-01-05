import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_media/features/profile/profile_screen.dart';
import '../../config/colorpalette.dart';
import '../add_post/create_post_screen.dart';
import '../feeds/feeds_screen.dart';
import '../follow_unfollow/follow_unfollow_screen.dart';
import '../login/login_provider.dart';

class HomeScreen extends StatefulWidget {
  String? id;
  HomeScreen({this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin<HomeScreen> {

  int _currentIndex=0;
  Color selectedColor=ColorPalette.primaryColor;
  late TabController bottomTabController;


  // to set initial values and set the bottom tab bar
  @override
  void initState() {
    super.initState();
    bottomTabController = TabController(length: 4, vsync: this,initialIndex: 3);
    bottomTabController.addListener(() {
      if(kDebugMode){
        print("HomeScreen Current Index ${bottomTabController.index}");
      }
      int currenntIndex = bottomTabController.index;
      bottomTabController.animateTo(currenntIndex);
      setState(() {});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorPalette.themeColor,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(height,width,bottomTabController)
    );
  }



  //to build the body with all functionality  screens
  _buildBody(){
    var loginProv = Provider.of<LoginProvider>(context, listen: false);
    return TabBarView(controller: bottomTabController,physics:const NeverScrollableScrollPhysics(),children: <Widget>[
      FeedsScreen(),
      FollowUnFollowScreen(),
      CreatePostScreen(bottomTabController: bottomTabController),
    ProfileScreen(loginProv.loggedInUser),
// Center(child: Text("Page 4",style: TextStyle(color: Colors.white),)),
    ]);
  }
  

//TO navigate to different screens
   _buildBottomNavBar(double height,double width,TabController controller) {
    return Container(
      decoration:  BoxDecoration(
          border: Border(top: BorderSide(width: 1,color:Colors.white10.withOpacity(0.03) ))
      ),
      height: height/11,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,

        backgroundColor: Color(0xff0C0C13),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          backgroundColor: Color(0xff0C0C13),

              icon: SvgPicture.asset(controller.index==0?"assets/images/home_selected.svg":"assets/images/home.svg",),
              label: '',

          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/images/search.svg",color: controller.index==1?ColorPalette.primaryColor:Color(0xffD0D0D0),),
              label: '',
              backgroundColor: Color(0xff0C0C13),
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(controller.index==2?"assets/images/add_selected.svg":"assets/images/add.svg"),
              label: '',
              backgroundColor: Color(0xff0C0C13)
          ),
          // BottomNavigationBarItem(
          //     icon: SvgPicture.asset(
          //        controller.index==3?"assets/images/follower_selected.svg":"assets/images/follower.svg"
          //     ),
          //     label: '',
          //     backgroundColor: Color(0xff0C0C13),
          // ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
               controller.index==4?"assets/images/profile_selected.svg":"assets/images/profile.svg"
              ),
              label: '',
              backgroundColor: Color(0xff0C0C13)
          ),
        ],
        currentIndex: _currentIndex,

        iconSize: height/24,
        selectedItemColor:selectedColor,
        selectedIconTheme: IconThemeData(opacity: 0.0),
        onTap: (value){
          setState(() {
            _currentIndex=value;
            controller.animateTo(value);
            selectedColor=ColorPalette.primaryColor;
          });
        },
      ),
    );
  }
}
