import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './App_layout_controller.dart';
import '../http_operations/http_services.dart';
import '../http_operations/other_user_model.dart';

class Other_profile_page extends StatefulWidget {
  final int user_id;
  const Other_profile_page({Key? key, required this.user_id}) : super(key: key);

  @override
  _Other_profile_pageState createState() =>
      _Other_profile_pageState(user_id: user_id);
}

class _Other_profile_pageState extends State<Other_profile_page> {
  final int user_id;
  Httpservice httpservice = Httpservice();
  _Other_profile_pageState({required this.user_id});

  String TimeFormatter(DateTime data) {
    return "${data.day} - ${data.month} - ${data.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: FutureBuilder(
        future: httpservice.getOtherUser(user_id),
        builder:
            ((BuildContext context, AsyncSnapshot<OtherUserModel> snapshot) {
          if (snapshot.hasData) {
            String imagePath =
                'http://192.168.47.221:8000/profile_pics/${snapshot.data!.profilePic}';
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(imagePath: imagePath),
                const SizedBox(height: 24),
                buildName(snapshot.data!),
                const SizedBox(height: 48),
                buildAbout(snapshot.data!),
              ],
            );
          } else if (snapshot.hasError) {
            throw "Error with snapshot";
          }

          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 31, 21, 87),
            ),
          );
        }),
      ),
    );
  }

  Widget buildName(
    OtherUserModel user,
  ) =>
      Column(
        children: [
          Text(
            user.userName!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email!,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(OtherUserModel user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.profileText != null
                  ? user.profileText.toString()
                  : "The user don't have an about",
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Member Since",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '${TimeFormatter(user.registeredAt!)}',
              style: const TextStyle(fontSize: 16, height: 3.4),
            )
          ],
        ),
      );
}

AppBar buildAppBar(BuildContext context) {
  // const icon = CupertinoIcons.moon_stars;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      // IconButton(
      //   icon: const Icon(
      //     icon,
      //     color: Color.fromARGB(255, 31, 21, 87),
      //   ),
      //   onPressed: () {},
      // ),
    ],
  );
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  onClicked() {
    print("Image tapped");
  }

  const ProfileWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
        ],
      ),
    );
  }

  Widget buildImage() {
    var dummyAvatar =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973461_960_720.png';
    var image = NetworkImage(imagePath != null ? imagePath : dummyAvatar);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }
}
