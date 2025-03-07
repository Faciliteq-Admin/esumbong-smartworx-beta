// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:toastification/toastification.dart';

class UpdatesScreen extends StatefulWidget {
  String id;
  UpdatesScreen({
    required this.id,
    super.key,
  });

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  List updates = [];

  getUpdate() async {
    var res = await getReportUpdates(
      context,
      widget.id,
    );
    if (res.success) {
      if (mounted) {
        setState(() {
          updates = res.data['data']['items'];
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

  Future<void> _pullRefresh() async {
    updates = [];
    getUpdate();
  }

  @override
  void initState() {
    super.initState();
    getUpdate();
  }

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
          text: 'Report Updates',
          color: whiteColor,
          size: 18,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 40,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: updates.length,
          itemBuilder: (context, index) {
            var oneReport = updates[index]['attachments'];
            return Padding(
              padding: index == updates.length - 1
                  ? const EdgeInsets.only(top: 10)
                  : const EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textLabel(
                      text: updates[index]['details'].toString(),
                      color: blackColor,
                      size: 18,
                      weight: FontWeight.bold,
                    ),
                    textLabel(
                      text: timeFormat(updates[index]['createdAt'].toString()),
                      color: blackColor,
                      size: 14,
                      lines: 50,
                    ),
                    if (oneReport.isNotEmpty) const SizedBox(height: 10),
                    if (oneReport.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: oneReport.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showImageViewer(
                                        context,
                                        Image.network(
                                          oneReport[index]['url'],
                                        ).image,
                                        swipeDismissible: false);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      oneReport[index]['url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
