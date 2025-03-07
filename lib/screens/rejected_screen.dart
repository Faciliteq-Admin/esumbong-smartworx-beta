import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/report_details_screen.dart';

class RejectedScreen extends StatefulWidget {
  const RejectedScreen({super.key});

  @override
  State<RejectedScreen> createState() => _RejectedScreenState();
}

class _RejectedScreenState extends State<RejectedScreen> {
  var rejectedReports = [
    {
      'image': 'assets/images/im_user_two.png',
      'name': 'Carlos Camul',
      'phone': '+63933333333',
      'email': 'carlos_camul@gmail.com',
      'reporter_address': 'Pobalacion II, Tagbilaran, Bohol',
      'address': 'Pobalacion II, Tagbilaran, Bohol',
      'time_reported': 'February 16, 2025, 5:30 PM',
      'time_responded': '',
      'time_resolved': '',
      'time_rejected': 'February 16, 2025, 6:00 PM',
      'category': 'Emergency Services',
      'sub_category': 'Police Resource Allocation',
      'details':
          'With limited police presence, the situation felt unsafe, especially as the event went late into the evening. The lack of officers could have contributed to the escalation of minor issues, and there was a clear risk of a more serious incident occurring.',
      'images': [
        {
          'asset': 'assets/images/im_temp_report_thirtheen.png',
        },
        {
          'asset': 'assets/images/im_temp_report_fourtheen.png',
        },
      ],
      'status': 'Rejected'
    },
  ];

  Future<void> _pullRefreshRejected() async {}

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
          text: 'Rejected Report',
          color: whiteColor,
          size: 18,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefreshRejected,
        child: ListView.builder(
          padding: const EdgeInsets.only(
            top: 30,
            bottom: 30,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: rejectedReports.length,
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
                  //           reportArray: rejectedReports[index]),
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
                          text: rejectedReports[index]['category'].toString(),
                          color: blackColor,
                          size: 16,
                          weight: FontWeight.bold,
                        ),
                        textLabel(
                          text:
                              rejectedReports[index]['sub_category'].toString(),
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
                                  rejectedReports[index]['address'].toString(),
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
                              text: rejectedReports[index]['time_reported']
                                  .toString(),
                              color: blackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: lightRedColor,
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
                              text: rejectedReports[index]['status'].toString(),
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
