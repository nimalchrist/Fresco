import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../http_operations/http_services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class EditProfilePage extends StatefulWidget {
  final String profilePic;
  final String userName;
  final String? userAbout;
  final int userId;

  EditProfilePage({
    Key? key,
    required this.profilePic,
    required this.userName,
    required this.userAbout,
    required this.userId,
  });

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState(
        profilePic,
        userName,
        userAbout,
        userId,
      );
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String profilePic;
  final String userName;
  final String? userAbout;
  final int userId;
  File? profileImageFile;
  Httpservice httpService = Httpservice();

  _EditProfilePageState(
    this.profilePic,
    this.userName,
    this.userAbout,
    this.userId,
  );

  late TextEditingController nameController;
  late TextEditingController aboutController;
  GlobalKey _formKey = GlobalKey<FormState>();

  File? updatedProfile = null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: userName);
    if (userAbout == null) {
      aboutController = TextEditingController(text: "");
    } else {
      aboutController = TextEditingController(text: userAbout);
    }
  }

  void fetchProfilePic(ImageSource source) async {
    final pickedProfilePic = await ImagePicker().pickImage(source: source);
    File profileTempPath = File(pickedProfilePic!.path);
    setState(() {
      updatedProfile = profileTempPath;
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
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text(
                                                'Choose from gallery'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              fetchProfilePic(
                                                ImageSource.gallery,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text(
                                                'Choose from camera'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              fetchProfilePic(
                                                ImageSource.camera,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text(
                                                'Delete profile picture'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                            },
                                          ),
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
                //for username and password
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
                      controller: nameController,
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
                //for about
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
                      controller: aboutController,
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
                    onPressed: () async {
                      if (updatedProfile != null) {
                        profileImageFile = updatedProfile;
                      } else {
                        profileImageFile = null;
                      }

                      String? response = await httpService.editProfile(
                        userId,
                        profileImageFile,
                        nameController.text,
                        aboutController.text,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response!),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, true);
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
