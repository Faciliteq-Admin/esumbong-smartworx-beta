import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/report_details_screen.dart';

class ResolvedScreen extends StatefulWidget {
  const ResolvedScreen({super.key});

  @override
  State<ResolvedScreen> createState() => _ResolvedScreenState();
}

class _ResolvedScreenState extends State<ResolvedScreen> {
  var resolvedReports = [
    {
      'image': 'assets/images/im_user_seven.png',
      'name': 'Vanj Suarez',
      'phone': '+639444444444',
      'email': 'vanj_suarez@gmail.com',
      'reporter_address': 'Pobalacion II, Tagbilaran, Bohol',
      'address': 'Pobalacion II, Tagbilaran, Bohol',
      'time_reported': 'February 16, 2025, 3:30 PM',
      'time_responded': 'February 16, 2025, 3:35 PM',
      'time_resolved': 'February 16, 2025, 4:30 PM',
      'time_rejected': '',
      'category': 'Electrical',
      'sub_category': 'Short Circuit',
      'details':
          'The living room is without electricity, and I am unable to use the TV, lights, or any other plugged-in appliances. This is a major inconvenience for daily activities.',
      'images': [
        {
          'asset': 'assets/images/im_temp_report_eleven.png',
        },
      ],
      'status': 'Resolved'
    },
    {
      'image': 'assets/images/im_user.png',
      'name': 'Juan Dela Cruz',
      'phone': '+639987654321',
      'email': 'juan_delacruz@gmail.com',
      'reporter_address': 'Pobalacion II, Tagbilaran, Bohol',
      'address': 'Pobalacion II, Tagbilaran, Bohol',
      'time_reported': 'February 15, 2025, 2:30 PM',
      'time_responded': 'February 15, 2025, 2:35 PM',
      'time_resolved': 'February 18, 2025, 3:00 PM',
      'time_rejected': '',
      'category': 'Infrastructure',
      'sub_category': 'Road Widining',
      'details':
          'The road widening has caused severe delays and long traffic backups. Many commuters are frustrated and may be taking alternate routes through residential streets, which are not designed for heavy traffic, affecting local roads.',
      'images': [
        {
          'asset': 'assets/images/im_temp_report_twelve.png',
        },
      ],
      'status': 'Resolved'
    },
  ];

  Future<void> _pullRefreshResolved() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: darkRedColor,
        centerTitle: false,
        title: textLabel(
          text: 'Resolved Report',
          color: whiteColor,
          size: 18,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefreshResolved,
        child: ListView.builder(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 30,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: resolvedReports.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: GestureDetector(
                onTap: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => LoaderOverlay(
                  //       child: ReportDetailsScreen(
                  //           reportArray: resolvedReports[index]),
                  //     ),
                  //   ),
                  // );
                },
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textLabel(
                          text: resolvedReports[index]['category'].toString(),
                          color: blackColor,
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        textLabel(
                          text:
                              resolvedReports[index]['sub_category'].toString(),
                          color: blackColor,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_address.svg',
                              height: 10,
                              width: 10,
                              fit: BoxFit.scaleDown,
                            ),
                            const SizedBox(width: 5),
                            textLabel(
                              text:
                                  resolvedReports[index]['address'].toString(),
                              color: blackColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_time.svg',
                              height: 10,
                              width: 10,
                              fit: BoxFit.scaleDown,
                            ),
                            const SizedBox(width: 5),
                            textLabel(
                              text: resolvedReports[index]['time_reported']
                                  .toString(),
                              color: blackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: lightGreenColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5,
                            ),
                            child: textLabel(
                              text: resolvedReports[index]['status'].toString(),
                              color: whiteColor,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
