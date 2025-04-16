import 'package:flutter/material.dart';
import 'colors.dart';
import 'fonts.dart';

class CustomText extends StatelessWidget {
  final String content;
  final bool header;
  final double fontSize;
  final Color color;
  final bool bold;
  final TextAlign textAlign;
  final bool underline;

  const CustomText({
    super.key,
    required this.content,
    this.header = false,
    required this.fontSize,
    this.color = AppColors.primaryText,
    this.textAlign = TextAlign.left,
    this.underline = false,
    this.bold = false,
  });
@override
Widget build(BuildContext context) {
  String fontFamily = header ? AppFonts.headerFont : AppFonts.textFont;
  FontWeight fontWeight = bold ? AppFonts.boldWeight : AppFonts.regularWeight;

  return SizedBox(
    height: fontSize + 8, // Ensure enough space for underline offset
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Text(
          content,
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        ),
        if (underline)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // works better when inside a SizedBox
            child: Container(
              height: 2,
              color: color,
            ),
          ),
      ],
    ),
  );
}}