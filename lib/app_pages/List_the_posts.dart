import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './Other_profile_page.dart';
import '../http_operations/http_services.dart';
import '../http_operations/post_list_model.dart';

class List_the_posts extends StatefulWidget {
  const List_the_posts({super.key});

  @override
  State<List_the_posts> createState() => _List_the_postsState();
}

class _List_the_postsState extends State<List_the_posts> {
  Httpservice http_service = Httpservice();

  Widget Post_list_view(BuildContext context) {
    return FutureBuilder(
      future: http_service.getPosts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PostListModel>> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.length != null
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    return Post_container(context, snapshot.data![i]);
                  },
                )
              : const Text(
                  "Yarume post upload panala na ena pana",
                );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Ipothaiku error irukuthu pola ",
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 31, 21, 87),
          ),
        );
      },
    );
  }

  Widget Post_container(BuildContext context, PostListModel content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Author_info(context, content.userId, content.profilePic,
            content.userName, content.postTitle),
        Post_content(content.postContent),
        Post_summary(content.postSummary),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }

  Widget Author_info(BuildContext context, int user_id, String profile_pic,
      String user_name, String post_title) {
    const double avatarDiameter = 44;
    var _Avatar = 'http://192.168.47.221:8000/profile_pics/$profile_pic';
    var dummyAvatar =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973461_960_720.png';
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Other_profile_page(
                    user_id: user_id,
                  ),
                ),
              );
            },
            child: Container(
              width: avatarDiameter,
              height: avatarDiameter,
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(avatarDiameter / 2),
                child: CachedNetworkImage(
                  imageUrl: _Avatar != null ? _Avatar : dummyAvatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post_title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              user_name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black38,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget Post_summary(String post_summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Text(
        post_summary,
      ),
    );
  }

  Widget Post_content(String post_content) {
    String _post_content =
        'http://192.168.47.221:8000/post_contents/$post_content';
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: _post_content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post_list_view(context),
    );
  }
}
