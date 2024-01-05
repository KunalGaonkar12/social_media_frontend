import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/post/post_model.dart';
import 'package:models/user/user_model.dart' as user;

import 'package:services/services/graphql_services.dart';

class ProfileProvider with ChangeNotifier {
  List<Post> myPosts = [];
  GraphQLService _graphQlService = GraphQLService();
  bool isLoading = true;
  user.User? loggedInUser;


  init(String id) async {
    myPosts = [];
    isLoading = true;
    await getPost(id);
  }

  //To get all posts using graphql api
  Future<void> getPost(String id) async {
    loggedInUser =  await _graphQlService.getUser(id:id);
    List<Post> posts=[];
    posts = await _graphQlService.getPosts(id: id);
    myPosts=posts.where((element) => element.userId==id).toList();
    if (posts.isNotEmpty) {
      isLoading = false;
      notifyListeners();
    }
  }
}
