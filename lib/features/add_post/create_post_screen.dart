import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:models/user/user_model.dart';
import 'package:provider/provider.dart';
import 'package:social_media/features/login/login_provider.dart';
import 'package:social_media/widgets/search_bar.dart';

import '../../config/colorpalette.dart';
import '../../config/font/font.dart';
import '../../widgets/custom_icon_button.dart';
import 'create_post_provider.dart';

class CreatePostScreen extends StatefulWidget {
  late TabController bottomTabController;
   CreatePostScreen({Key? key,required this.bottomTabController}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  //To set the initial values
  @override
  void initState() {
    var prov = Provider.of<CreatePostProvider>(context, listen: false);
    var loginProv = Provider.of<LoginProvider>(context, listen: false);
    prov.init(loginProv.loggedInUser!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Consumer<CreatePostProvider>(builder: (context, prov, child) {
      return Scaffold(
        appBar: _buildAppBar(prov, height, width),
        backgroundColor: ColorPalette.themeColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildSelectedImageDisplay(height, width, prov),
              SizedBox(
                height: height / 30,
              ),
              _buildCaptionField(prov, height, width),
              SizedBox(
                height: height / 30,
              ),
              Text(
                "Tags",
                style: RobotoFonts.medium(
                    color: Colors.white.withOpacity(0.5), fontSize: 15),
              ),
              SizedBox(
                height: height / 30,
              ),
            ],
          ),
        ),
      );
    });
  }


  //To component display the selected image and perform functions such as add image from gallery and camera ,also to tag people
  _buildSelectedImageDisplay(
      double height, double width, CreatePostProvider prov) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Container(
            // height: height / 2,
            // width: width,
            height: 350,
            width: 400,
            decoration: BoxDecoration(color: Color(0xff08080D)),
            child: prov.selectedFile == null
                ? Center(
                    child: Text(
                    "No image Selected",
                    style: RobotoFonts.regular(
                        fontSize: width / 30, color: Color(0xff909090)),
                  ))
                : Image.file(
                    prov.selectedFile!,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
              right: width / 20,
              bottom: height / 30,
              child: Row(
                children: [
                  CustomIconButton(
                      height: height,
                      width: width,
                      icon: Icons.image,
                      onTap: () async {
                        await prov.pickAndCropImage(fromGallery: true);
                      }),
                  SizedBox(
                    width: width / 20,
                  ),
                  CustomIconButton(
                      height: height,
                      width: width,
                      icon: Icons.add_a_photo,
                      onTap: () async {
                        await prov.pickAndCropImage(fromGallery: false);
                      }),
                ],
              )),
          Positioned(
              bottom: height / 30,
              left: width / 20,
              child: CustomIconButton(
                icon: Icons.person,
                height: height,
                width: width,
                onTap: () {
                  _openBottomSheet(context, prov);
                },
              ))
        ],
      );
    });
  }


  //To display all the followed users so that we can tag them in post
  void _openBottomSheet(BuildContext context, CreatePostProvider prov) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Color(0xff08080D),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height / 40, horizontal: width / 30),
                child: CustomSearchBar(
                    controller: prov.searchController,
                    onChanged: (value) async {
                      await prov.onChangedSearch(value);
                      setState(() {});
                    }),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: prov.followedUsers.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                User user = prov.followedUsers[index];
                                return user.didQueryMatch
                                    ? GestureDetector(
                                        onTap: () {
                                          prov.setSelected(user.id);
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Color(0xffFFFFFF)
                                              .withOpacity(0.03),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: height / 70),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: width / 30,
                                                ),
                                                Container(
                                                  height: height / 14,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image.asset(
                                                        "assets/images/default_profile_pic.jpg",
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width / 24,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: width / 2.4,
                                                        child: Text(
                                                          user.userName,
                                                          style: RobotoFonts
                                                              .medium(
                                                                  color: Color(
                                                                      0xffDDDDDD),
                                                                  fontSize:
                                                                      width /
                                                                          26),
                                                        )),
                                                    SizedBox(
                                                      height: height / 90,
                                                    ),
                                                    Text(
                                                      user.fullName,
                                                      style:
                                                          RobotoFonts.regular(
                                                              color: Color(
                                                                  0xff919191),
                                                              fontSize:
                                                                  width / 30),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: width / 6,
                                                ),
                                                user.isFollowed
                                                    ? Icon(
                                                        Icons.check,
                                                        color: ColorPalette
                                                            .primaryColor,
                                                      )
                                                    : SizedBox.shrink(),
                                                Expanded(
                                                  child: SizedBox(
                                                    width: width / 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink();
                              },
                              separatorBuilder: (context, index) {
                                User user = prov.followedUsers[index];
                                return user.didQueryMatch
                                    ? Divider(
                                        thickness: 2,
                                        color: Colors.white10.withOpacity(0.03),
                                      )
                                    : SizedBox.shrink();
                              },
                              itemCount: prov.followedUsers.length)
                          : Center(
                              child: Text("No users"),
                            )))
            ],
          );
        });
      },
    );
  }


  //component to add caption to the post
  _buildCaptionField(CreatePostProvider prov, double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 20),
      child: Form(
        key: prov.captionFormKey,
        child: TextFormField(
          controller: prov.captionController,
          validator: (value) {
            return prov.validate(value!);
          },
          maxLines: 1,
          style: RobotoFonts.regular(
              color: ColorPalette.hintTestColor.withOpacity(0.8), fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffFFFFFF).withOpacity(0.03),
            hintText: "Caption",
            label: Text("Caption",
                style: RobotoFonts.medium(
                    fontSize: width / 20,
                    color: ColorPalette.hintTestColor.withOpacity(0.3))),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide:
                  BorderSide(width: 3, color: ColorPalette.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(width: 3, color: Colors.redAccent),
            ),
            contentPadding:
                const EdgeInsets.only(left: 20, top: 25, bottom: 15),
            border: InputBorder.none,
            hintStyle: RobotoFonts.regular(
                color: ColorPalette.hintTestColor.withOpacity(0.3),
                fontSize: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(
                  width: 3,
                  color: ColorPalette.hintTestColor.withOpacity(0.01)),
            ),
          ),
        ),
      ),
    );
  }


  //To create app bar
  _buildAppBar(CreatePostProvider prov, double height, double width) {
    return PreferredSize(
        preferredSize: Size.fromHeight(height / 14),
        child: Container(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: Colors.white10.withOpacity(0.03))),
            ),
            child: AppBar(
              leading: IconButton(
                  onPressed: () {
                    widget.bottomTabController.animateTo(0);

                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  )),
              backgroundColor: Color(0xff0C0C13),
              title: Text("New Post",
                  style: RobotoFonts.medium(
                      color: ColorPalette.hintTestColor, fontSize: width / 20)),
              toolbarHeight: height / 10,
              centerTitle: true,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: width / 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (prov.isImageSelected()) {
                        prov.captionFormKey.currentState!.validate()
                            ? await prov.addPost()
                            : print("Caption is not added");
                      }
                      if (prov.postCreated) {
                        widget.bottomTabController.animateTo(0);

                      }
                    },
                    child: prov.loading?CircularProgressIndicator(color: Colors.white,):Text("Post",
                        style: RobotoFonts.medium(
                            color: ColorPalette.primaryColor,
                            fontSize: width / 20)),
                  ),
                )
              ],
            )));
  }
}
