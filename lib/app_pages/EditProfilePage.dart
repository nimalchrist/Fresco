import 'package:flutter/material.dart';
import '../app_pages/OurProfilePage.dart';

class EditProfilePage extends StatefulWidget {
  final String profilePic;
  final String userName;
  final String userAbout;

  EditProfilePage(
      {Key? key,
      required this.profilePic,
      required this.userName,
      required this.userAbout});

  @override
  _EditProfilePageState createState() =>
      _EditProfilePageState(this.profilePic, this.userName, this.userAbout);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String profilePic;
  final String userName;
  final String userAbout;
  _EditProfilePageState(this.profilePic, this.userName, this.userAbout);

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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: profilePic,
                onClicked: () {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'User Name',
                text: userName,
                onChanged: (name) {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'About',
                text: userAbout,
                maxLines: 5,
                onChanged: (about) {},
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Color.fromARGB(40, 141, 156, 204),
          ),
          maxLines: widget.maxLines,
        ),
      ],
    );
  }
}
