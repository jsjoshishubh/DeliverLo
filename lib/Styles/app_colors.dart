import 'dart:ui';

import 'package:flutter/material.dart';
const int _backgroundColorValue = 0xFF4D4D4D;
const int _darkBackgroundColorValue = 0xFF202826;
const int _blackFontColorValue = 0xFF111827;
const int _greyFontColorValue = 0xFF64748B;
const int _yellowColorValues = 0xFFFEC42E;
const int _greenColorValues = 0xFF0E8345;
const int _redColorValues = 0xFFDE1135;
const int _orangeColorValues = 0xFFF48C25;




const MaterialColor backgroundColor = MaterialColor(
  _backgroundColorValue,
  <int, Color>{
    50: Color(0xFFF0F0F0),
    100: Color(0xFFF0F0F0),
    200: Color(0xFFF0F0F0),
    300: Color(0xFFF0F0F0),
    400: Color(0xFFF0F0F0),
    500: Color(0xFFF0F0F0),
    600: Color(0xFFF0F0F0),
    700: Color(0xFFF0F0F0),
    800: Color(0xFFF0F0F0),
    900: Color(0xFFF0F0F0),
  },
);

const MaterialColor orangeColor = MaterialColor(
  _orangeColorValues,
  <int, Color>{
    50: Color(0xFFF48C25),
    100: Color(0xFFF48C25),
    200: Color(0xFFF48C25),
    300: Color(0xFFF48C25),
    400: Color(0xFFF48C25),
    500: Color(0xFFF48C25),
    600: Color(0xFFF48C25),
    700: Color(0xFFF48C25),
    800: Color(0xFFF48C25),
    900: Color(0xFFF48C25),
  },
);

const MaterialColor darkbackgroundColor = MaterialColor(
  _darkBackgroundColorValue,
  <int, Color>{
    50: Color(0xFF202826),
    100: Color(0xFF202826),
    200: Color(0xFF202826),
    300: Color(0xFF202826),
    400: Color(0xFF202826),
    500: Color(0xFF202826),
    600: Color(0xFF202826),
    700: Color(0xFF202826),
    800: Color(0xFF202826),
    900: Color(0xFF202826),
  },
);

const MaterialColor blackFontColor = MaterialColor(
  _blackFontColorValue,
  <int, Color>{
    50: Color(0xFF111827),
    100: Color(0xFF111827),
    200: Color(0xFF111827),
    300: Color(0xFF111827),
    400: Color(0xFF111827),
    500: Color(0xFF111827),
    600: Color(0xFF111827),
    700: Color(0xFF111827),
    800: Color(0xFF111827),
    900: Color(0xFF111827),
  },
);

const MaterialColor greyFontColor = MaterialColor(
  _greyFontColorValue,
  <int, Color>{
    50: Color(0xFF64748B),
    100: Color(0xFF64748B),
    200: Color(0xFF64748B),
    300: Color(0xFF64748B),
    400: Color(0xFF64748B),
    500: Color(0xFF64748B),
    600: Color(0xFF64748B),
    700: Color(0xFF64748B),
    800: Color(0xFF64748B),
    900: Color(0xFF64748B),
  },
);

const MaterialColor yellowColor = MaterialColor(
  _yellowColorValues,
  <int, Color>{
    50: Color(0xFFFEC42E),
    100: Color(0xFFFEC42E),
    200: Color(0xFFFEC42E),
    300: Color(0xFFFEC42E),
    400: Color(0xFFFEC42E),
    500: Color(0xFFFEC42E),
    600: Color(0xFFFEC42E),
    700: Color(0xFFFEC42E),
    800: Color(0xFFFFEFCF),
    900: Color(0xFFFEC42E),
  },
);


const MaterialColor greenColor = MaterialColor(
  _greenColorValues,
  <int, Color>{
    50: Color(0xFFEAF7EE),
    100: Color(0xFFEAF7EE),
    200: Color(0xFFEAF7EE),
    300: Color(0xFFEAF7EE),
    400: Color(0xFFEAF7EE),
    500: Color(0xFFEAF7EE),
    600: Color(0xFFEAF7EE),
    700: Color(0xFF367065),
    800: Color(0xFF008060),
    900: Color(0xFF0E8345),
  },
);

const MaterialColor redColor = MaterialColor(
  _redColorValues,
  <int, Color>{
    50: Color(0xFFFFAB90),
    100: Color(0xFFFFAB90),
    200: Color(0xFFFFAB90),
    300: Color(0xFFFFAB90),
    400: Color(0xFFFFAB90),
    500: Color(0xFFFFAB90),
    600: Color(0xFFFFAB90),
    700: Color(0xFFFFAB90),
    800: Color(0xFFBA1B1B),
    900: Color(0xFFDE1135),
  },
);
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}