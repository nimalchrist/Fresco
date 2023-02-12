import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './ImageViewer.dart';
import './VideoViewer.dart';
import './OurProfilePage.dart';
import 'OtherProfilePage.dart';
import '../http_operations/http_services.dart';
import '../http_operations/post_list_model.dart';
import './VideoPlayerWidget.dart';
import './AudioPlayerWidget.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';

class ListThePosts extends StatefulWidget {
  final int authorisedUser;
  const ListThePosts({super.key, required this.authorisedUser});

  @override
  State<ListThePosts> createState() => _ListThePostsState(this.authorisedUser);
}

class _ListThePostsState extends State<ListThePosts> {
  final int authorisedUser;
  _ListThePostsState(this.authorisedUser);

  String timeFormatter(DateTime dateTime) {
    return DateFormat('MMM d, y h:mm a')
        .format(dateTime.add(const Duration(hours: 5, minutes: 30)));
  }

  Httpservice httpService = Httpservice();

  Widget postListView(BuildContext context) {
    return FutureBuilder(
      future: httpService.getPosts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PostListModel>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onDoubleTap: () {
              print("Post tapped");
            },
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                return postContainer(context, snapshot.data![i]);
              },
            ),
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
          content.timePosted!,
        ),
        postContent(
          content.postTitle,
          content.postContent,
          content.profilePic,
          content.userName,
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
      String userName, DateTime timePosted) {
    String postedTime = timeFormatter(timePosted);
    const double avatarDiameter = 44;
    var userProfile = 'http://192.168.20.221:8000/profile_pics/$profilePic';
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              authorisedUser != userId
                  ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Other_profile_page(
                          user_id: userId,
                        ),
                      ),
                    )
                  : Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Our_profile_page(
                          authorisedUser: authorisedUser,
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
                  imageUrl: userProfile,
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
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              postedTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
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
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget postContent(String postTitle, String postContent, String profilePic,
      String userName) {
    String postURL = 'http://192.168.20.221:8000/post_contents/$postContent';

    String fileExtension = path.extension(postURL);
    if (fileExtension == '.jpg' ||
        fileExtension == '.jpeg' ||
        fileExtension == '.png') {
      // It's an image
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              postTitle,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 14.0,
              right: 14,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewer(
                      imageURL: postURL,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: postURL,
              ),
            ),
          ),
        ],
      );
    } else if (fileExtension == '.mp4') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              postTitle,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoViewer(
                    videoURL: postURL,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: PostVideoPlayer(videoURL: postURL),
            ),
          ),
        ],
      );
    } else if (fileExtension == '.mp3') {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              postTitle,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PostAudioPlayer(
            audioURL: postURL,
            profilePic: profilePic,
            userName: userName,
          ),
        ],
      );
    }
    return Container(
      width: double.infinity,
      height: 360,
      child: const Text("Under Maintanence..."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: postListView(context),
    );
  }
}
