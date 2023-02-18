import 'package:flutter/material.dart';

class EditAccountInfo extends StatefulWidget {
  const EditAccountInfo({super.key});

  @override
  State<EditAccountInfo> createState() => _EditAccountInfoState();
}

class _EditAccountInfoState extends State<EditAccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Edit account details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0, bottom: 32.0),
              child: Icon(
                Icons.lock,
                color: Color.fromARGB(255, 31, 21, 87),
              ),
            ),
            const Text(
              "Enter the password to edit the account details",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 31, 21, 87)),
            ),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Enter the password to edit the account details",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 95, 90, 133)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('change the password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Confirm_pass(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Confirm_pass extends StatefulWidget {
  const Confirm_pass({super.key});

  @override
  State<Confirm_pass> createState() => _Confirm_passState();
}

class _Confirm_passState extends State<Confirm_pass> {
  final TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 300.0),
            child: Center(
              child: TextField(
                controller: passwordcontroller,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Editing_page(),
                  ));
            },
            child: const Text("continue"),
          )
        ],
      ),
    );
  }
}

class Editing_page extends StatefulWidget {
  const Editing_page({super.key});

  @override
  State<Editing_page> createState() => _Editing_pageState();
}

class _Editing_pageState extends State<Editing_page> {
  final TextEditingController newpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 300.0),
            child: Text("Enter new password"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Center(
              child: TextField(
                controller: newpasswordcontroller,
                obscureText: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("Save"))
        ],
      ),
    );
  }
}
