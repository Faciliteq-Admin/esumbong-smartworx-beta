// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/set_password_screen.dart';
import 'package:toastification/toastification.dart';

class OtpScreen extends StatefulWidget {
  Map userData;
  OtpScreen({
    required this.userData,
    super.key,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = '';
  late Timer _timer;
  int _start = 300;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    textLabel(
                      text:
                          'Please change your password. \nEnter the OTP sent to your email address (${widget.userData['mobile'].toString().substring(1)}).',
                      color: blackColor,
                      size: 16,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    OtpTextField(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: blackColor,
                      ),
                      cursorColor: blackColor,
                      numberOfFields: 6,
                      focusedBorderColor: purpleColor,
                      enabledBorderColor: grayColor,
                      showFieldAsBox: false,
                      borderWidth: 3.0,
                      onCodeChanged: (String verificationCode) {
                        code = verificationCode;
                      },
                      onSubmit: (String verificationCode) {
                        code = verificationCode;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_start > 0)
                            const SizedBox(
                              height: 50,
                            ),
                          if (_start > 0)
                            textLabel(
                              text: 'Resend OTP in: $_start sec(s).',
                              color: blackColor,
                              size: 14,
                              weight: FontWeight.bold,
                            ),
                          if (_start == 0)
                            textWithButton(
                              textLabel: 'Don\u0027t receive the OTP?',
                              buttonLabel: 'Resend OTP',
                              onPressed: () async {
                                setState(
                                  () {
                                    _start = 300;
                                    startTimer();
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    Spacer(),
                    secondaryButton(
                      text: 'Back to previous screen',
                      align: Alignment.center,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    primaryButton(
                      text: 'Next',
                      onPressed: () async {
                        if (code.length == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoaderOverlay(
                                child: SetPasswordScreen(
                                  otp: code,
                                  userData: widget.userData,
                                ),
                              ),
                            ),
                          );
                        } else {
                          toast(
                            context,
                            ToastificationType.warning,
                            'Invalid OTP',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
