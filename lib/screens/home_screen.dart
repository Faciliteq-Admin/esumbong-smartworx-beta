// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/account_screen.dart';
import 'package:smartworx/screens/report_details_screen.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List reportsPending = [];
  List reportsOngoing = [];

  provinceById() async {
    var res = await getProvinceById(context, int.parse(userData['provId']));
    if (res.success) {
      if (mounted) {
        if (res.data['data'].isNotEmpty) {
          setState(
            () {
              strProvince = res.data['data']['name'];
            },
          );
        }
      }
    }
  }

  cityById() async {
    var res = await getCityById(context, int.parse(userData['cityMunId']));
    if (res.success) {
      if (mounted) {
        if (res.data['data'].isNotEmpty) {
          setState(
            () {
              strCity = res.data['data']['name'];
            },
          );
        }
      }
    }
  }

  barangayById() async {
    var res = await getBarangayById(context, int.parse(userData['barangayId']));
    if (res.success) {
      if (mounted) {
        if (res.data['data'].isNotEmpty) {
          setState(
            () {
              strBarangay = res.data['data']['name'];
            },
          );
        }
      }
    }
  }

  getAllReports() async {
    var res = await getReports(context);
    if (res.success) {
      if (mounted) {
        setState(
          () {
            for (var oneReportPending in res.data['data']['items']) {
              if (oneReportPending['status'] == 'Assigned') {
                setState(() {
                  reportsPending.add(oneReportPending);
                });
              } else if (oneReportPending['status'] == 'Ongoing') {
                setState(() {
                  reportsOngoing.add(oneReportPending);
                });
              }
            }
          },
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

  Future<void> _pullRefreshPending() async {
    reportsPending = [];
    reportsOngoing = [];
    getAllReports();
  }

  Future<void> _pullRefreshOngoing() async {
    reportsPending = [];
    reportsOngoing = [];
    getAllReports();
  }

  @override
  void initState() {
    super.initState();
    provinceById();
    cityById();
    barangayById();
    getAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DefaultTabController(
        length: 2,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoaderOverlay(
                      child: AccountScreen(),
                    ),
                  ),
                );
              },
              child: SvgPicture.asset(
                'assets/icons/ic_user.svg',
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  darkRedColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: purpleColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: textLabel(
                            text:
                                '${userData['firstName'].toString()[0]}${userData['lastName'].toString()[0]}',
                            color: whiteColor,
                            size: 18,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textLabel(
                                text: 'Greetings,',
                                color: grayColor,
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              textLabel(
                                text: userData['middleName'] == null ||
                                        userData['middleName']
                                            .toString()
                                            .isEmpty
                                    ? '${userData['firstName']} ${userData['lastName']}'
                                    : '${userData['firstName']} ${userData['middleName']} ${userData['lastName']}',
                                color: blackColor,
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                          textLabel(
                              text: userData['organizationName'],
                              color: blackColor,
                              size: 14,
                              weight: FontWeight.bold),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border(
                      bottom: BorderSide(color: lightGrayColor),
                    ),
                  ),
                  child: TabBar(
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    labelColor: blackColor,
                    unselectedLabelColor: lightGrayColor,
                    indicatorColor: darkRedColor,
                    tabs: [
                      Tab(text: 'Pending'),
                      Tab(text: 'Ongoing'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: _pullRefreshPending,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 70,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: reportsPending.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 10,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoaderOverlay(
                                        child: ReportDetailsScreen(
                                          lat: reportsPending[index]
                                                      ['latitude'] !=
                                                  null
                                              ? double.parse(
                                                  reportsPending[index]
                                                      ['latitude'])
                                              : 0,
                                          long: reportsPending[index]
                                                      ['latitude'] !=
                                                  null
                                              ? double.parse(
                                                  reportsPending[index]
                                                      ['longitude'])
                                              : 0,
                                          id: reportsPending[index]['id'],
                                          reporterId: reportsPending[index]
                                              ['reportedBy'],
                                          contractorId: reportsPending[index]
                                              ['assignedResolver'],
                                          category: reportsPending[index]
                                              ['category'],
                                          subcategory: reportsPending[index]
                                              ['subcategory'],
                                          status: 'Pending',
                                          details: reportsPending[index]
                                              ['description'],
                                          location: reportsPending[index]
                                              ['street'],
                                          time: reportsPending[index]
                                              ['createdAt'],
                                          attach: reportsPending[index]
                                              ['attachments'],
                                        ),
                                      ),
                                    ),
                                  );
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
                                        color: darkGrayColor.withValues(
                                            alpha: 0.2),
                                        blurRadius: 3,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textLabel(
                                          text: reportsPending[index]
                                                  ['category']
                                              .toString(),
                                          color: blackColor,
                                          size: 16,
                                          weight: FontWeight.bold,
                                        ),
                                        textLabel(
                                          text: reportsPending[index]
                                                  ['subcategory']
                                              .toString(),
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
                                              text: reportsPending[index]
                                                      ['street']
                                                  .toString(),
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
                                              text: reportsPending[index]
                                                      ['createdAt']
                                                  .toString(),
                                              color: blackColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: lightOrangeColor,
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: textLabel(
                                              text: 'Pending',
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
                      RefreshIndicator(
                        onRefresh: _pullRefreshOngoing,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            top: 30,
                            bottom: 70,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: reportsOngoing.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 10,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoaderOverlay(
                                        child: ReportDetailsScreen(
                                          lat: reportsOngoing[index]
                                                      ['latitude'] !=
                                                  null
                                              ? double.parse(
                                                  reportsOngoing[index]
                                                      ['latitude'])
                                              : 0,
                                          long: reportsOngoing[index]
                                                      ['latitude'] !=
                                                  null
                                              ? double.parse(
                                                  reportsOngoing[index]
                                                      ['longitude'])
                                              : 0,
                                          id: reportsOngoing[index]['id'],
                                          reporterId: reportsOngoing[index]
                                              ['reportedBy'],
                                          contractorId: reportsOngoing[index]
                                              ['assignedResolver'],
                                          category: reportsOngoing[index]
                                              ['category'],
                                          subcategory: reportsOngoing[index]
                                              ['subcategory'],
                                          status: reportsOngoing[index]
                                              ['status'],
                                          details: reportsOngoing[index]
                                              ['description'],
                                          location: reportsOngoing[index]
                                              ['street'],
                                          time: reportsOngoing[index]
                                              ['createdAt'],
                                          attach: reportsOngoing[index]
                                              ['attachments'],
                                        ),
                                      ),
                                    ),
                                  );
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
                                        color: darkGrayColor.withValues(
                                            alpha: 0.2),
                                        blurRadius: 3,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textLabel(
                                          text: reportsOngoing[index]
                                                  ['category']
                                              .toString(),
                                          color: blackColor,
                                          size: 16,
                                          weight: FontWeight.bold,
                                        ),
                                        textLabel(
                                          text: reportsOngoing[index]
                                                  ['subcategory']
                                              .toString(),
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
                                              text: reportsOngoing[index]
                                                      ['street']
                                                  .toString(),
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
                                              text: reportsOngoing[index]
                                                      ['createdAt']
                                                  .toString(),
                                              color: blackColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: lightYellowColor,
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: textLabel(
                                              text: 'Ongoing',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
