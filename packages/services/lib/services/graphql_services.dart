import 'dart:convert';
import 'dart:io';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:models/post/post_model.dart';
import 'package:models/user/user_model.dart';

import '../graphql_config.dart';

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();



  //To get all the posts of the users that the current logged in user is following
  Future<List<Post>> getPosts({
    int? limit,
    String? id
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
        query GetPosts(\$limit: Int, \$getPostsId: String) {
           getPosts(limit: \$limit, id: \$getPostsId) {
            _id
            caption
            date
            image
            userId
            userName
          }
        }
            """),
          variables: {
            "limit": limit,
            "getPostsId": id
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['getPosts'];
        if (res == null || res.isEmpty) {
          return [];
        }
        List<Post> posts = [];
        posts = res.map((post) => Post.fromJson(post)).toList();
        return posts;
      }
    } catch (error) {
      return [];
    }
  }

//To get the user base on id
  Future<User?> getUser({
    String? id
  }) async {
    User? user;

    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
           query Query(\$id: ID!) {
             getUser(ID: \$id) {
                email
                followers
                fullName
                id
                userName
              }
            }
            """),
          variables: {
            "id": id
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        var res = result.data?['getUser'];
        if (res == null) {
          return user;
        }

        user = User.fromJson(res);
        return user;
      }
    } catch (error) {
      return user;
    }
  }



//To get all users on this platform
  Future<List<User>> getUsers({
    int? limit,
  }) async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              query Query(\$limit: Int) {
                getUsers(limit: \$limit) {
                  email
                  followers
                  fullName
                  id
                  userName
                }
              }
            """),
          variables: {
            'limit': limit,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        List? res = result.data?['getUsers'];
        if (res == null || res.isEmpty) {
          return [];
        }
        List<User> users = [];
        users = res.map((user) => User.fromJson(user)).toList();
        return users;
      }
    } catch (error) {
      return [];
    }
  }





//To create user using graphql
  Future<String> createUser({
    required String email,
    required String fullName,
    required String id,
    required List<String> followers,
    required String userName,

  }) async {
    try {


      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
                       mutation Mutation(\$userInput: UserInput) {
              createUser(userInput: \$userInput)
            }
            """),
          variables:{
            "userInput": {
              "email": email,
              "fullName": fullName,
              "followers": followers,
              "id": id,
              "userName": userName
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return result.data!["createUser"];
      }
    } catch (error) {
      return error.toString();
    }
  }


  //to create post
  Future<bool> createPost({
    required String caption,
    required File imageFile,
    required String userId,
    required List<String> tags,
    required String userName,
  }) async {
    try {

      // Convert the image file to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);


      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            mutation Mutation(\$postInput: PostInput) {
              createPost(postInput: \$postInput)
            }
            """),
          variables: {
            "postInput": {
              "image": base64Image,
              "userId": userId,
              "caption": caption,
              "userName":userName,
              "tags": tags,
            }
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }


  //to follow and unfollow user
  Future<String> followUnFollowUser({
    required String userId,
    required String followId,
  }) async {
    try {

      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
          mutation Mutation(\$followUnFollowInput: FollowUnFollowInput) {
                  followUnFollowUser(followUnFollowInput: \$followUnFollowInput)
                }
            """),
          variables:{
            "followUnFollowInput": {
              "id": userId,
              "followId": followId
            }
          }
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return result.data!["followUnFollowUser"];
      }
    } catch (error) {
      return error.toString();
    }
  }

}
