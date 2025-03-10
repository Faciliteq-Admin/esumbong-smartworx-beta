// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:smartworx/screens/map_screen.dart';
import 'package:smartworx/screens/progress_screen.dart';
import 'package:smartworx/screens/report_for_verification_screen.dart';
import 'package:smartworx/screens/updates_screen.dart';
import 'package:toastification/toastification.dart';

class ReportDetailsScreen extends StatefulWidget {
  double lat;
  double long;
  String id;
  String reporterId;
  String contractorId;
  String category;
  String subcategory;
  String status;
  String details;
  String location;
  String time;
  List attach;

  ReportDetailsScreen({
    required this.lat,
    required this.long,
    required this.id,
    required this.reporterId,
    required this.contractorId,
    required this.category,
    required this.subcategory,
    required this.status,
    required this.details,
    required this.location,
    required this.time,
    required this.attach,
    super.key,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  Map citizen = {};

  getAssignCitizen() async {
    var res = await getCitizen(
      context,
      widget.reporterId,
    );
    if (res.success) {
      if (mounted) {
        setState(() {
          citizen = res.data['data']['items'][0];
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
    getAssignCitizen();
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
            text: 'Report Details',
            color: whiteColor,
            size: 18,
          ),
          actions: [
            Visibility(
              visible: widget.status == 'Ongoing' ||
                      widget.status == 'For Verification'
                  ? true
                  : false,
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/ic_history_update.svg',
                  height: 20,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoaderOverlay(
                        child: UpdatesScreen(
                          id: widget.id,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: widget.status == 'Ongoing' ? true : false,
          child: FloatingActionButton(
            backgroundColor: whiteColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () {},
            child: SvgPicture.asset(
              'assets/icons/ic_message.svg',
              height: 30,
              width: 30,
              colorFilter: const ColorFilter.mode(
                darkRedColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (citizen['firstName'] != null) const SizedBox(height: 20),
                if (citizen['firstName'] != null)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: blackColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic_user.svg',
                                height: 14,
                                width: 14,
                                fit: BoxFit.scaleDown,
                                colorFilter: const ColorFilter.mode(
                                  whiteColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 5),
                              textLabel(
                                text: 'Citizen',
                                color: whiteColor,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: darkRedColor,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: textLabel(
                                    text:
                                        '${citizen['firstName'].toString()[0]}${citizen['lastName'].toString()[0]}',
                                    color: whiteColor,
                                    size: 18,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              textLabel(
                                text: citizen['middleName'] == null ||
                                        citizen['middleName'].toString().isEmpty
                                    ? '${citizen['firstName']} ${citizen['lastName']}'
                                    : '${citizen['firstName']} ${citizen['middleName']} ${citizen['lastName']}',
                                color: whiteColor,
                                size: 16,
                                weight: FontWeight.bold,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ic_email.svg',
                                    height: 12,
                                    width: 12,
                                    fit: BoxFit.scaleDown,
                                    colorFilter: const ColorFilter.mode(
                                      whiteColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  textLabel(
                                    text: citizen['email'].toString(),
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ic_mobile.svg',
                                    height: 12,
                                    width: 12,
                                    fit: BoxFit.scaleDown,
                                    colorFilter: const ColorFilter.mode(
                                      whiteColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  textLabel(
                                    text:
                                        '+63${citizen['mobile'].toString().substring(1)}',
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                              if (widget.status == 'Rejected')
                                const SizedBox(height: 20),
                              if (widget.status == 'Rejected')
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_time.svg',
                                      height: 10,
                                      width: 10,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: const ColorFilter.mode(
                                        whiteColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    textLabel(
                                      text: 'Time Rejected',
                                      color: whiteColor,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              if (widget.status == 'Rejected')
                                const SizedBox(height: 5),
                              if (widget.status == 'Rejected')
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: textLabel(
                                    text: '',
                                    color: whiteColor,
                                    size: 14,
                                  ),
                                ),
                              // if (widget.status == 'Ongoing' ||
                              //     widget.status == 'Resolved')
                              //   const SizedBox(height: 20),
                              // if (widget.status == 'Ongoing' ||
                              //     widget.status == 'Resolved')
                              //   Row(
                              //     children: [
                              //       SvgPicture.asset(
                              //         'assets/icons/ic_time.svg',
                              //         height: 10,
                              //         width: 10,
                              //         fit: BoxFit.scaleDown,
                              //         colorFilter: const ColorFilter.mode(
                              //           whiteColor,
                              //           BlendMode.srcIn,
                              //         ),
                              //       ),
                              //       const SizedBox(width: 5),
                              //       textLabel(
                              //         text: 'Time Responded',
                              //         color: whiteColor,
                              //         weight: FontWeight.bold,
                              //       ),
                              //     ],
                              //   ),
                              // if (widget.status == 'Ongoing' ||
                              //     widget.status == 'Resolved')
                              //   const SizedBox(height: 5),
                              // if (widget.status == 'Ongoing' ||
                              //     widget.status == 'Resolved')
                              //   Align(
                              //     alignment: Alignment.bottomLeft,
                              //     child: textLabel(
                              //       text: '',
                              //       color: whiteColor,
                              //       size: 14,
                              //     ),
                              //   ),
                              if (widget.status == 'Resolved')
                                const SizedBox(height: 10),
                              if (widget.status == 'Resolved')
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_time.svg',
                                      height: 10,
                                      width: 10,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: const ColorFilter.mode(
                                        whiteColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    textLabel(
                                      text: 'Time Resolved',
                                      color: whiteColor,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              if (widget.status == 'Resolved')
                                const SizedBox(height: 5),
                              if (widget.status == 'Resolved')
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: textLabel(
                                    text: '',
                                    color: whiteColor,
                                    size: 14,
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                textLabel(
                  text: widget.category,
                  color: blackColor,
                  size: 16,
                  weight: FontWeight.bold,
                ),
                textLabel(
                  text: widget.subcategory,
                  color: blackColor,
                  size: 14,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: widget.status == 'Pending'
                        ? lightOrangeColor
                        : widget.status == 'Ongoing'
                            ? lightYellowColor
                            : widget.status == 'For Verification'
                                ? purpleColor
                                : widget.status == 'Resolved'
                                    ? lightGreenColor
                                    : lightRedColor,
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
                      text: widget.status,
                      color: whiteColor,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_note.svg',
                      height: 10,
                      width: 10,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(width: 5),
                    textLabel(
                      text: 'Details',
                      color: blackColor,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                textLabel(
                  text: widget.details,
                  color: blackColor,
                  size: 14,
                  lines: 100,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_address.svg',
                      height: 14,
                      width: 14,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(width: 5),
                    textLabel(
                      text: 'Location',
                      color: blackColor,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(width: 10),
                    secondaryButton(
                      text: 'see on map',
                      size: 12,
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoaderOverlay(
                              child: MapScreen(
                                lat: widget.lat,
                                long: widget.long,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                textLabel(
                  text: widget.location,
                  color: blackColor,
                  size: 14,
                ),
                const SizedBox(height: 20),
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
                      text: 'Time Reported',
                      color: blackColor,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                textLabel(
                  text: timeFormat(widget.time),
                  color: blackColor,
                  size: 14,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_attachement.svg',
                      height: 14,
                      width: 14,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(width: 5),
                    textLabel(
                      text: 'Attachment/s',
                      color: blackColor,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: widget.attach.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () {
                                showImageViewer(
                                    context,
                                    Image.network(
                                      widget.attach[index]['url'],
                                    ).image,
                                    swipeDismissible: false);
                              },
                              child: Image.network(
                                widget.attach[index]['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (widget.status == 'Pending' || widget.status == 'Ongoing')
                  const SizedBox(height: 50),
                if (widget.status == 'Pending' || widget.status == 'Ongoing')
                  primaryButton(
                    text: widget.status == 'Pending'
                        ? 'Accept Report'
                        : 'Progress Update',
                    buttonColor: lightBlueColor,
                    onPressed: () async {
                      if (widget.status == 'Ongoing') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoaderOverlay(
                              child: ProgressScreen(
                                reportId: widget.id,
                                contractorId: widget.contractorId,
                              ),
                            ),
                          ),
                        );
                      }
                      if (widget.status == 'Pending') {
                        context.loaderOverlay.show;
                        var res = await updateStatusReport(
                          context,
                          widget.id,
                          'Ongoing',
                        );
                        context.loaderOverlay.hide;
                        if (res.success) {
                          setState(() {
                            widget.status = 'Ongoing';
                          });
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
                if (widget.status == 'Pending' || widget.status == 'Ongoing')
                  const SizedBox(height: 10),
                if (widget.status == 'Pending' || widget.status == 'Ongoing')
                  primaryButton(
                    text: widget.status == 'Pending'
                        ? 'Reject Report'
                        : 'For Verification',
                    buttonColor: widget.status == 'Pending'
                        ? lightRedColor
                        : purpleColor,
                    onPressed: () async {
                      context.loaderOverlay.show;
                      var res = await updateStatusReport(
                        context,
                        widget.id,
                        widget.status == 'Pending'
                            ? 'Rejected'
                            : 'For Verification',
                      );
                      context.loaderOverlay.hide;
                      if (res.success) {
                        if (widget.status == 'Pending') {
                          toast(
                            context,
                            ToastificationType.success,
                            'Report was successfully rejected',
                          );
                          Navigator.pop(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoaderOverlay(
                                child: ReportForVerificationScreen(),
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
                    },
                  ),
                const SizedBox(height: 30),
                if (widget.status == 'Ongoing') const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
