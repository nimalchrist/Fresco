import 'dart:convert';
import 'package:http/http.dart' as http;
import './post_list_model.dart';
import './other_user_model.dart';

class Httpservice {
  Future<List<PostListModel>> getPosts() async {
    var url = Uri.parse('http://192.168.47.221:8000/posts');
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

  Future<OtherUserModel> getOtherUser(int user_id) async {
    var url = Uri.parse('http://192.168.47.221:8000/users/$user_id');
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
