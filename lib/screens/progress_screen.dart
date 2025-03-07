// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mime/mime.dart';
import 'package:smartworx/api.dart';
import 'package:smartworx/colors.dart';
import 'package:smartworx/constant.dart';
import 'package:toastification/toastification.dart';

class ProgressScreen extends StatefulWidget {
  String reportId;
  String contractorId;
  ProgressScreen({
    required this.reportId,
    required this.contractorId,
    super.key,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final TextEditingController _details = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List images = [];
  List imagesBase64 = [];
  List attach = [];
  final _picker = ImagePicker();
  String urlImg = '';

  Future<void> _openCamera() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    if (pickedImage != null) {
      var size = File(pickedImage.path).lengthSync();
      var mimeType = lookupMimeType(pickedImage.path);
      String im = pickedImage.path.split('/').last;
      var res = await uploadFile(context, File(pickedImage.path), mimeType);
      if (res.success) {
        setState(() {
          urlImg = res.data['fileUrl'];
        });
      }
      var a = {
        'url': urlImg,
        'type': mimeType,
        'name': im,
        'size': size,
      };
      setState(
        () {
          attach.add(a);
          final bytes = File(pickedImage.path).readAsBytesSync();
          String base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
          images.add(File(pickedImage.path));
          imagesBase64.add(base64Image);
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 110);
        },
      );
    }
  }

  Future<void> _openGallery() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    if (pickedImage != null) {
      var size = File(pickedImage.path).lengthSync();
      var mimeType = lookupMimeType(pickedImage.path);
      String im = pickedImage.path.split('/').last;
      var res = await uploadFile(context, File(pickedImage.path), mimeType);
      if (res.success) {
        setState(() {
          urlImg = res.data['fileUrl'];
        });
      }
      var a = {
        'url': urlImg,
        'type': mimeType,
        'name': im,
        'size': size,
      };
      setState(
        () {
          attach.add(a);
          final bytes = File(pickedImage.path).readAsBytesSync();
          String base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
          images.add(File(pickedImage.path));
          imagesBase64.add(base64Image);
          _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent + 110);
        },
      );
    }
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
          text: 'Progress Update',
          color: whiteColor,
          size: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            textLabel(
              text: 'Details',
              color: blackColor,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            inputTextField(
              context: context,
              fieldController: _details,
              textInputType: TextInputType.multiline,
              lines: null,
              prefixIconAsset: 'assets/icons/ic_note.svg',
            ),
            const SizedBox(height: 20),
            textLabel(
              text: 'Attachment/s',
              color: blackColor,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(25),
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
                  child: PopupMenuButton(
                    icon: SvgPicture.asset(
                      'assets/icons/ic_add_image.svg',
                      height: 20,
                      width: 20,
                      fit: BoxFit.scaleDown,
                      colorFilter: const ColorFilter.mode(
                        darkRedColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'cam',
                          child: secondaryButton(
                            text: 'Camera',
                            align: Alignment.center,
                            onPressed: () async {
                              {
                                Navigator.pop(context);
                                _openCamera();
                              }
                            },
                          ),
                        ),
                        PopupMenuItem(
                          value: 'gal',
                          child: secondaryButton(
                            text: 'Gallery',
                            align: Alignment.center,
                            onPressed: () async {
                              {
                                Navigator.pop(context);
                                _openGallery();
                              }
                            },
                          ),
                        ),
                      ];
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: index == images.length - 1
                              ? const EdgeInsets.only(left: 10)
                              : const EdgeInsets.only(left: 0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: lightGrayColor,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            primaryButton(
              text: 'Update',
              buttonColor: lightBlueColor,
              onPressed: () async {
                context.loaderOverlay.show();
                var res = await updateProgressReport(
                  context,
                  widget.reportId,
                  widget.contractorId,
                  _details.text.trim(),
                  'Ongoing',
                  attach,
                );
                context.loaderOverlay.hide();
                if (res.success) {
                  toast(
                    context,
                    ToastificationType.success,
                    'Citizen will update to your progress',
                  );
                  Navigator.pop(context);
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
          ],
        ),
      ),
    );
  }
}
