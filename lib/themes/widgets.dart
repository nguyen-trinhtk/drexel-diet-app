import 'package:flutter/material.dart';
import 'constants.dart';
  

class ThemedCard extends StatelessWidget {
  //final double wFactor;
  //final double hFactor;
  final EdgeInsets padding;
  final Widget child;

  const ThemedCard({
    super.key,
    //required this.wFactor,
    required this.padding,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return //Flexible(
      /*child:*/ Card (
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.primaryText
          ),
          borderRadius: BorderRadius.circular(40)
        ),
        semanticContainer: true,
        child: Padding(
          padding: padding,
          child: child,
        )
      );
    //);
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
  final Map<String, int> nutritionInfo;

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
  final String meal;
  final List<String> foodList;
  final int protein;
  final int carbs;
  final int fat;
  final String date;
  final String time;

  const ThemedHistoryCard({
    Key? key,
    required this.calories,
    required this.meal,
    required this.date,
    required this.time,
    required this.foodList,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  List<Widget> _createFoodText() {
    return new List<Widget>.generate(foodList.length, (int index) {
      String foodName = foodList[index];
      return CustomText(
        content: "$foodName",
        fontSize: 20,
        softWrap: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(content: '$meal ($date $time)', fontSize: 16, textAlign: TextAlign.left, header: true, color: AppColors.accent),
        Card(
          color: AppColors.white,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: AppColors.primaryText,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20),
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
                          content: 'FOOD',
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
                                content: "$carbs",
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
        )
      ],
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;
  final String description;
  final String calories;
  final VoidCallback onAddPressed;
  final double fontSize;
  // final String protein;
  // final String carbs;
  // final String fat;

  const FoodCard({
    Key? key,
    required this.name,
    required this.description,
    // required this.protein,
    // required this.carbs,
    // required this.fat,
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
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
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
            Expanded(
              child: CustomText(
                content: description,
                fontSize: fontSize * 0.8,
                overflow: TextOverflow.visible,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                height: fontSize * 2,
                child: CustomButton(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    fontSize: fontSize,
                    text: 'Add',
                    bold: true,
                    onPressed: onAddPressed,
                    color: AppColors.accent,
                    hoverColor: AppColors.primaryText)),
          ],
        ),
      ),
    );
  }
}


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
  
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          SizedBox(
            child:Text(
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
          )),
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
