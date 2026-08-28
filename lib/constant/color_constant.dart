import 'package:flutter/material.dart';


class ColorConstant {
  static const Color primaryColor = Color(0xFFfbfbfa);
  static const Color btnColor = Color(0xFF0D57EC);
  static const Color txtColor = Color(0xFF373839);
  static const Color borderColor = Color(0xFFe4e5e9);
  static const Color hinttxtColor = Color(0xFFcbcdd5);  
  static const Color txtColor2nd = Color(0xFF4992f0);  


  // Add more colors as needed
  // ========== COLORS ==========
  static const Color pageBg       = Color(0xFFDDE1ED);
  static const Color bgLight      = Color(0xFFF0F2F8);
  static const Color white        = Color(0xFFFFFFFF);
  static const Color border       = Color(0xFFE8EAEF);
  static const Color inkDark      = Color(0xFF0A0C18);
  static const Color inkMid       = Color(0xFF2E3250);
  static const Color inkMuted     = Color(0xFF7C82A0);
  static const Color darkBg       = Color(0xFF0D1025);
  static const Color darkBg2      = Color(0xFF161A38);
  static const Color primary      = Color(0xFF00D4A0);
  static const Color primaryDark  = Color(0xFF00A87F);
  static const Color primaryLight = Color(0xFFE0FBF4);
  static const Color red          = Color(0xFFFF4F6B);
  static const Color redLight     = Color(0xFFFFF0F3);
  static const Color blue         = Color(0xFF4A7DFF);
  static const Color blueLight    = Color(0xFFEEF2FF);
  static const Color amber        = Color(0xFFFFB020);
  static const Color amberLight   = Color(0xFFFFF8E6);
  static const Color purple       = Color(0xFF9B5CF6);
  static const Color purpleLight  = Color(0xFFF4EFFE);
  static const Color focusedFieldBg = Color(0xffE8FFF8);
  static const Color profileGradientStart = Color(0xFF0B132B);
  static const Color profileGradientMiddle = Color(0xFF10263A);
  static const Color profileGradientEnd = Color(0xFF16B98B);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBg, darkBg2],
  );
  static const LinearGradient progressGradient = LinearGradient(
    colors: [primary, Color(0xFF00E5B0)],
  );

  static const LinearGradient profileHeaderGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    profileGradientStart,
    profileGradientMiddle,
    profileGradientEnd,
  ],
  stops: [
    0.0,
    0.55,
    1.0,
  ],
);

}
    
    

