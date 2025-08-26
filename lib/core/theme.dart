import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF377DFF);
  static const success = Color(0xFF38CB89);
  static const warning = Color(0xFFFFAB00);
  static const danger  = Color(0xFFFF5630);
  static const grey700 = Color(0xFF4B5A72);
  static const grey500 = Color(0xFF6E7A8D);
  static const grey100 = Color(0xFFF2F5FA);

  static ThemeData light() {
    final base = ThemeData(
      colorSchemeSeed: primary,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
    );

    final textTheme = GoogleFonts.robotoTextTheme(base.textTheme).copyWith(
      headlineMedium: GoogleFonts.roboto(fontSize: 30, height: 46/30, fontWeight: FontWeight.w900, color: grey700),
      titleLarge:    GoogleFonts.roboto(fontSize: 18, height: 28/18, fontWeight: FontWeight.w700, color: grey700),
      titleMedium:   GoogleFonts.roboto(fontSize: 16, height: 24/16, fontWeight: FontWeight.w600, color: grey700),
      bodyLarge:     GoogleFonts.roboto(fontSize: 14, height: 22/14, fontWeight: FontWeight.w400, color: grey700),
      bodyMedium:    GoogleFonts.roboto(fontSize: 13, height: 18/13, fontWeight: FontWeight.w400, color: grey700),
      bodySmall:     GoogleFonts.roboto(fontSize: 12, height: 18/12, fontWeight: FontWeight.w400, color: grey500),
      labelSmall:    GoogleFonts.roboto(fontSize: 10, height: 16/10, fontWeight: FontWeight.w400, color: grey500),
    );

    return base.copyWith(
      textTheme: textTheme,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey100,
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: textTheme.bodyMedium?.copyWith(color: grey500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE6ECF5)),
    );
  }

  static OutlineInputBorder _border({Color color = const Color(0xFFE6ECF5)}) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color, width: 1));
}
