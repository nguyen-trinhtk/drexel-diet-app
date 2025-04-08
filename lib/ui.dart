import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemedBoxPainter extends CustomPainter {

  final Color bg;
  final Color bd;
  final Offset a;
  final Offset b;

  ThemedBoxPainter(this.bg, this.bd, this.a, this.b);

  @override
  void paint(Canvas canvas, Size size) {
    final bgColor = Paint()
      ..color = bg
      ..style = PaintingStyle.fill;

    final bdColor = Paint()
      ..color = bd
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw the background
    canvas.drawRRect( 
      RRect.fromRectAndRadius(Rect.fromPoints(Offset(70,400), Offset(700,775)), Radius.circular(40)),
      bgColor,
    );
        canvas.drawRRect( 
      RRect.fromRectAndRadius(Rect.fromPoints(Offset(70,400), Offset(700,775)), Radius.circular(40)),
      bdColor,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ThemedBox extends StatelessWidget {
  
  final Color background;
  final Color border;
  final Offset pointA;
  final Offset pointB;

 const ThemedBox({
    super.key,
    this.background = const Color(0xFFFFFFFF),
    this.border = const Color(0xFF232597),
    required this.pointA,
    required this.pointB,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ThemedBoxPainter(background, border, pointA, pointB), size:MediaQuery.of(context).size,);
  }
  
}

class ThemedSidebar extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 255, 205, 208)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect( 
      Rect.fromLTWH(0, 0, 212, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>false;

}

class MealCard extends GFCard {
  MealCard({
    super.key,
    super.color, 
    super.elevation, 
    super.shape, 
    super.borderOnForeground, 
    super.padding, 
    super.margin, 
    super.clipBehavior, 
    super.semanticContainer, 
    super.title, 
    super.content, 
    super.image, 
    super.showImage, 
    super.showOverlayImage, 
    super.buttonBar, 
    super.imageOverlay, 
    super.titlePosition, 
    super.boxFit, 
    super.colorFilter, 
    super.height, 
    super.gradient, 
    });
    @override
    // ignore: overridden_fields
    final borderRadius = BorderRadius.all(Radius.circular(40));
    @override
    // ignore: overridden_fields
    final border = Border.all(color: Color(0xFF232597), width:1, style: BorderStyle.solid);
    @override 
    // ignore: overridden_fields
    final color = Color(0xFFFFFFFF);
    @override
    // ignore: overridden_fields
    final boxFit = BoxFit.cover;
}


