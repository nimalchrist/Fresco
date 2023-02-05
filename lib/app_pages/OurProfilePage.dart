import 'package:flutter/material.dart';
import 'package:fresco/app_pages/EditProfilePage.dart';
import 'package:fresco/app_pages/ImageViewer.dart';
import 'package:fresco/http_operations/authorised_user_model.dart';
import 'package:fresco/http_operations/http_services.dart';

class Our_profile_page extends StatefulWidget {
  final int authorisedUser;
  Our_profile_page({Key? key, required this.authorisedUser}) : super(key: key);

  @override
  _Our_profile_pageState createState() =>
      _Our_profile_pageState(authorisedUser);
}

class _Our_profile_pageState extends State<Our_profile_page> {
  final int authorisedUser;
  _Our_profile_pageState(this.authorisedUser);
  Httpservice httpService = Httpservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: httpService.getAuthorisedUser(authorisedUser),
          builder: ((BuildContext context,
              AsyncSnapshot<AuthorisedUserModel> snapshot) {
            if (snapshot.hasData) {
              String _imagePath =
                  'http://192.168.164.221:8000/profile_pics/${snapshot.data!.profilePic}';
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Color.fromARGB(255, 31, 21, 87),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return buildBottomSheet(
                                    context, snapshot.data!);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  ProfileWidget(
                    imagePath: _imagePath,
                    onClicked: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageViewer(imageURL: _imagePath),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  buildName(snapshot.data!),
                  const SizedBox(height: 48),
                  buildAbout(snapshot.data!),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Can't connect to the server\n right now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 31, 21, 87),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildName(AuthorisedUserModel user) {
    return Column(
      children: [
        Text(
          '@${user.userName}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget buildAbout(AuthorisedUserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.profileText != null ? user.profileText! : "No about",
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomSheet(BuildContext context, AuthorisedUserModel userModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit account'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Edit profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(
                  profilePic:
                      'http://192.168.164.221:8000/profile_pics/${userModel.profilePic}',
                  userName: userModel.userName,
                  userAbout: userModel.profileText!,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notification settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {},
        ),
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: buildImage(),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);
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
