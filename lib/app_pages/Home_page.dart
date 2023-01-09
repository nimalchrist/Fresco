// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../http_operations/http_services.dart';
import '../http_operations/post_list_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Httpservice httpService = Httpservice();

  @override
  Widget build(BuildContext context) {
    Uint8List _bytesImage;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.black26,
      ),
      body: FutureBuilder(
        future: httpService.getPosts(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PostListModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, i) {
                String? rawString = snapshot.data![i].postContent;
                if (rawString!.length % 4 > 0) {
                  rawString += '_' * (4 - rawString.length % 4);
                }
                _bytesImage = Base64Decoder().convert(rawString);
                return Container(
                  width: double.infinity,
                  color: Color.fromARGB(255, 185, 184, 185),
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("${snapshot.data![i].postTittle}"),
                      Image.memory(_bytesImage),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
