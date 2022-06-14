// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  // Color 1
  static ThemeData lightThemeData1 =
      themeData(lightColorScheme1, _lightFocusColor);
  static ThemeData darkThemeData1 =
      themeData(darkColorScheme1, _darkFocusColor);
  // Color 2
  static ThemeData lightThemeData2 =
      themeData(lightColorScheme2, _lightFocusColor);
  static ThemeData darkThemeData2 =
      themeData(darkColorScheme2, _darkFocusColor);
  // Color 3
  static ThemeData lightThemeData3 =
      themeData(lightColorScheme3, _lightFocusColor);
  static ThemeData darkThemeData3 =
      themeData(darkColorScheme3, _darkFocusColor);
  // Color 0
  static ThemeData lightThemeData0 =
      themeData(lightColorScheme0, _lightFocusColor);
  static ThemeData darkThemeData0 =
      themeData(darkColorScheme0, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
      // Matches manifest.json colors and background color.
      primaryColor: const Color(0xFF030303),
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
        color: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
        brightness: colorScheme.brightness,
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      accentColor: colorScheme.primary,
      focusColor: focusColor,
      buttonTheme: ButtonThemeData(
          buttonColor: colorScheme.primaryVariant,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.accent),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.subtitle1!.apply(color: _darkFillColor),
      ),
    );
  }

  static const ColorScheme lightColorScheme1 = ColorScheme(
    primary: Colors.pink, //Color(0xFFB93C5D),
    primaryVariant: Color(0xFF117378),
    secondary: Color(0xFFEFF3F3),
    secondaryVariant: Color(0xFF263238),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme1 = ColorScheme(
    primary: Colors.pink,
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Colors.white, // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const ColorScheme lightColorScheme2 = ColorScheme(
    primary: Colors.blueAccent, //Color(0xFFB93C5D),
    primaryVariant: Color(0xFF117378),
    secondary: Colors.grey,
    secondaryVariant: Color(0xFF263238),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme2 = ColorScheme(
    primary: Colors.blueAccent,
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const ColorScheme lightColorScheme3 = ColorScheme(
    primary: Colors.green,
    primaryVariant: Color(0xFF117378),
    secondary: Color(0xFFEFF3F3),
    secondaryVariant: Color(0xFF263238),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.black,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme3 = ColorScheme(
    primary: Colors.green,
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Colors.white54, // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const ColorScheme lightColorScheme0 = ColorScheme(
    primary: Colors.blueGrey,
    primaryVariant: Color(0xFF117378),
    secondary: Colors.blueGrey,
    secondaryVariant: Colors.grey,
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme0 = ColorScheme(
    primary: Colors.blueGrey,
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Colors.blueGrey,
    secondaryVariant: Colors.grey,
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme2 = TextTheme(
    headline4: GoogleFonts.poppins(fontWeight: _bold, fontSize: 20.0),
    caption: GoogleFonts.poppins(fontWeight: _regular, fontSize: 16.0),
    headline3: GoogleFonts.poppins(fontWeight: _bold, fontSize: 26.0),
    headline5: GoogleFonts.poppins(fontWeight: _regular, fontSize: 16.0),
    subtitle1: GoogleFonts.poppins(fontWeight: _medium, fontSize: 16.0),
    overline: GoogleFonts.poppins(fontWeight: _medium, fontSize: 12.0),
    bodyText1: GoogleFonts.poppins(fontWeight: _regular, fontSize: 14.0),
    subtitle2: GoogleFonts.poppins(fontWeight: _medium, fontSize: 14.0),
    bodyText2: GoogleFonts.poppins(fontWeight: _regular, fontSize: 16.0),
    headline6: GoogleFonts.poppins(fontWeight: _bold, fontSize: 16.0),
    button: GoogleFonts.poppins(fontWeight: _semiBold, fontSize: 14.0),
  );

  static final TextTheme _textTheme = TextTheme(
    headline4: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
    caption: GoogleFonts.roboto(fontWeight: _regular, fontSize: 16.0),
    headline3: GoogleFonts.poppins(fontWeight: _bold, fontSize: 26.0),
    headline5: GoogleFonts.poppins(fontWeight: _bold, fontSize: 16.0),
    subtitle1: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 16.0),
    overline: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
    bodyText1: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 14.0),
    subtitle2: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
    bodyText2: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
    headline6: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 16.0),
    button: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 14.0),
  );
}
