import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/rejected_screen.dart';
import 'package:smartworx/screens/resolved_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/im_smartworx_pobla.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                textLabel(
                  text: 'Dante Fernando',
                  color: blackColor,
                  size: 16,
                  weight: FontWeight.bold,
                ),
                textLabel(
                  text: 'Barangay Poblacion II, Tagbilaran',
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
                      text: 'tagbilaran_poblacionII@gmail.com',
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
                      text: '+639112233445',
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
                  onPressed: () async {},
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
