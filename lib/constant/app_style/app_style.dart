import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  // ── SYNE — headings, amounts, buttons ──────────
  static syne({
    FontWeight weight = FontWeight.w800,
    double? size,
    Color? color,
    double? letterSpacing,
  }) => GoogleFonts.syne(
    fontWeight: weight,
    fontSize: size,
    color: color,
    letterSpacing: letterSpacing,
  );

  // ── DM SANS — body, labels, nav, descriptions ──
  static dmSans({
    FontWeight weight = FontWeight.w400,
    double? size,
    Color? color,
    double? letterSpacing,
  }) => GoogleFonts.dmSans(
    fontWeight: weight,
    fontSize: size,
    color: color,
    letterSpacing: letterSpacing,
  );
}

// ─── Quick Reference ────────────────────────────
// Balance amount:
//   AppStyles.syne(size:32, color:ColorConstant.white)
// Screen title:
//   AppStyles.syne(weight:FontWeight.w700, size:16)
// Btn text:
//   AppStyles.syne(size:14, color:ColorConstant.white)
// Txn name:
//   AppStyles.dmSans(weight:FontWeight.w700, size:12)
// Field label:
//   AppStyles.dmSans(weight:FontWeight.w700, size:11,
//     color:ColorConstant.inkMuted, letterSpacing:0.4)
// Timestamp:
//   AppStyles.dmSans(size:10, color:ColorConstant.inkMuted)
// Nav label:
//   AppStyles.dmSans(weight:FontWeight.w700, size:9)