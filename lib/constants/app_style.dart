import 'package:flutter/material.dart';

abstract class AppStyles {
  static const Color primaryColor = Color(0xFF232323);

  static const TextStyle appBarTextStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.w300,
    fontFamily: 'LexendDeca',
  );

  static const TextStyle casual = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'LexendDeca',
  );

  static const TextStyle bigCasual = TextStyle(
    fontFamily: 'LexendDeca',
    fontWeight: FontWeight.w300,
    fontSize: 24,
    color: Colors.white,
  );
}
