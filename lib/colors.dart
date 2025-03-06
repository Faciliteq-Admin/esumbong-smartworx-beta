import 'dart:ui';

const Color blackColor = Color(0xFF000000);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blueColor = Color(0xFF1B61B5);
const Color lightGrayColor = Color(0xFFDDDDDD);
const Color grayColor = Color(0xFF707070);
const Color purpleColor = Color(0xFF5E22AF);
const Color darkGrayColor = Color(0xFF282828);
const Color lightOrangeColor = Color(0xFFFF8000);
const Color lightGreenColor = Color(0xFF00DC21);
const Color lightBlueColor = Color(0xFF54B2FE);
const Color lightRedColor = Color(0xFFF54A4A);
const Color lightYellowColor = Color(0xFFFFCC00);
const Color darkRedColor = Color(0xFF8B0000);

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${(a * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(r * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(g * 255).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(b * 255).toInt().toRadixString(16).padLeft(2, '0')}';
}
