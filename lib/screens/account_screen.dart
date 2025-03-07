// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/rejected_screen.dart';
import 'package:smartworx/screens/resolved_screen.dart';
import 'package:smartworx/screens/sign_in_screen.dart';
import 'package:toastification/toastification.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map contractor = {};

  getAssignContractor() async {
    var res = await getContractor(context);
    if (res.success) {
      if (mounted) {
        setState(() {
          contractor = res.data['data'];
        });
      }
    } else {
      toast(
        context,
        ToastificationType.error,
        res.message.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAssignContractor();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: whiteColor),
          backgroundColor: darkRedColor,
          centerTitle: false,
          title: textLabel(
            text: 'Account',
            color: whiteColor,
            size: 18,
          ),
          actions: <Widget>[
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, AsyncSnapshot<PackageInfo> state) {
                String version = [
                  if (state.data != null) state.data?.version,
                ].join('+');
                return textLabel(
                  text: 'Version $version',
                  color: whiteColor,
                );
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: darkRedColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: textLabel(
                        text:
                            '${userData['firstName'].toString()[0]}${userData['lastName'].toString()[0]}',
                        color: whiteColor,
                        size: 40,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                textLabel(
                  text: userData['middleName'] == null ||
                          userData['middleName'].toString().isEmpty
                      ? '${userData['firstName']} ${userData['lastName']}'
                      : '${userData['firstName']} ${userData['middleName']} ${userData['lastName']}',
                  color: blackColor,
                  size: 16,
                  weight: FontWeight.bold,
                ),
                textLabel(
                  text: userData['organizationName'],
                  color: blackColor,
                  size: 14,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_email.svg',
                      height: 14,
                      width: 14,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(width: 5),
                    textLabel(
                      text: contractor['organizationEmail'] ?? '',
                      color: blackColor,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_mobile.svg',
                      height: 14,
                      width: 14,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(width: 5),
                    textLabel(
                      text:
                          '+63${contractor['organizationContactNumber'].toString().substring(1)}',
                      color: blackColor,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoaderOverlay(
                          child: ResolvedScreen(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: lightGrayColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkGrayColor.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: textLabel(
                      text: 'Resolved Reports',
                      color: blackColor,
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoaderOverlay(
                          child: RejectedScreen(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: lightGrayColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkGrayColor.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: textLabel(
                      text: 'Rejected Reports',
                      color: blackColor,
                      size: 14,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                primaryButton(
                  text: 'Sign Out',
                  onPressed: () async {
                    appBox.delete(LOGGED_USER);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  buttonColor: lightRedColor,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
