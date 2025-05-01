import 'package:flutter/material.dart';
import '../UI/widgets.dart';
import '../UI/custom_elements.dart';
import '../UI/colors.dart';
import '../UI/fonts.dart';

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
      body: 
      Column(
        children: [
        Container(
          padding: EdgeInsets.all(32),
          child: ThemedCard(
            wFactor: 1.6/3,
            hFactor: 1.2/3,
            content:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    CircleAvatar(backgroundImage: AssetImage("../assets/images/han.jpg"), radius: 100,),
                    Padding(
                      padding:EdgeInsets.only(left:42),
                      child:Column(
                      children:[
                        Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: AppColors.primaryText))), child:CustomText(content: "Name", fontSize: 62, header: true,)),
                        CustomText(content: "1-Month Goal Plan", fontSize: 24)
                      ])
                    )
                  ]
                )
          
            ]
          ),
        ),
/*      
        Container(
          padding: EdgeInsets.all(32),
          child:Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: AppColors.primaryText), borderRadius: BorderRadius.circular(40)),
            semanticContainer: true,
            child: FractionallySizedBox(
              widthFactor: 1.6/3,
              heightFactor: 1.6/3,
              child:Column( 
              children: [
                  Padding(padding: EdgeInsets.all(8),
                   child:Container(
                    decoration:BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: Color(0xFF232597)))), 
                    child:Row(
                      mainAxisSize: MainAxisSize.min, 
                      children:[
                        CustomText(content: "   User Information ", fontSize: 24, header: true,),
                        Icon(Icons.edit, size:42, color:Color(0xFF232597)), 
                        CustomText(content:"  ", fontSize: 26, header: true)
                      ]
                  ))),
                  IntrinsicWidth(stepWidth:550, child:Padding(padding: EdgeInsets.all(8), child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      CustomText(content:"Age", fontSize: 24,),
                      CustomText(content: "18 yrs", fontSize: 24,)
                    ]
                  ))),
                  IntrinsicWidth(stepWidth: 550, child:Padding(padding: EdgeInsets.all(8), child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      CustomText(content:"Height", fontSize: 24,),
                      CustomText(content: "182 cm", fontSize: 24,)
                    ]
                  ))),
                  IntrinsicWidth(stepWidth:550, child:Padding(padding:EdgeInsets.all(8) , child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      CustomText(content:"Current Weight", fontSize: 24,),
                      CustomText(content:"50 kg", fontSize: 24,),
                    ]
                  ))),
                  IntrinsicWidth(stepWidth:550, child:Padding(padding:EdgeInsets.all(8), child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      CustomText(content:"Activity Level", fontSize: 24,),
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
                  ))),
                  IntrinsicWidth(stepWidth: 550, child:Padding(padding:EdgeInsets.all(8), child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      CustomText(content:"Gender", fontSize: 24, ),
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
                  )))
                ]
              )
            )
          )
        )])*/
        ]
      )
    );
  }
}