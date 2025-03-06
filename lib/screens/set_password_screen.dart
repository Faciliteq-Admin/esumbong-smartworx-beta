// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/home_screen.dart';
import 'package:toastification/toastification.dart';

class SetPasswordScreen extends StatefulWidget {
  String otp;
  Map userData;
  SetPasswordScreen({
    required this.otp,
    required this.userData,
    super.key,
  });

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _email.text = widget.userData['email'];
    _otp.text = widget.otp;

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
                      text: 'Please fill out the form to change your password',
                      color: blackColor,
                      size: 16,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    textLabel(
                      text: 'New Password',
                      color: blackColor,
                      size: MediaQuery.of(context).size.shortestSide < 600
                          ? 12
                          : 24,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    passwordTextField(
                      context: context,
                      fieldController: _password,
                      textInputType: TextInputType.text,
                      prefixIconAsset: 'assets/icons/ic_password.svg',
                      suffixIconAsset: isObscureTextOTP
                          ? 'assets/icons/ic_password_show.svg'
                          : 'assets/icons/ic_password_hide.svg',
                      obscureText: isObscureTextOTP,
                      onPressed: () async {
                        setState(
                          () {
                            isObscureTextOTP = !isObscureTextOTP;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    textLabel(
                      text: 'Email Address',
                      color: blackColor,
                      size: MediaQuery.of(context).size.shortestSide < 600
                          ? 12
                          : 24,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    inputTextField(
                      context: context,
                      fieldController: _email,
                      textInputType: TextInputType.emailAddress,
                      prefixIconAsset: 'assets/icons/ic_email.svg',
                      color: whiteColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(height: 20),
                    textLabel(
                      text: 'OTP',
                      color: blackColor,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    inputTextField(
                      context: context,
                      fieldController: _otp,
                      textInputType: TextInputType.multiline,
                      prefixIconAsset: 'assets/icons/ic_password.svg',
                      color: whiteColor.withValues(alpha: 0.7),
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
                        if (_password.text.trim().isEmpty) {
                          toast(
                            context,
                            ToastificationType.warning,
                            'New password is missing',
                          );
                        } else if (_email.text.trim().isEmpty) {
                          toast(
                            context,
                            ToastificationType.warning,
                            'Email address is missing',
                          );
                        } else if (_otp.text.trim().isEmpty) {
                          toast(
                            context,
                            ToastificationType.warning,
                            'OTP is missing',
                          );
                        } else {
                          context.loaderOverlay.show();
                          var res = await setPassword(
                            context,
                            base64Encode(
                              utf8.encode(
                                _password.text.trim(),
                              ),
                            ),
                            _email.text.trim(),
                            _otp.text.trim(),
                          );
                          context.loaderOverlay.hide();
                          if (res.success) {
                            appBox.put(LOGGED_USER, widget.userData);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoaderOverlay(
                                  child: HomeScreen(),
                                ),
                              ),
                            );
                          } else {
                            toast(
                              context,
                              ToastificationType.error,
                              res.message.toString(),
                            );
                          }
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
