import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:file_picker/file_picker.dart';
import '../http_operations/http_services.dart';

class CreatePost extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final authorisedUser;
  const CreatePost({super.key, required this.authorisedUser});
  @override
  State<CreatePost> createState() => _CreatePostState(this.authorisedUser);
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController? postTitle;
  TextEditingController? postDescription;
  bool isPostUploaded = false;
  final _formKey = GlobalKey<FormState>();
  File? postContent;
  Uint8List? videoPicture; // getting the video thumbnail
  FilePickerResult? audioPicker;
  late PlatformFile audioFile;
  bool isAudio = false;
  final authorisedUser;
  late Httpservice httpService;
  _CreatePostState(this.authorisedUser);

  Future<void> getPostContent(String type) async {
    if (type == "picture") {
      final post = await ImagePicker().pickImage(source: ImageSource.gallery);
      File postTemp = File(post!.path);
      setState(() {
        postContent = postTemp;
      });
    } else if (type == "video") {
      final post = await ImagePicker().pickVideo(source: ImageSource.gallery);
      File postTemp = File(post!.path);
      videoPicture = await VideoThumbnail.thumbnailData(
        video: postTemp.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 308,
        quality: 25,
      );
      setState(() {
        postContent = postTemp;
        videoPicture = videoPicture;
      });
    } else if (type == "audio") {
      audioPicker = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      audioFile = audioPicker!.files.first;
      setState(() {
        isAudio = true;
        postContent = File(audioFile.path.toString());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    postTitle = TextEditingController();
    postDescription = TextEditingController();
    httpService = Httpservice();
  }

  @override
  void dispose() {
    postDescription!.dispose();
    postTitle!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        backgroundColor: Colors.white,
        title: const Text(
          "Share Post",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              top: 3,
              // bottom: 10,
            ),
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && postContent != null) {
                  List<String> responses = await httpService.uploadPost(
                    authorisedUser,
                    postTitle!.text,
                    postDescription!.text,
                    postContent!,
                  );

                  if (responses.length == 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          responses[0],
                        ),
                      ),
                    );
                    setState(() {
                      postContent = null;
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          responses[0],
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 21, 87),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 35.0,
                    left: 10,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Create new post",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Create a post and share with your friends",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                height: 0.2,
                width: MediaQuery.of(context).size.width / 2,
                color: Colors.grey,
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                color: const Color.fromARGB(0, 255, 255, 255),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: postTitle,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Post title can't be empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "eg. This is my title",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      controller: postDescription,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "eg. This is my post description",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(164, 197, 196, 196),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          postContent != null
                              ? (videoPicture == null)
                                  ? (isAudio == false)
                                      ? Stack(
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Image.file(
                                                postContent!,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 280.0),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close_rounded,
                                                  size: 30,
                                                  color: Color.fromARGB(
                                                      255, 146, 145, 145),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    postContent = null;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Image.network(
                                                'https://img.freepik.com/premium-vector/sound-wave-with-imitation-sound-audio-identification-technology_106065-64.jpg?w=826',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 280.0),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.close_rounded,
                                                  size: 30,
                                                  color: Color.fromARGB(
                                                      255, 146, 145, 145),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    postContent = null;
                                                    isAudio = false;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                  : Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Image.memory(
                                            videoPicture!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 280.0),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 146, 145, 145),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                postContent = null;
                                                videoPicture = null;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    )
                              : const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Text(
                                      "Select the post content by clicking the button at the bottom of the screen",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        child: const Icon(Icons.edit),
        backgroundColor: const Color.fromARGB(255, 31, 21, 87),
        distance: 112.0,
        children: [
          FloatingActionButton(
            heroTag: 'button1',
            backgroundColor: const Color.fromARGB(255, 31, 21, 87),
            onPressed: () async => {
              isAudio = false,
              getPostContent("picture"),
            },
            child: const Icon(Icons.insert_photo),
          ),
          FloatingActionButton(
            heroTag: 'button2',
            backgroundColor: const Color.fromARGB(255, 31, 21, 87),
            onPressed: () async => {
              getPostContent("video"),
            },
            child: const Icon(Icons.videocam),
          ),
          FloatingActionButton(
            heroTag: 'button3',
            backgroundColor: const Color.fromARGB(255, 31, 21, 87),
            onPressed: () async => {
              debugPrint("Its working"),
              getPostContent("audio"),
            },
            child: const Icon(
              Icons.volume_up,
            ),
          ),
        ],
      ),
    );
  }
}
