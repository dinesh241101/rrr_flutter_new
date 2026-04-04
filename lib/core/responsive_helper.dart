import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getResponsiveFontSize(
    BuildContext context, {
    double mobileSize = 14,
    double tabletSize = 16,
    double desktopSize = 18,
  }) {
    if (isDesktop(context)) return desktopSize;
    if (isTablet(context)) return tabletSize;
    return mobileSize;
  }

  static double getResponsivePadding(
    BuildContext context, {
    double mobilePadding = 16,
    double tabletPadding = 24,
    double desktopPadding = 32,
  }) {
    if (isDesktop(context)) return desktopPadding;
    if (isTablet(context)) return tabletPadding;
    return mobilePadding;
  }

  static double getResponsiveWidth(
    BuildContext context, {
    double minWidth = 300,
    double maxWidth = 600,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < minWidth) return screenWidth * 0.95;
    if (screenWidth > maxWidth) return maxWidth;
    return screenWidth * 0.9;
  }
}
