import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'OtherProfilePage.dart';
import '../http_operations/http_services.dart';
import '../http_operations/post_list_model.dart';
import 'package:path/path.dart' as path;
import './VideoPlayerWidget.dart';

class ListThePosts extends StatefulWidget {
  const ListThePosts({super.key});

  @override
  State<ListThePosts> createState() => _ListThePostsState();
}

class _ListThePostsState extends State<ListThePosts> {
  Httpservice httpService = Httpservice();

  Widget postListView(BuildContext context) {
    return FutureBuilder(
      future: httpService.getPosts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PostListModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) {
              return postContainer(context, snapshot.data![i]);
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "404 Error...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
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

  Widget postContainer(BuildContext context, PostListModel content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authorInfo(
          context,
          content.userId,
          content.profilePic,
          content.userName,
          content.postTitle,
        ),
        postContent(
          content.postContent,
        ),
        postSummary(
          content.postSummary,
        ),
        Container(
          height: 8,
          width: double.infinity,
          color: const Color.fromARGB(255, 228, 228, 228),
        )
      ],
    );
  }

  Widget authorInfo(BuildContext context, int userId, String profilePic,
      String userName, String postTitle) {
    const double avatarDiameter = 44;
    var Avatar = 'http://192.168.112.221:8000/profile_pics/$profilePic';
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Other_profile_page(
                    user_id: userId,
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
                  imageUrl: Avatar,
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
              '@$userName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black38,
              ),
            ),
            Text(
              postTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget postSummary(String postSummary) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 14,
        ),
        child: Text(
          postSummary,
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget postContent(String postContent) {
    String postURL = 'http://192.168.112.221:8000/post_contents/$postContent';

    String fileExtension = path.extension(postURL);
    if (fileExtension == '.jpg' ||
        fileExtension == '.jpeg' ||
        fileExtension == '.png') {
      // It's an image
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: postURL,
        ),
      );
    } else if (fileExtension == '.mp4') {
      return Padding(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: PostVideoPlayer(videoURL: postURL),
      );
    }
    return const Text("Wait panra ngotha nerla varenda");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: postListView(context),
    );
  }
}
