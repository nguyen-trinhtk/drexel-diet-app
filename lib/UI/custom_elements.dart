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
  final bool softWrap;
  final TextOverflow overflow;

  const CustomText({
    this.softWrap = false,
    this.overflow = TextOverflow.ellipsis,
    super.key,
    required this.content,
    this.header = false,
    this.fontSize = 16,
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
            softWrap: softWrap,
            overflow: overflow,
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
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color hoverColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final bool isLoading;
  final double borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool header;
  final bool bold;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryText,
    this.hoverColor = AppColors.accent,
    this.textColor = AppColors.white,
    this.fontSize = 16.0,
    this.isLoading = false,
    this.borderRadius = 40.0,
    this.borderColor = AppColors.transparentWhite,
    this.width,
    this.height,
    this.padding,
    this.header = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return hoverColor;
              }
              return color;
            },
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: CustomText(
            content: text,
            fontSize: fontSize,
            color: textColor,
            header: header,
            bold: bold,
          ),
        ),
      ),
    );
  }
}
