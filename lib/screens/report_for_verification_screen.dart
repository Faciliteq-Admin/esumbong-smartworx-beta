import 'package:flutter/material.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/home_screen.dart';

class ReportForVerificationScreen extends StatefulWidget {
  const ReportForVerificationScreen({super.key});

  @override
  State<ReportForVerificationScreen> createState() =>
      _ReportForVerificationScreenState();
}

class _ReportForVerificationScreenState
    extends State<ReportForVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/im_thank_you.png'),
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  textLabel(
                    text: 'For Verification',
                    color: blackColor,
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(height: 5),
                  textLabel(
                    text:
                        'Your worked has been successfully submit. Thank you for your attention and hard work. \nCitizen will confirm if the reported issue was resolved.',
                    color: blackColor,
                    size: 14,
                    lines: 10,
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  primaryButton(
                    text: 'Got It',
                    onPressed: () async {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
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
