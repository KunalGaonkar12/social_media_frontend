import 'package:flutter/cupertino.dart';
import 'package:models/user/user_model.dart';
import 'package:services/services/graphql_services.dart';

class FollowUnFollowProvider with ChangeNotifier {
  GraphQLService _graphQlService = GraphQLService();
  bool isAllUsers = true;
  int allUserCount = 100;
  int followingCount = 90;
  List<User> filteredAllUsers = [];
  List<User> filteredFollowedUsers = [];
  bool isUserFollowing = false;
  TextEditingController searchController = TextEditingController();
  List<User> allUsers = [];
  List<User> followedUsers = [];
  bool isLoading = true;
  User? user;

  //to initialize values
  init(String id) async {
    allUsers = [];
    followedUsers = [];
    filteredAllUsers = [];
    filteredFollowedUsers = [];
    isLoading = true;
    searchController.clear();

    await getUser(id);
  }

  //To get the current logged in user info and split all users in two list all users and followed users
  Future<void> getUser(String id) async {
    user = await _graphQlService.getUser(id: id);
    allUsers = await _graphQlService.getUsers();
    allUsers.removeWhere((element) => element.id == user!.id);
    filteredAllUsers = [...allUsers];

    if (filteredAllUsers.isNotEmpty && user != null) {
      if (user!.followers!.isNotEmpty) {
        followedUsers = allUsers
            .where((element) => user!.followers!.contains(element.id)
                ? element.isFollowed = true
                : element.isFollowed = false)
            .toList();
        filteredFollowedUsers=[...followedUsers];
      }
    }
    isLoading = false;
    notifyListeners();
  }

  //To provide search functionality
  Future<void> onChangedSearch(String value, List<User> users) async {
    filteredAllUsers.clear();
   filteredFollowedUsers.clear();
    notifyListeners();

    if (value.isEmpty) {
      filteredAllUsers = List.from(allUsers);
      filteredFollowedUsers=List.from(followedUsers);
    } else {
        for (User user in allUsers) {
          if (user.userName
              .replaceAll(" ", "")
              .toLowerCase()
              .contains(value.replaceAll(" ", "").toLowerCase())) {
            filteredAllUsers.add(user);
          }
        }
        for (User user in followedUsers) {
          if (user.userName
              .replaceAll(" ", "")
              .toLowerCase()
              .contains(value.replaceAll(" ", "").toLowerCase())) {
            filteredFollowedUsers.add(user);
          }
        }

    }
    notifyListeners();
  }

  // function to update the follow and unfollow
  Future<void> updateFollowUnFollow(String id, String loggedInUserId) async {
    int index = allUsers.indexWhere((element) => element.id == id);

    //if the user is followed than unfollow him and call graphql api to update the unfollowed user
    if (allUsers[index].isFollowed) {
      print("unfollow");
      allUsers[index].isFollowed = !allUsers[index].isFollowed;
      followedUsers.removeWhere((element) => element.id == id);
      int filteredIndex = filteredFollowedUsers.indexWhere((element) => element.id == id);
      if(filteredIndex>=0){
        filteredFollowedUsers.removeWhere((element) => element.id == id);
      }
      await _graphQlService.followUnFollowUser(
          userId: loggedInUserId, followId: id);
      //if the user is not  followed than follow him and add to the in app follow list and call graphql api to update the followed user in db
    } else {
      allUsers[index].isFollowed = !allUsers[index].isFollowed;
      followedUsers..add(allUsers[index]);
      int filteredIndex = filteredFollowedUsers.indexWhere((element) => element.id == id);
      if(filteredIndex<0){
        filteredFollowedUsers..add(allUsers[index]);
      }
      await _graphQlService.followUnFollowUser(
          userId: loggedInUserId, followId: id);
      print("follow");
    }
    notifyListeners();
  }

}
