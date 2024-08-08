import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wireguard/models/constants.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static ThemeData lightTheme({
    required BuildContext context,
  }) {
    return ThemeData(
      // TextTheme(),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: kPrimaryColor,
        cursorColor: kPrimaryColor,
        selectionColor: kPrimaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1.5, color: Colors.black),
        ),
        border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black), // Set your border color here
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            color: Theme.of(context).textTheme.titleLarge!.color,
          )),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      disabledColor: Colors.grey[600],
      brightness: Brightness.light,
      snackBarTheme:
          SnackBarThemeData(backgroundColor: Theme.of(context).cardColor),
      indicatorColor: kPrimaryColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData().copyWith(color: kPrimaryColor),
      iconTheme: IconThemeData(
        color: Colors.grey[900],
        opacity: 1.0,
        size: 24.0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor, // Replace with your desired color
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData darkTheme({
    required BuildContext context,
  }) {
    return ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryLightColor,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: kPrimaryColor,
        cursorColor: kPrimaryColor,
        selectionColor: kPrimaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: kPrimaryLightColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(width: 1.5, color: kPrimaryLightColor),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
              color: kPrimaryLightColor), // Set your border color here
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: kPrimaryDarkColor,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: kPrimaryLightColor,
        textColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        iconColor: kPrimaryLightColor,
        textColor: kPrimaryLightColor,
        collapsedTextColor: kPrimaryLightColor,
        collapsedIconColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
          color: kPrimaryDarkColor,
          textStyle: const TextStyle(color: kPrimaryLightColor),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            // Default TextStyle
            return const TextStyle(color: kPrimaryLightColor);
          })),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      snackBarTheme:
          SnackBarThemeData(backgroundColor: Theme.of(context).hintColor),
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
        ),
        backgroundColor: kPrimaryDarkColor,
        foregroundColor: kPrimaryLightColor,
      ),
      canvasColor: kPrimaryDarkColor,
      scaffoldBackgroundColor: kPrimaryDarkColor,
      textTheme: Typography.whiteCupertino,
      drawerTheme: const DrawerThemeData(
        backgroundColor: kPrimaryDarkColor,
      ),
      cardColor: kPrimaryDarkColor,
      cardTheme: CardTheme(
        color: kPrimaryDarkColor,
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      dialogBackgroundColor: kPrimaryDarkColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData().copyWith(color: kPrimaryColor),
      iconTheme: const IconThemeData(
        color: kPrimaryLightColor,
        opacity: 1.0,
        size: 24.0,
      ),
      indicatorColor: kPrimaryColor,
      colorScheme: ColorScheme.fromSeed(
        scrim: kPrimaryColor,
        seedColor: kPrimaryColor, // Replace with your desired color
        brightness: Brightness.dark,
      ),
    );
  }
}
