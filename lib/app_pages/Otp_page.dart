import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../http_operations/http_services.dart';

class OtpScreen extends StatefulWidget {
  int? authorisedUser;
  OtpScreen({super.key, required int authorisedUser});

  @override
  State<OtpScreen> createState() =>
      _OtpScreenState(authorisedUser: authorisedUser);
}

class _OtpScreenState extends State<OtpScreen> {
  int? authorisedUser;
  late int otpCode;
  Httpservice httpService = Httpservice();

  _OtpScreenState({required this.authorisedUser});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(
            top: 80,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Fresco",
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "VERIFICATION",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 60,
              ),
              OtpTextField(
                showFieldAsBox: true,
                fieldWidth: 55,
                focusedBorderColor: const Color.fromARGB(255, 56, 39, 155),
                numberOfFields: 4,
                textStyle: const TextStyle(fontSize: 18),
                fillColor:
                    const Color.fromARGB(255, 31, 21, 87).withOpacity(0.1),
                filled: true,
                onSubmit: (String verificationCode) {
                  otpCode = int.parse(verificationCode);
                },
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 53,
                  right: 53,
                ),
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 31, 21, 87),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    await httpService.otpLoginVerification(
                      otpCode,
                      authorisedUser,
                      context,
                    );
                  },
                  child: const Text(
                    "Submit",
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
