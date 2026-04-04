import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';

class ResponsiveHeading extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;

  const ResponsiveHeading(
    this.text, {
    Key? key,
    this.color = Colors.white,
    this.textAlign = TextAlign.left,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobileSize: 24,
      tabletSize: 28,
      desktopSize: 32,
    );

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ResponsiveSubheading extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;

  const ResponsiveSubheading(
    this.text, {
    Key? key,
    this.color = Colors.white70,
    this.textAlign = TextAlign.left,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobileSize: 16,
      tabletSize: 18,
      desktopSize: 20,
    );

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ResponsiveBody extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;

  const ResponsiveBody(
    this.text, {
    Key? key,
    this.color = Colors.white,
    this.textAlign = TextAlign.left,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobileSize: 14,
      tabletSize: 16,
      desktopSize: 18,
    );

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ResponsiveCaption extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;

  const ResponsiveCaption(
    this.text, {
    Key? key,
    this.color = Colors.white54,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobileSize: 12,
      tabletSize: 14,
      desktopSize: 16,
    );

    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
