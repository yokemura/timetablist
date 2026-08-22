import 'package:flutter/material.dart';

/// Brand palette mapped onto Material [ColorScheme] roles.
///
/// Source tokens: `main` / `boxFill` `#00aeff`, `mainThinLine` `#0086ff`,
/// `mainDarkened` / `genericBorder` `#0080bb`, `textBoxFill` `#f4f4ff`,
/// `accent` `#ffdd00`, `warning` `#e22be0`, `background` / `reversedForeground`
/// `#ffffff`. Body text is not in that palette; `#1a1a1a` is used for
/// [ColorScheme.onSurface].
const appColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff00aeff),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffc2ecff),
  onPrimaryContainer: Color(0xff0080bb),
  secondary: Color(0xff0080bb),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffd1e8f3),
  onSecondaryContainer: Color(0xff0080bb),
  tertiary: Color(0xffffdd00),
  onTertiary: Color(0xff1a1a1a),
  tertiaryContainer: Color(0xfffff5b8),
  onTertiaryContainer: Color(0xff5c4d00),
  error: Color(0xffe22be0),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfffaddfa),
  onErrorContainer: Color(0xffe22be0),
  surface: Color(0xffffffff),
  onSurface: Color(0xff1a1a1a),
  onSurfaceVariant: Color(0xff5c5c6b),
  surfaceContainerLowest: Color(0xffffffff),
  surfaceContainerLow: Color(0xfff8f8ff),
  surfaceContainer: Color(0xfff4f4ff),
  surfaceContainerHigh: Color(0xffeeeeff),
  surfaceContainerHighest: Color(0xffe8e8f4),
  outline: Color(0xff0080bb),
  outlineVariant: Color(0xffa6d3e7),
  inverseSurface: Color(0xff1a1a1a),
  onInverseSurface: Color(0xffffffff),
  inversePrimary: Color(0xffc2ecff),
  surfaceTint: Color(0xff00aeff),
);

final ThemeData appTheme = ThemeData(
  colorScheme: appColorScheme,
  useMaterial3: true,
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: appColorScheme.primary,
      foregroundColor: appColorScheme.onPrimary,
    ),
  ),
);
