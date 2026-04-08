import 'package:flutter/material.dart';

/// App Colors - Centralized color definitions (light theme / Shorts branding)
class AppColors {
  AppColors._();

  // —— Primary (YouTube-style brand red) ——
  static const Color primary = Color(0xFFE62117);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFDAD4);
  static const Color onPrimaryContainer = Color(0xFF410001);

  // —— Secondary (link / secondary actions — YouTube blue) ——
  static const Color secondary = Color(0xFF065FD4);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD8E2FF);
  static const Color onSecondaryContainer = Color(0xFF001945);

  // —— Tertiary (supporting accent) ——
  static const Color tertiary = Color(0xFF006A6B);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF6FF6F7);
  static const Color onTertiaryContainer = Color(0xFF002021);

  // —— Surfaces & background ——
  static const Color background = Color(0xFFF9F9F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFF2F2F2);

  // —— Content / outlines ——
  static const Color onBackground = Color(0xFF0F0F0F);
  static const Color onSurface = Color(0xFF0F0F0F);
  static const Color onSurfaceVariant = Color(0xFF606060);
  static const Color outline = Color(0xFFCACACA);
  static const Color outlineVariant = Color(0xFFE8E8E8);

  // —— Error ——
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // —— Other ——
  static const Color disabled = Color(0xFF9E9E9E);
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF2F3033);
  static const Color onInverseSurface = Color(0xFFF1F0F4);
  static const Color inversePrimary = Color(0xFFFFB4A8);

  static ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: shadow,
    scrim: scrim,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    inversePrimary: inversePrimary,
    surfaceTint: primary,
  );
}
