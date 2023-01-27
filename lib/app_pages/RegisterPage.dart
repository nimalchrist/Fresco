import 'package:flutter/material.dart';
import '../http_operations/http_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Httpservice httpservice = Httpservice();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _cpasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cpasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  top: 40,
                ),
                child: Form(
                  key: _formKey,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black45,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Registration',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(226, 32, 32, 99),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 32,
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Username can't be empty";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 32, 32, 99),
                                ),
                              ),
                              labelText: 'User Name',
                              hintText: 'Enter user name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
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
                                  color: Color.fromARGB(226, 32, 32, 99),
                                ),
                              ),
                              labelText: 'Email',
                              hintText: 'Enter Your Email',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password can't be empty";
                              }
                            },
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(226, 32, 32, 99),
                                ),
                              ),
                              labelText: 'New Password',
                              hintText: 'Enter Your Password',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 22,
                          ),
                          child: TextFormField(
                            controller: _cpasswordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Confirm password can't be empty";
                              }
                              if (_passwordController.text !=
                                  _cpasswordController.text) {
                                return "Password does not match";
                              }
                              return null;
                            },
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(226, 32, 32, 99),
                                ),
                              ),
                              labelText: 'Confirm New Password',
                              hintText: 'Confirm Your Password',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 16, right: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
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
                                await httpservice.registerUser(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  context,
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
