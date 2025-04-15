import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
import '../theme/ui.dart';
import '../theme/custom_text.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';

enum Genders {male, female, nonbinary}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  Set<Genders> selection = <Genders>{Genders.female};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: <Widget> [
          IgnorePointer(child:ThemedBox(pointA: Offset(55,30), pointB: Offset(800,325))), // Profile Box
          IgnorePointer(child:ThemedBox(pointA: Offset(55,350), pointB: Offset(800,760))), // User Info Box
          Positioned(
            left: 225, bottom: 375, 
            child:Container(
              padding:EdgeInsets.only(bottom: 8), 
              decoration:BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: Color(0xFF232597)))), 
              child:Row(
                mainAxisSize: MainAxisSize.min, 
                children:[
                  CustomText(content: "   User Information ", fontSize: 24, header: true,),
                  Icon(Icons.edit, size:42, color:Color(0xFF232597)), 
                  CustomText(content:"  ", fontSize: 26, header: true)
                ]
              )
            )
          ),
          Positioned(
            left: 175, bottom: 300, 
            child:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                CustomText(content:"Age", fontSize: 24,),
                SizedBox(width:350),
                CustomText(content: "50 kg", fontSize: 24,)
              ]
            )
          ),
          Positioned(
            left: 175, bottom: 250, 
            child:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                CustomText(content:"Height", fontSize: 24,),
                SizedBox(width:310),
                CustomText(content: "18 yrs", fontSize: 24,)
              ]
            )
          ),
          Positioned(
            left: 175, bottom: 200, 
            child:Expanded(child:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                CustomText(content:"Current Weight", fontSize: 24,),
                SizedBox(width: 195),
                CustomText(content:"50 kg", fontSize: 24,),
              ]
            )),
          ),
          Positioned(
            left: 175, bottom: 150, 
            child:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                CustomText(content:"Activity Level", fontSize: 24,),
                SizedBox(width:125),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTickMarkColor: Color(0x00FFFFFF),
                    inactiveTickMarkColor: Color(0x00FFFFFF),
                    thumbColor: Color(0xFFE66D8D),
                    valueIndicatorColor: Color(0xFFE66D8D),
                    activeTrackColor: Color(0xFF232597),
                    inactiveTrackColor: Color(0xFF232597),
                    trackHeight: 2,
                    trackShape: RectangularSliderTrackShape()
                  ), 
                  child:Slider(
                    value: selectedIndex.toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: selectedIndex.toString(),
                    onChanged: (double value) {
                      setState(() {
                            selectedIndex = value.toInt();
                      });
                    },
                  ),
                )
              ]
            )
          ),
          Positioned(
            left: 175, bottom: 100, 
            child:Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                CustomText(content:"Gender", fontSize: 24,),
                SizedBox(width:210),
                SegmentedButton<Genders>(
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: Color(0xFFE66D8D),
                    selectedForegroundColor: Color(0xFFFFFFFF),
                    foregroundColor: Color(0xFF232597),
                    backgroundColor: Color(0xFFFFFFFF),
                    textStyle: TextStyle(fontFamily: AppFonts.headerFont),
                    side: const BorderSide(
                      color: Color(0xFF232597)
                    )
                  ),
                  segments: const <ButtonSegment<Genders>>[
                      ButtonSegment<Genders>(value: Genders.female, label: Text('F')),
                      ButtonSegment<Genders>(value: Genders.male, label: Text('M')),
                      ButtonSegment<Genders>(value: Genders.nonbinary, label: Text('N/A')),
                  ],
                  selected: selection,
                  onSelectionChanged: (Set<Genders> newSelection) {
                    setState(() {
                      selection = newSelection;
                    });
                  },
                )
              ]
            )
          ),
          Positioned(
            left: 335,
            top: 75,
            child: Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: AppColors.primaryText))), child:CustomText(content: "Name", fontSize: 62, header: true,)),
          ),
          Positioned(
            left:335,
            top:190,
            child: CustomText(content: "1-Month Goal Plan", fontSize: 24)
          ),
          Positioned(
            left: 90,
            top: 75,
            child: CircleAvatar(backgroundImage: AssetImage("../assets/images/han.jpg"), radius: 100,),
          ),
          IgnorePointer(child:ThemedBox(pointA: Offset(870, 30), pointB: Offset(1340, 200), dropShadow: true, pointC: Offset(878, 38), pointD: Offset(1348, 208),)),
          IgnorePointer(child:ThemedBox(pointA: Offset(870, 230), pointB: Offset(1340, 400), dropShadow: true, pointC: Offset(878, 238), pointD: Offset(1348, 408),)),
          IgnorePointer(child:ThemedBox(pointA: Offset(870, 430), pointB: Offset(1340, 600), dropShadow: true, pointC: Offset(878, 438), pointD: Offset(1348, 608),)),
          Positioned(
            right: 250,
            top: 50,
            child: CustomText(content:"Goal Weight", fontSize: 24, header: true,)
          ),
          Positioned(
            right: 300,
            top: 85,
            child: CustomText(content: "45", fontSize: 64, header: true, color: AppColors.accent,)
          ),
          Positioned(
            right: 240,
            top: 250,
            child: CustomText(content:"Goal Calories", fontSize: 24, header: true,)
          ),
          Positioned(
            right: 250,
            top: 285,
            child: CustomText(content: "1792", fontSize: 64, header: true, color: AppColors.accent,)
          ),
          Positioned(
            right: 325,
            top: 450,
            child: CustomText(content:"Days", fontSize: 24, header: true,)
          ),
          Positioned(
            right: 200,
            top: 485,
            child: CustomText(content: "5 of 23", fontSize: 64, header: true, color: AppColors.accent,)
          ),
          Positioned(
            right: 125,
            bottom: 40,
            // ignore: deprecated_member_use
            child: Stack(children:[
              TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Button pressed!')),), style: TextButton.styleFrom(padding: EdgeInsets.only(right:140, left:135, top:45, bottom:45), backgroundColor: AppColors.accent), child:CustomText(content:"View Plans  ", fontSize: 24, color: Colors.white, header: true,)),
              Positioned(
                right: 105,
                bottom: 35,
                child:Icon(Icons.arrow_forward, size: 42, color:Colors.white,)
              )
            ])
          ),
        ]
      )
    );
  }
}