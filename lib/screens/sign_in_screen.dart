// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/home_screen.dart';
import 'package:smartworx/screens/otp_screen.dart';
import 'package:toastification/toastification.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return appBox.get(LOGGED_USER) != null
        ? const HomeScreen()
        : AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        primaryImageAsset(
                          context: context,
                          imageAsset: 'assets/images/im_smartworx.png',
                        ),
                        const SizedBox(height: 30),
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
                          text: 'Password',
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
                          suffixIconAsset: isObscureText
                              ? 'assets/icons/ic_password_show.svg'
                              : 'assets/icons/ic_password_hide.svg',
                          obscureText: isObscureText,
                          onPressed: () async {
                            setState(
                              () {
                                isObscureText = !isObscureText;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 50),
                        primaryButton(
                          text: 'Sign In',
                          onPressed: () async {
                            if (_email.text.trim().isEmpty) {
                              toast(
                                context,
                                ToastificationType.warning,
                                'Email address is missing',
                              );
                            } else if (_password.text.trim().isEmpty) {
                              toast(
                                context,
                                ToastificationType.warning,
                                'Password is missing',
                              );
                            } else {
                              context.loaderOverlay.show();
                              var res = await userLogin(
                                context,
                                _email.text.trim(),
                                base64Encode(
                                  utf8.encode(
                                    _password.text.trim(),
                                  ),
                                ),
                              );
                              context.loaderOverlay.hide();
                              if (res.success) {
                                if (res.data['user']['tempPassword'] != null) {
                                  context.loaderOverlay.show();
                                  var res1 = await sendOTP(
                                    context,
                                    res.data['user']['mobile'],
                                    res.data['user']['email'],
                                  );
                                  if (res1.success) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoaderOverlay(
                                          child: OtpScreen(
                                              userData: res.data['user']),
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
                                } else {
                                  appBox.put(LOGGED_USER, res.data['user']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoaderOverlay(
                                        child: HomeScreen(),
                                      ),
                                    ),
                                  );
                                }
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            secondaryButton(
                              text: 'Terms & Conditions',
                            ),
                            const SizedBox(width: 5),
                            textLabel(
                              text: 'and',
                              color: blackColor,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            secondaryButton(
                              text: 'Privacy Policy',
                            ),
                          ],
                        ),
                        Center(
                          child: textLabel(
                            text: 'Copyright © 2025 Smartworx',
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
