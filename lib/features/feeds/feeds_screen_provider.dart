

import 'package:flutter/cupertino.dart';
import 'package:models/post/post_model.dart';
import 'package:services/services/graphql_services.dart';

class FeedsScreenProvider with ChangeNotifier{


  List<Post> posts=[];
  GraphQLService _graphQlService=GraphQLService();
  bool isLoading=true;
  int maxTextLines=2;


//To set initial values
  init(String id) async{
    posts=[];
    isLoading=true;
    maxTextLines=2;
    await getPost(id);
  }


  //To get all posts using graphql api
  Future<void> getPost(String id) async{
      posts=await _graphQlService.getPosts(id: id);
      if(posts.isNotEmpty){
        isLoading=false;
        notifyListeners();
      }

  }

//To enable disable visible of more caption
  enableDisableMore(String id){
int index=posts.indexWhere((element) => element.userId==id);
posts[index].enableMore=!posts[index].enableMore;

notifyListeners();
  }

}