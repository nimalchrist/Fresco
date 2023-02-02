import 'package:flutter/material.dart';
import 'ListThePostsPage.dart';
import './Search_button.dart';

class Home_page extends StatefulWidget {
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
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
              body: const ListThePosts(),
            ),
          ],
        ),
      ),
    );
  }
}
