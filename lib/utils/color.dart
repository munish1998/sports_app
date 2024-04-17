import 'package:flutter/material.dart';

const Color primary = Color(0xff24D993);
const Color secondary = Color(0xda293f6e);
const Color white = Color(0xFFFFFFFF);
const Color red = Color(0xFFFF0A0A);
const Color green = Color(0xFF0FC203);
const Color grey = Color(0xFF413F3F);

LinearGradient get btnGradient => LinearGradient(colors: [
      Color(0xFF0B065E),
      Color(0xFF6D35D9),
    ]);

LinearGradient get attempt => LinearGradient(colors: [
      Color(0xFFB3EBF5),
      Color(0xFFFFFF00),
    ]);

LinearGradient get approved => LinearGradient(colors: [
      Color(0xFF5EF3BF),
      Color(0xFF51CDE2),
    ]);

LinearGradient get declined => LinearGradient(colors: [
      Color(0xCB6FE8AE),
      Color(0xFFE25151),
    ]);

LinearGradient get cancel => LinearGradient(colors: [
      Color(0xA1FADF75),
      Color(0xFFE25151),
    ]);
