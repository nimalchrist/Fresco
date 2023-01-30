import 'package:flutter/material.dart';
import 'package:fresco/app_pages/LoginPage.dart';
import 'app_pages/AppLayoutController.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  Future<int?> get checkLogined async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");
    if (userId == null) {
      return 0;
    }
    return userId;
  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresco app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: FutureBuilder(
        future: checkLogined,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != 0) {
              dynamic userId = snapshot.data;
              print(userId);
              print(userId.runtimeType);
              return AppLayout(authorisedUser: userId);
            } else {
              return const LoginPage();
            }
          }
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 31, 21, 87),
              )),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 31, 21, 87),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
