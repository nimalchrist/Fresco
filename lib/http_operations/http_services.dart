import 'dart:convert';
import 'dart:io';
import 'package:fresco/http_operations/authorised_user_model.dart';
import 'package:http/http.dart' as http;
import './post_list_model.dart';
import './other_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Httpservice {
  // register user
  Future<List<dynamic>> registerUser(
      String username, String email, String password) async {
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://192.168.112.221:8000/register');
    http.Response res = await http.post(url, body: map);
    var loginResponseData = jsonDecode(res.body);

    String registerMessage = loginResponseData["message"];
    try {
      if (res.statusCode == 200) {
        int authorisedUser = loginResponseData["user_id"];

        return [registerMessage, authorisedUser];
      } else {
        return [registerMessage];
      }
    } catch (e) {
      return [e];
    }
  }

  // login user
  Future<List<dynamic>> loginUser(String email, String password) async {
    var map = Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://192.168.112.221:8000/login');
    http.Response res = await http.post(url, body: map);
    var loginResponseData = jsonDecode(res.body);

    String loginMessage = loginResponseData["message"];
    try {
      if (res.statusCode == 200) {
        int authorisedUser = loginResponseData["user_id"];
        return [loginMessage, authorisedUser];
      } else {
        return [loginMessage];
      }
    } catch (e) {
      return [e];
    }
  }

// otp verification
  Future<List<dynamic>> otpVerification(String otp, int userId) async {
    try {
      // Make the HTTP request to the server
      var url = Uri.parse('http://192.168.112.221:8000/otp');
      var map = Map<String, dynamic>();
      map["otp"] = otp;
      map["id"] = userId.toString();
      var response = await http.post(url, body: map);

      // Handle the response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var authorisedUser = responseData['user_id'];
        var message = responseData['message'];

        // local storage of the user.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('user_id', authorisedUser);

        return [message, authorisedUser];
      } else {
        // Handle the error response
        var responseData = jsonDecode(response.body);
        var message = responseData['message'];

        return [message];
      }
    } catch (e) {
      // Handle any exceptions that may occur
      return [e];
    }
  }

// get all the posts
  Future<List<PostListModel>> getPosts() async {
    var url = Uri.parse('http://192.168.112.221:8000/posts');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<PostListModel> posts = body
          .map(
            (dynamic item) => PostListModel.fromJson(item),
          )
          .toList();

      return posts;
    } else {
      return [];
    }
  }

// get the other user
  Future<OtherUserModel> getOtherUser(int userId) async {
    var url = Uri.parse('http://192.168.112.221:8000/users/$userId');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      OtherUserModel OtherUser = OtherUserModel.fromJson(body[0]);

      return OtherUser;
    }
    throw "Error while calling";
  }

  //get the authorised user
  Future<AuthorisedUserModel> getAuthorisedUser(int userId) async {
    var url = Uri.parse('http://192.168.112.221:8000/auth_user/$userId');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      AuthorisedUserModel AuthUser = AuthorisedUserModel.fromJson(body[0]);

      return AuthUser;
    }
    throw "Error while calling";
  }

  //upload post to the server
  Future<List<String>> uploadPost(int userId, String postTitle,
      String postSummary, File postContent) async {
    Uri url = Uri.parse('http://192.168.112.221:8000/$userId/upload_post');
    print(url);
    var request = http.MultipartRequest('POST', url);

    request.fields['post_title'] = postTitle;
    request.fields['author_id'] = userId.toString();
    request.fields['post_summary'] = postSummary;
    request.files.add(
      await http.MultipartFile.fromPath('uploadedFile', postContent.path),
    );
    print(request);

    var getResponse = await request.send();
    var response = await http.Response.fromStream(getResponse);
    print(response);
    dynamic rawMessage = jsonDecode(response.body);
    String message = rawMessage['message'];
    if (response.statusCode == 200) {
      return [message, "success"];
    }
    return [message];
  }
}
