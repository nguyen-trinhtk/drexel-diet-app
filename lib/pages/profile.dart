import 'package:flutter/material.dart';
import 'package:code/themes/constants.dart';
import 'package:code/themes/widgets.dart';
// import 'package:code/user-data/meals.dart';

enum Genders { male, female, nonbinary }

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
      body: Padding(
        padding: EdgeInsets.only(top: 48, bottom: 48, right: 64, left: 64),
        child: Row(
        spacing: 24,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 60,
            child: 
          Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
              flex: 10,
              child:
              ThemedCard(
                padding: EdgeInsets.only(left: 32, right:0, top:32, bottom:32),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                      [
                        Padding(
                          padding: EdgeInsets.all(32),
                          child:
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                "../assets/images/han.jpg"),
                            radius: 100,
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(32),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: "Name",
                                softWrap: true,
                                fontSize: 60,
                                header: true,
                              ),
                              CustomText(
                                content: "1-Month Goal Plan",
                                fontSize: 24
                              )
                            ]
                          )
                        )
                      ]
                  ),),),
                  
                  Expanded(
                  flex: 15,
                  child:
                  ThemedCard(
                  padding: EdgeInsets.all(32),
                  child:
                  Padding(
                  padding:EdgeInsets.only(left:54, right:54,),
                  child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          CustomText(content: "   User Information ", softWrap: true, fontSize: 24, header: true,),
                          Icon(Icons.edit, size:42, color:Color(0xFF232597)), 
                          CustomText(content:"  ", fontSize: 26, header: true)
                        ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(content:"Age", fontSize: 24,),
                        CustomText(content: "18 yrs", fontSize: 24,)
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(content:"Height", fontSize: 24,),
                        CustomText(content: "182 cm", fontSize: 24,)
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(content:"Current Weight", fontSize: 24,),
                        CustomText(content:"50 kg", fontSize: 24,),
                      ]
                    ),
                    Row(
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
                    ),
                    Row(
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
                    )
                  ])
              )))
            ],)
          ),
          Flexible(
            flex: 40,
            child: Column(
              spacing: 24,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[

              Expanded(
              flex:25,
              child:
              ThemedCard(
                padding: EdgeInsets.all(8),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      [
                          Column(
                            spacing: 2,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: "Goal Weight",
                                softWrap: true,
                                fontSize: 24,
                                header: true,
                              ),
                              CustomText(
                                content: "45",
                                header: true,
                                color: AppColors.accent,
                                fontSize: 48
                              )
                            ]
                          )
                        
                      ]
                  ),),),
              Expanded(
              flex:25,
              child:
              ThemedCard(
                padding: EdgeInsets.all(8),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      [
                          Column(
                            spacing: 2,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: "Goal Calories",
                                softWrap: true,
                                fontSize: 24,
                                header: true,
                              ),
                              CustomText(
                                content: "1792",
                                header: true,
                                color: AppColors.accent,
                                fontSize: 48
                              )
                            ]
                          )
                        
                      ]
                  ),),),
              Expanded(
              flex:25,
              child:
              ThemedCard(
                padding: EdgeInsets.all(8),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      [
                          Column(
                            spacing: 2,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: "Days Until Goal",
                                softWrap: true,
                                fontSize: 24,
                                header: true,
                              ),
                              CustomText(
                                content: "23",
                                header: true,
                                color: AppColors.accent,
                                fontSize: 48
                              )
                            ]
                          )
                        
                      ]
                  ),),),
              Expanded(
              flex:25,
              child:
              ThemedCard(
                padding: EdgeInsets.all(8),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      [
                          Column(
                            spacing: 2,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: "Days Achieved",
                                softWrap: true,
                                fontSize: 24,
                                header: true,
                              ),
                              CustomText(
                                content: "5",
                                header: true,
                                color: AppColors.accent,
                                fontSize: 48
                              )
                            ]
                          )
                        
                      ]
                  ),),)

              ]
            )
          )
          ]),
        )
    );
  }
}
