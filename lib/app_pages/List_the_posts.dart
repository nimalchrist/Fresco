import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './Other_profile_page.dart';

class List_the_posts extends StatelessWidget {
  final dummyAvatar =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.scoutandhire.io%2Fcollections%2Fqa-test-engineer&psig=AOvVaw3h4MPJTmZeYID38t1NnJ_x&ust=1673424753948000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCMCPhpLHvPwCFQAAAAAdAAAAABAJ';
  final dummyImage =
      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.scoutandhire.io%2Fcollections%2Fqa-test-engineer&psig=AOvVaw3h4MPJTmZeYID38t1NnJ_x&ust=1673424753948000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCMCPhpLHvPwCFQAAAAAdAAAAABAJ';
  const List_the_posts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post_list_view(context),
    );
  }
}

Widget Author_info(BuildContext context) {
  const double avatarDiameter = 44;
  const dummyAvatar =
      'https://static.wikia.nocookie.net/inuyasha/images/b/b5/Inuyasha.png/revision/latest?cb=20151128185518';
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Other_profile_page(),
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
                imageUrl: dummyAvatar,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      const Text(
        'Username',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      )
    ],
  );
}

Widget Post_content() {
  const dummyImage =
      'https://i1.wp.com/butwhythopodcast.com/wp-content/uploads/2020/09/maxresdefault-28.jpg?fit=1280%2C720&ssl=1';
  return AspectRatio(
    aspectRatio: 1,
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: dummyImage,
    ),
  );
}

Widget Post_summary() {
  return const Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    child: Text(
        'Welcome to the Kilo Loco YouTube channel, where we cover iOS, Flutter, and Android development. The perfect place for explarative mobile devlopers.'),
  );
}

Widget Post_container(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Author_info(context),
      Post_content(),
      Post_summary(),
    ],
  );
}

Widget Post_list_view(BuildContext context) {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: ((context, index) {
      return Post_container(context);
    }),
  );
}
