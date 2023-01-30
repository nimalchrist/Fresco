import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../http_operations/http_services.dart';
import './App_layout_controller.dart';

class OtpScreen extends StatefulWidget {
  final int authorisedUser;
  const OtpScreen({Key? key, required this.authorisedUser}) : super(key: key);

  @override
  State<OtpScreen> createState() =>
      _OtpScreenState(authorisedUser: authorisedUser);
}

class _OtpScreenState extends State<OtpScreen> {
  final int authorisedUser;
  late String otpCode;
  Httpservice httpService = Httpservice();

  _OtpScreenState({required this.authorisedUser});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 200.0, bottom: 32.0),
                child: Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 31, 21, 87),
                ),
              ),
              const Text(
                "Enter Code",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 31, 21, 87)),
              ),
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "We sent OTP code to your email address",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 95, 90, 133)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: OtpTextField(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    borderColor: const Color.fromARGB(255, 56, 39, 155),
                    fieldWidth: 45,
                    showFieldAsBox: true,
                    focusedBorderColor: const Color.fromARGB(255, 56, 39, 155),
                    numberOfFields: 4,
                    textStyle: const TextStyle(fontSize: 18),
                    fillColor:
                        Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                    filled: true,
                    onSubmit: (String verificationCode) {
                      otpCode = verificationCode;
                    },
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(
                      255,
                      31,
                      21,
                      87,
                    ),
                  ),
                ),
                onPressed: () async {
                  List<dynamic> response = await httpService.otpVerification(
                    otpCode,
                    authorisedUser,
                  );
                  if (response.length == 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(response[0]),
                      ),
                    );
                    // Navigate to the next screen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => AppLayout(
                          authorisedUser: response[1],
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response[0]),
                      ),
                    );
                  }
                },
                child: const Text('Verify email'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
