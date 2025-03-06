// ignore_for_file: constant_identifier_names

import 'package:smartworx/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:toastification/toastification.dart';

const APP_STATE_BOX = 'app_state_box';
const LOGGED_USER = 'logged_user';

Box appBox = Hive.box(APP_STATE_BOX);
Map userData = appBox.get(LOGGED_USER);

String strProvince = '';
String strCity = '';
String strBarangay = '';

bool isObscureText = true;

toast(
  BuildContext context,
  ToastificationType type,
  String text,
) {
  toastification.show(
    context: context,
    title: Text(text),
    autoCloseDuration: const Duration(seconds: 3),
    type: type,
    style: ToastificationStyle.flatColored,
  );
}

datePicker(
  BuildContext context,
) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 150),
    lastDate: DateTime.now(),
  );
  return pickedDate;
}

Widget primaryButton({
  required String text,
  double width = double.infinity,
  Color buttonColor = darkRedColor,
  Color textColor = whiteColor,
  void Function()? onPressed,
}) {
  return SizedBox(
    child: Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          overlayColor: Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget secondaryButton({
  required String text,
  Color color = blueColor,
  double size = 14,
  Alignment align = Alignment.centerRight,
  void Function()? onPressed,
}) {
  return Align(
    alignment: align,
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget primaryImageAsset({
  required BuildContext context,
  required String imageAsset,
}) {
  return Align(
    alignment: Alignment.center,
    child: Image.asset(
      imageAsset,
      width: MediaQuery.of(context).size.shortestSide < 600 ? 250 : 300,
      height: MediaQuery.of(context).size.shortestSide < 600 ? 250 : 300,
      fit: BoxFit.cover,
    ),
  );
}

Widget textLabel({
  required String text,
  required Color color,
  var lines = 3,
  double size = 12,
  TextOverflow overflow = TextOverflow.ellipsis,
  FontWeight weight = FontWeight.normal,
  TextAlign align = TextAlign.start,
}) {
  return SizedBox(
    child: Text(
      text,
      overflow: overflow,
      maxLines: lines,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
    ),
  );
}

Widget inputTextField({
  required BuildContext context,
  required TextEditingController fieldController,
  required TextInputType textInputType,
  required String prefixIconAsset,
  var lines = 1,
  var hintText,
  bool readOnly = false,
  Color color = whiteColor,
  Color hintColor = grayColor,
  void Function()? onTap,
}) {
  return SizedBox(
    child: TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      maxLines: lines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14),
      cursorColor: blackColor,
      controller: fieldController,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 14,
        ),
        contentPadding: MediaQuery.of(context).size.shortestSide < 600
            ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)
            : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: SvgPicture.asset(
            prefixIconAsset,
            height: 20,
            width: 20,
            fit: BoxFit.scaleDown,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkRedColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightGrayColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: color,
      ),
    ),
  );
}

Widget mobileTextField({
  required BuildContext context,
  required TextEditingController fieldController,
  required TextInputType textInputType,
  required String prefixIconAsset,
}) {
  return SizedBox(
    child: TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: const TextStyle(fontSize: 14),
      cursorColor: blackColor,
      controller: fieldController,
      keyboardType: textInputType,
      maxLength: 10,
      decoration: InputDecoration(
        contentPadding: MediaQuery.of(context).size.shortestSide < 600
            ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)
            : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        counterText: '',
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 5,
            right: 10,
          ),
          child: SizedBox(
            width: 90,
            child: Row(
              children: [
                const SizedBox(width: 15),
                SvgPicture.asset(
                  prefixIconAsset,
                  height: 20,
                  width: 20,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(width: 20),
                const Text(
                  '+63',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkRedColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightGrayColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: whiteColor,
      ),
    ),
  );
}

Widget passwordTextField({
  required BuildContext context,
  required TextEditingController fieldController,
  required TextInputType textInputType,
  required String prefixIconAsset,
  required String suffixIconAsset,
  required bool obscureText,
  void Function()? onPressed,
}) {
  return SizedBox(
    child: TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      style: const TextStyle(fontSize: 14),
      cursorColor: blackColor,
      controller: fieldController,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: MediaQuery.of(context).size.shortestSide < 600
            ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)
            : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: SvgPicture.asset(
            prefixIconAsset,
            height: 20,
            width: 20,
            fit: BoxFit.scaleDown,
          ),
        ),
        suffixIcon: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: SvgPicture.asset(
              suffixIconAsset,
              height: 14,
              width: 14,
              fit: BoxFit.scaleDown,
              colorFilter: const ColorFilter.mode(
                blueColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          onPressed: onPressed,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: darkRedColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightGrayColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: whiteColor,
      ),
    ),
  );
}

Widget dropdownTextField({
  required BuildContext context,
  required TextEditingController fieldController,
  required String prefixIconAsset,
  required List<String> items,
  Color color = whiteColor,
  ValueChanged<String?>? onChanged,
}) {
  return FormField(
    builder: (state) {
      return InputDecorator(
        baseStyle: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: MediaQuery.of(context).size.shortestSide < 600
              ? const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0)
              : const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: SvgPicture.asset(
              prefixIconAsset,
              height: 20,
              width: 20,
              fit: BoxFit.scaleDown,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: darkRedColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: lightGrayColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: color,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: fieldController.text.trim().isEmpty
                ? null
                : fieldController.text.trim(),
            isDense: true,
            isExpanded: true,
            style: const TextStyle(color: Colors.black),
            onChanged: onChanged,
            items: items.map(
              (String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
        ),
      );
    },
  );
}

Widget textWithButton({
  required String textLabel,
  required String buttonLabel,
  void Function()? onPressed,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        textLabel,
        style: const TextStyle(
          color: blackColor,
          fontSize: 14,
        ),
      ),
      const SizedBox(width: 5),
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft,
          overlayColor: Colors.transparent,
        ),
        child: Text(
          buttonLabel,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: blueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
