import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fresco/app_pages/ImageViewer.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String profilePic;
  final String userName;
  final String userAbout;

  EditProfilePage({
    Key? key,
    required this.profilePic,
    required this.userName,
    required this.userAbout,
  });

  @override
  _EditProfilePageState createState() =>
      _EditProfilePageState(this.profilePic, this.userName, this.userAbout);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String profilePic;
  final String userName;
  final String userAbout;
  _EditProfilePageState(this.profilePic, this.userName, this.userAbout);

  late TextEditingController name_controller;
  late TextEditingController about_controller;
  GlobalKey _formKey = GlobalKey<FormState>();
  File? updatedProfile;

  @override
  void initState() {
    super.initState();
    name_controller = TextEditingController(text: userName);
    about_controller = TextEditingController(text: userAbout);
  }

  void getProfilePic(ImageSource source) async {
    final profile = await ImagePicker().pickImage(source: source);
    File profileTemp = File(profile!.path);
    setState(() {
      updatedProfile = profileTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                //code for profile with edit icon
                Center(
                  child: Stack(
                    children: [
                      updatedProfile == null
                          ? ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: Ink.image(
                                  image: NetworkImage(profilePic),
                                  fit: BoxFit.cover,
                                  width: 128,
                                  height: 128,
                                ),
                              ),
                            )
                          : ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: Image.file(
                                  updatedProfile!,
                                  fit: BoxFit.cover,
                                  width: 128,
                                  height: 128,
                                ),
                              ),
                            ),

                      // edit icon styling
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            color: Colors.white,
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color.fromARGB(230, 31, 21, 87),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                getProfilePic(
                                                    ImageSource.gallery);
                                              },
                                              child: const Text(
                                                "Select From Gallery",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      31, 21, 87, 1),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                getProfilePic(
                                                    ImageSource.camera);
                                              },
                                              child: const Text(
                                                "Select From Camera",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Color.fromRGBO(
                                                      31, 21, 87, 1),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "User Name can't be empty";
                        }
                        return null;
                      },
                      controller: name_controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(40, 141, 156, 204),
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: about_controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color.fromARGB(40, 141, 156, 204),
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: TextButton(
                    onPressed: () {
                      print(name_controller.text);
                      print(about_controller.text);
                      if (updatedProfile != null) {
                        //easy implementation
                      } else {
                        // convert the url to file then send the data
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
