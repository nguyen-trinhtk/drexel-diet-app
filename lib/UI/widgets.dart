import 'package:flutter/material.dart';
import 'colors.dart';
import 'custom_text.dart';

class ThemedBoxPainter extends CustomPainter {
  final Color bg;
  final Color bd;
  final Color ds;
  final Offset a;
  final Offset b;
  final Offset c;
  final Offset d;
  final bool s;

  ThemedBoxPainter(
      this.bg, this.bd, this.ds, this.a, this.b, this.s, this.c, this.d);

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
    this.pointC = const Offset(0, 0),
    this.pointD = const Offset(0, 0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ThemedBoxPainter(background, border, shadow, pointA, pointB,
          dropShadow, pointC, pointD),
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

class FoodItemInfo extends StatelessWidget {
  final String foodName;
  final int quantity;
  final Map<String, double> nutritionInfo;

  const FoodItemInfo({
    Key? key,
    required this.foodName,
    required this.quantity,
    required this.nutritionInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                content: foodName,
                fontSize: 16,
                header: true,
              ),
            ),
            Container(
              width: 50,
              alignment: Alignment.centerRight,
              child: CustomText(
                content: 'x $quantity',
                fontSize: 16,
                header: true,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: nutritionInfo.entries.map((entry) {
              return Row(
                children: [
                  Expanded(
                    child: CustomText(
                      content: entry.key,
                      fontSize: 16,
                      color: AppColors.accent,
                      bold: true,
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      content: entry.value.toString(),
                      fontSize: 16,
                      color: AppColors.accent,
                      bold: true,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ThemedHistoryCard extends Card {
  final int calories;
  final List<String> foodList;
  final int protein;
  final int carbonhydrates;
  final int fat;

  const ThemedHistoryCard({
    Key? key,
    required this.calories,
    required this.foodList,
    required this.protein,
    required this.carbonhydrates,
    required this.fat,
  });

  List<Widget> _createFoodText() {
    return new List<Widget>.generate(foodList.length, (int index) {
      String foodName = foodList[index];
      return CustomText(
        content: "$foodName",
        fontSize: 20,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: AppColors.primaryText,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  CustomText(
                    content: "$calories",
                    fontSize: 60,
                    bold: true,
                  ),
                  CustomText(
                    content: "CALORIES",
                    fontSize: 30,
                    color: AppColors.accent,
                    header: true,
                  ),
                ],
              ),
              Column(children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      content: "FOOD",
                      fontSize: 20,
                      header: true,
                      color: AppColors.accent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _createFoodText(),
                    ),
                  ],
                )
              ]),
              Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            content: "PROTEIN",
                            fontSize: 20,
                            header: true,
                            color: AppColors.accent,
                          ),
                          CustomText(
                            content: "CARB",
                            fontSize: 20,
                            header: true,
                            color: AppColors.accent,
                          ),
                          CustomText(
                            content: "FAT",
                            fontSize: 20,
                            header: true,
                            color: AppColors.accent,
                          ),
                        ]),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            content: "$protein",
                            fontSize: 20,
                          ),
                          CustomText(
                            content: "$carbonhydrates",
                            fontSize: 20,
                          ),
                          CustomText(
                            content: "$fat",
                            fontSize: 20,
                          ),
                        ]),
                  ],
                )
              ]),
            ]),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;
  final String description;
  final String calories;
  final VoidCallback onAddPressed;
  final double fontSize;

  const FoodCard({
    Key? key,
    required this.name,
    required this.description,
    required this.calories,
    required this.onAddPressed,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: AppColors.primaryText,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.5,
                    color: AppColors.accent,
                  ),
                ),
              ),
              child: CustomText(
                content: name,
                fontSize: fontSize * 1.2,
                header: true,
                textAlign: TextAlign.center,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 10),
            CustomText(
              content: calories,
              fontSize: fontSize,
              header: true,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CustomText(
                content: description,
                fontSize: fontSize * 0.8,
                overflow: TextOverflow.visible,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: fontSize * 2.5,
              width: fontSize * 6,
              child: 
                TextButton(
                  onPressed: onAddPressed,
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(0),
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(WidgetState.hovered)) {
                          return AppColors.primaryText;
                        }
                        return AppColors.accent;
                      },
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: CustomText(
                    content: "ADD",
                    fontSize: fontSize,
                    color: Colors.white,
                  ),
                ),

            ),
          ],
        ),
      ),
    );
  }
}
