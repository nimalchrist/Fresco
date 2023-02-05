import 'package:flutter/material.dart';
import 'package:fresco/app_pages/ImageViewer.dart';

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

  @override
  void initState() {
    super.initState();
    name_controller = TextEditingController(text: userName);
    about_controller = TextEditingController(text: userAbout);
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
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: NetworkImage(profilePic),
                            fit: BoxFit.cover,
                            width: 128,
                            height: 128,
                            child: InkWell(
                              onTap: () {},
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(3),
                            color: Colors.white,
                            child: ClipOval(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: Color.fromARGB(230, 31, 21, 87),
                                child: GestureDetector(
                                  onTap: () {},
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
                        // child: buildEditIcon(
                        //   Theme.of(context).colorScheme.primary,
                        // ),
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
