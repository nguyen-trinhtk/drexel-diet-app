import 'package:flutter/material.dart';
import 'colors.dart';

class ThemedBoxPainter extends CustomPainter {
  final Color bg;
  final Color bd;
  final Color ds;
  final Offset a;
  final Offset b;
  final Offset c;
  final Offset d;
  final bool s;

  ThemedBoxPainter(this.bg, this.bd, this.ds, this.a, this.b, this.s, this.c, this.d);

  @override
  void paint(Canvas canvas, Size size) {
    final bgColor = Paint()
      ..color = bg
      ..style = PaintingStyle.fill;

    final bdColor = Paint()
      ..color = bd
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dsColor = Paint()
      ..color = ds
      ..style = PaintingStyle.fill;

    if (s) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromPoints(c, d), Radius.circular(40)),
        dsColor,
      );
    }
    // Draw the background
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromPoints(a, b), Radius.circular(40)),
      bgColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromPoints(a, b), Radius.circular(40)),
      bdColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ThemedBox extends StatelessWidget {
  final Color background;
  final Color border;
  final Color shadow;
  final bool dropShadow;
  final Offset pointA;
  final Offset pointB;
  final Offset pointC;
  final Offset pointD;

  const ThemedBox({
    super.key,
    this.background = AppColors.white,
    this.border = AppColors.primaryText,
    this.shadow = AppColors.accent,
    this.dropShadow = false,
    required this.pointA,
    required this.pointB,
    this.pointC = const Offset(0,0),
    this.pointD = const Offset(0,0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ThemedBoxPainter(background, border, shadow, pointA, pointB, dropShadow, pointC, pointD),
      size: MediaQuery.of(context).size,
    );
  }
}
class ThemedSidebar extends CustomPainter {
  final double width;

  ThemedSidebar({this.width = 200}); 

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondaryBackground
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}