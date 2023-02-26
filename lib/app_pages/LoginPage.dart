import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import './RegisterPage.dart';
import '../http_operations/http_services.dart';
import 'OtpPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Httpservice httpService = Httpservice();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 100, bottom: 80),
                  height: 800,
                  child: Form(
                    key: _formKey,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(left: 6, right: 6),
                      elevation: 1,
                      shadowColor: const Color.fromARGB(255, 168, 168, 168),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(
                                      1.0,
                                      3.0,
                                    ),
                                    blurRadius: 22.0,
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: const Image(
                                height: 130,
                                width: 130,
                                image: AssetImage(
                                  'assets/images/logo.png',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(226, 32, 32, 99),
                              ),
                            ),
                          ),
                          //name
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 32,
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email can't be empty";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 32, 99),
                                  ),
                                ),
                                labelText: 'Email',
                                hintText: 'Enter the mail id',
                              ),
                            ),
                          ),

                          //password
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 25,
                              left: 16,
                              right: 16,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password can't be empty";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(226, 32, 32, 99),
                                  ),
                                ),
                                labelText: 'Password',
                                hintText: 'Enter Your Password',
                              ),
                            ),
                          ),

                          //button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: const Color.fromARGB(226, 32, 32, 99),
                                minimumSize: const Size(400, 50),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  List<dynamic> responses =
                                      await httpService.loginUser(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                  if (responses.length == 2) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(responses[0]),
                                      ),
                                    );
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            OtpScreen(
                                                authorisedUser: responses[1]),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(responses[0]),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            // child: const Text('Not registered yet? Create an account'),
                            child: RichText(
                              text: TextSpan(
                                text: 'Not registered yet?  ',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Create an account',
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color.fromARGB(226, 32, 32, 99),
                                      fontSize: 13,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const RegisterPage(),
                                            ),
                                            (Route<dynamic> route) => false,
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 30,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
