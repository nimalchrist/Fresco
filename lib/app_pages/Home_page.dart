import 'package:flutter/material.dart';
import './List_the_posts.dart';
import './Search_button.dart';

class Home_page extends StatefulWidget {
  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBar: AppBar(
              title: const Text(
                "Fresco",
                style: TextStyle(
                  color: Color.fromARGB(255, 49, 35, 131),
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: const [
                Search_here(),
              ],
            ),
            body: const List_the_posts(),
          ),
        ],
      ),
    );
  }
}
