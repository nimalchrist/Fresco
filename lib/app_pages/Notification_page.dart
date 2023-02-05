import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: Center(
              child: Text(
                "Sorry under maintenance",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontStyle: FontStyle.normal),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 200.0),
            child: Center(
              child: Image(
                  height: 800,
                  width: 800,
                  image: AssetImage(
                    'assets/images/girl.png',
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
