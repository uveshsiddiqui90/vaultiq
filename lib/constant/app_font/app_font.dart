import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class AppFont {
  
// ========== FONTS ==========
// google_fonts: ^6.x
static syne({FontWeight weight = FontWeight.w800}) =>
    GoogleFonts.syne(fontWeight: weight);

static dmSans({FontWeight weight = FontWeight.w500}) =>
    GoogleFonts.dmSans(fontWeight: weight);
}