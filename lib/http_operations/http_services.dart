import 'dart:convert';
import 'package:fresco/app_pages/Otp_page.dart';
import 'package:http/http.dart' as http;
import './post_list_model.dart';
import './other_user_model.dart';
import 'package:flutter/material.dart';
import '../app_pages/App_layout_controller.dart';

class Httpservice {
  // register user
  Future registerUser(String username, String email, String password,
      BuildContext context) async {
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://192.168.112.221:8000/register');
    http.Response res = await http.post(url, body: map);
    var loginResponseData = jsonDecode(res.body);

    String registerMessage = loginResponseData["message"];
    if (res.statusCode == 200) {
      int? authorisedUser = loginResponseData["user_id"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(registerMessage),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => AppLayout(
            authorisedUser: authorisedUser!,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Registration Failed"),
          content: Text(registerMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: const Color.fromARGB(202, 32, 32, 99),
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 5,
                  bottom: 5,
                ),
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // login user
  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    var map = Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://192.168.112.221:8000/login');
    http.Response res = await http.post(url, body: map);
    var loginResponseData = jsonDecode(res.body);

    String loginMessage = loginResponseData["message"];

    if (res.statusCode == 200) {
      int authorisedUser = loginResponseData["user_id"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loginMessage),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              OtpScreen(authorisedUser: authorisedUser),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(loginMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: const Color.fromARGB(226, 32, 32, 99),
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 5,
                  bottom: 5,
                ),
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

// otp verification of register
  Future otpLoginVerification(
      int otp, int? userId, BuildContext context) async {
    var url = Uri.parse('http://192.168.112.221:8000/otp');

    var map = Map<String, dynamic>();
    map["otp"] = otp;
    map["id"] = int.parse("userId");
    http.Response res = await http.post(url, body: map);
    var otpResponseData = jsonDecode(res.body);
    int authorisedUser = otpResponseData['user_id'];
    String otpMessage = otpResponseData['message'];
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(otpMessage),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => AppLayout(
            authorisedUser: authorisedUser,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(otpMessage),
        ),
      );
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
  Future<OtherUserModel> getOtherUser(int user_id) async {
    var url = Uri.parse('http://192.168.112.221:8000/users/$user_id');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      OtherUserModel OtherUser = OtherUserModel.fromJson(body[0]);

      return OtherUser;
    }
    throw "Error while calling";
  }
}
