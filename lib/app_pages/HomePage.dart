import 'package:flutter/material.dart';
import 'ListThePostsPage.dart';
import './Search_button.dart';

class Home_page extends StatefulWidget {
  final int authorisedUser;
  Home_page({super.key, required this.authorisedUser});
  @override
  State<Home_page> createState() => _Home_pageState(this.authorisedUser);
}

class _Home_pageState extends State<Home_page> {
  final int authorisedUser;
  _Home_pageState(this.authorisedUser);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Fresco",
                  style: TextStyle(
                    color: Color.fromARGB(255, 49, 35, 131),
                  ),
                ),
                elevation: 1.5,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                actions: const [
                  Search_here(),
                ],
              ),
              body: ListThePosts(
                authorisedUser: authorisedUser,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
