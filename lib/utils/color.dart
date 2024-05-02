import 'package:flutter/material.dart';

const Color primary = Color(0xff24D993);
const Color secondary = Color(0xda293f6e);
const Color white = Color(0xFFFFFFFF);
const Color red = Color(0xFFFF0A0A);
const Color green = Color(0xFF0FC203);
const Color grey = Color(0xFF413F3F);

LinearGradient get btnGradient => LinearGradient(colors: [
      Color.fromRGBO(81, 205, 226, 1),
      Color.fromRGBO(2, 182, 96, 1)
      //  Color(0xFF0B065E),
      // Color(0xFF6D35D9),
    ]);

LinearGradient get attempt => LinearGradient(colors: [
      Color.fromRGBO(255, 255, 0, 1),
      Color.fromRGBO(100, 227, 65, 0.992)
      // Color.fromRGBO(81, 205, 226, 2)
      // Color.fromARGB(255, 39, 143, 106),
      // Color(0xFFB3EBF5),
      // Color(0xFFFFFF00),
    ]);

LinearGradient get approved => LinearGradient(
    colors: [Color.fromRGBO(81, 205, 226, 1), Color.fromRGBO(2, 182, 96, 1)]);

LinearGradient get declined => LinearGradient(
    colors: [Color.fromRGBO(226, 81, 81, 1), Color.fromRGBO(2, 182, 96, 1)]);

LinearGradient get cancel => LinearGradient(
    colors: [Color.fromRGBO(226, 81, 81, 1), Color.fromRGBO(169, 122, 1, 1)]);
