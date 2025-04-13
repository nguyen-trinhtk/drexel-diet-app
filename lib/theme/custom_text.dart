import 'package:flutter/material.dart';
import 'colors.dart';
import 'fonts.dart';

class CustomText extends StatelessWidget {
  final String content;
  final bool header; 
  final double fontSize;
  final Color color;
  final bool bold;

  const CustomText({
    required this.content,
    this.header = false,
    required this.fontSize,
    this.color = AppColors.primaryText,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    String fontFamily = header ? AppFonts.headerFont : AppFonts.textFont;
    FontWeight fontWeight = bold ? AppFonts.boldWeight : AppFonts.regularWeight;
    return Text(
      content,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
