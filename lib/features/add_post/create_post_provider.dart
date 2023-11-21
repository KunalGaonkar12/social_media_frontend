import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/user/user_model.dart';
import 'package:services/services/graphql_services.dart';
import 'package:social_media/config/colorpalette.dart';

import '../../config/font/font.dart';
import '../../config/keys.dart';

class CreatePostProvider with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> captionFormKey = GlobalKey<FormState>();
  File? selectedFile;
  List<User> followedUsers = [];
  User? user;
  bool loading = false;
  bool postCreated = false;

  GraphQLService _graphQLService = GraphQLService();


  //To set initial values
  init(String id) async {
    captionController.clear();
    searchController.clear();
    followedUsers = [];
    selectedFile = null;
    postCreated = false;
    loading = false;
    await getUser(id);
  }


  //graphql api to get all users
  Future<void> getUser(String id) async {
    user = await _graphQLService.getUser(id: id);
    List<User> users = await _graphQLService.getUsers();
    if (users.isNotEmpty && user != null) {
      if (user!.followers!.isNotEmpty) {
        followedUsers = users
            .where((element) => user!.followers!.contains(element.id))
            .toList();
      }
    }
  }

  //To select and unselect tagged person
  setSelected(String id) {
    int index = followedUsers.indexWhere((element) => element.id == id);
    followedUsers[index].isFollowed = !followedUsers[index].isFollowed;
    notifyListeners();
  }


  //To provide search functionality
  Future<void> onChangedSearch(String value) async {
    if (value.isEmpty) {
      for (User user in followedUsers) {
        user.didQueryMatch = true;
      }
    } else {
      for (User user in followedUsers) {
        if (user.userName
            .replaceAll(" ", "")
            .toLowerCase()
            .contains(value.replaceAll(" ", "").toLowerCase())) {
          user.didQueryMatch = true;
        } else {
          user.didQueryMatch = false;
        }
      }
    }
    notifyListeners();
  }


  //To add image and crop image from gallery or camera
  Future<void> pickAndCropImage({required bool fromGallery}) async {
    XFile? pickedFile;
    CroppedFile? croppedFile;

    if (fromGallery) {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    }

    if (pickedFile != null) {
      ImageCropper imageCropper = ImageCropper();
      croppedFile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 400,
        maxHeight: 350,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color(0xff0C0C13),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              activeControlsWidgetColor: ColorPalette.primaryColor,
              lockAspectRatio: false),
        ],
      );
    }
    if (croppedFile != null) {
      selectedFile = File(croppedFile.path);
    }
    notifyListeners();
  }

  //To add post and add tags using graphql api
  Future<void> addPost() async {
    loading = true;
    postCreated = false;
    notifyListeners();
    List<String> tags = [];
    followedUsers.forEach((element) {
      if (element.isFollowed) {
        tags.add(element.id);
      }
    });

    try {
      postCreated = await _graphQLService.createPost(
          caption: captionController.text,
          imageFile: selectedFile!,
          userId: user!.id,
          tags: tags,
          userName: user!.userName);
      if (postCreated) {
        _showSnackBar(
          "Post uploaded successfully",
          Colors.green,
        );
        loading=false;
        notifyListeners();
      }
    } catch (error) {
      loading=false;
      notifyListeners();
      throw  Exception(error);
    }
  }

  _showSnackBar(String value, Color color) {
    return Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      elevation: 3,
      content: Center(
          child: Text(
        value,
        style: RobotoFonts.regular(color: color, fontSize: 15),
      )),
      backgroundColor: Color(0xff0C0C14),
    ));
  }


  //To validate if image is selected before posting
  bool isImageSelected() {
    if (selectedFile != null) {
      return true;
    } else {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        elevation: 3,
        content: Center(
            child: Text(
          "Please select a picture",
          style: RobotoFonts.regular(color: Colors.redAccent, fontSize: 15),
        )),
        backgroundColor: Color(0xff0C0C14),
      ));
      return false;
    }
  }

  //To validate caption before posting
  String? validate(String value) {
    if (value.isEmpty) {
      return "Please enter caption";
    }
  }
}
