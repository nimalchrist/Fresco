import 'dart:convert';
import 'package:http/http.dart' as http;
import './post_list_model.dart';

class Httpservice {
  Future<List<PostListModel>> getPosts() async {
    var url = Uri.parse('http://192.168.223.221:8000/posts');
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
      throw "Unable to retrieve posts.";
    }
  }

  //other http funcitons
}
