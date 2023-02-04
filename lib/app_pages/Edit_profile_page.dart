import 'package:flutter/material.dart';
import '../http_operations/authorised_user_model.dart';
import '../app_pages/OurProfilePage.dart';

class EditProfilePage extends StatefulWidget {
  
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {


  User user = UserPreferences.myUser;

  @override

  Widget build(BuildContext context) => Scaffold(

    
            
            body: Padding(
              padding: const EdgeInsets.only(top:64.0),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 32),
                physics: BouncingScrollPhysics(),
                children: [
                  ProfileWidget(
                    imagePath: user.imagePath,
                    isEdit: true,
                    onClicked: ()  {
                       
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFieldWidget(
                    
                    label: 'Full Name',
                    text: user.name,
                    onChanged: (name) {},
                  ),
                  const SizedBox(height: 24),
                  
                  TextFieldWidget(
                label: 'About',
                text: user.about,
                maxLines: 5,
                onChanged: (about) {},
              ),
              Padding(
                padding: const EdgeInsets.only(top:32.0),
                child: TextButton(
                  
                  onPressed: () {
                    // Perform action when button is pressed
                  },
                  child: Text('Save'),
                  
                ),
              )
            ],
              ),
            ),
          
        
      );
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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
             border: InputBorder.none,
             filled: true,

             fillColor: Color.fromARGB(40, 141, 156, 204)

            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}