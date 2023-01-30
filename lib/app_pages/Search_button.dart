import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Search_here extends StatefulWidget {
  const Search_here({super.key});

  @override
  State<Search_here> createState() => _Search_hereState();
}

class _Search_hereState extends State<Search_here> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, top: 4, left: 10),
      child: AnimSearchBar(
        prefixIcon: const Icon(
          Icons.search,
          color: Color.fromARGB(255, 49, 35, 131),
          size: 32,
        ),
        textFieldIconColor: const Color.fromARGB(255, 49, 35, 131),
        autoFocus: true,
        width: 340,
        textController: textController,
        closeSearchOnSuffixTap: true,
        style: const TextStyle(
          color: Color.fromARGB(255, 31, 21, 87),
          fontFamily: 'inter',
        ),
        rtl: true,
        onSuffixTap: () {
          setState(() {
            textController.clear();
          });
        },
        onSubmitted: (String) {},
      ),
    );
  }
}
