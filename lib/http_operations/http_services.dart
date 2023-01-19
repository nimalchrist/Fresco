import 'dart:convert';
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

    var url = Uri.parse('http://192.168.3.221:8000/register');
    http.Response res = await http.post(url, body: map);
    var data = jsonDecode(res.body);
    String message = data["message"];
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const AppLayout(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Authentication Failed"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: const Color.fromARGB(226, 32, 32, 99),
                padding: const EdgeInsets.all(14),
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
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
  Future loginUser(String email, String password, BuildContext context) async {
    var map = Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;

    var url = Uri.parse('http://192.168.3.221:8000/login');
    http.Response res = await http.post(url, body: map);
    var data = jsonDecode(res.body);
    String message = data["message"];
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const AppLayout(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Authentication Failed"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: const Color.fromARGB(226, 32, 32, 99),
                padding: const EdgeInsets.all(14),
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

// get all the posts
  Future<List<PostListModel>> getPosts() async {
    var url = Uri.parse('http://192.168.3.221:8000/posts');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<PostListModel> posts = body
          .map(
            (dynamic item) => PostListModel.fromJson(item),
          )
          .toList();
      print(posts);
      return posts;
    } else {
      return [];
    }
  }

// get the other user
  Future<OtherUserModel> getOtherUser(int user_id) async {
    var url = Uri.parse('http://192.168.3.221:8000/users/$user_id');
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);
      OtherUserModel OtherUser = OtherUserModel.fromJson(body[0]);

      print(OtherUser);
      return OtherUser;
    }
    throw "Error while calling";
  }
}
