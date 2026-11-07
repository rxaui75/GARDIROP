import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.playfairDisplay(
    fontSize: 32,
    height: 1.25,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get h2 => GoogleFonts.playfairDisplay(
    fontSize: 24,
    height: 1.33,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: 18,
    height: 1.56,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get small => GoogleFonts.inter(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
  );
}