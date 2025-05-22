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
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.05, bottom: MediaQuery.of(context).size.height*0.06, right: MediaQuery.of(context).size.width*0.05, left: MediaQuery.of(context).size.width*0.05),
        child: Row(
        spacing: MediaQuery.of(context).size.width*0.02,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 60,
            child: 
          Column(
            spacing: MediaQuery.of(context).size.height*0.04,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
              flex: 10,
              child:
              ThemedCard(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.015, right:0, top:MediaQuery.of(context).size.width*0.015, bottom:MediaQuery.of(context).size.width*0.015),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                      [
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                          child:
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                "../assets/images/han.jpg"),
                            radius: 100,
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.01),
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

                  Flexible(
                  flex: 15,
                  child:
                  ThemedCard(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                  child:
                  Padding(
                  padding:EdgeInsets.only(left:MediaQuery.of(context).size.width*0.04, right:MediaQuery.of(context).size.width*0.04,),
                  child: 
                  Column(
                    mainAxisSize: MainAxisSize.max,
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
                        SizedBox(
                        width: MediaQuery.of(context).size.width*.055,

                        //height: 60,
                        child:
                        TextField(style: TextStyle(fontSize: 24, color: AppColors.primaryText, fontFamily: AppFonts.textFont), decoration:InputDecoration(disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)),hintText: "18", suffix: CustomText(content:"yrs", color:AppColors.primaryText, fontSize: 24,), hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 24, fontFamily: AppFonts.textFont), floatingLabelBehavior: FloatingLabelBehavior.always))),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(content:"Height", fontSize: 24,),
                        SizedBox(
                        width: MediaQuery.of(context).size.width*.055,
                        //height: 60,
                        child:
                        TextField(style: TextStyle(fontSize: 24, color: AppColors.primaryText, fontFamily: AppFonts.textFont), decoration:InputDecoration(disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)),hintText: "180", suffix: CustomText(content:"cm", color:AppColors.primaryText, fontSize: 24,), hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 24, fontFamily: AppFonts.textFont), floatingLabelBehavior: FloatingLabelBehavior.always))),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(content:"Current Weight", fontSize: 24,),
                        SizedBox(
                        width: MediaQuery.of(context).size.width*.055,
                        //height: 60,
                        child:
                        TextField(style: TextStyle(fontSize: 24, color: AppColors.primaryText, fontFamily: AppFonts.textFont), decoration:InputDecoration(disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.primaryText)),hintText: "100", suffix: CustomText(content:"kg", color:AppColors.primaryText, fontSize: 24,), hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 24, fontFamily: AppFonts.textFont), floatingLabelBehavior: FloatingLabelBehavior.always))),
                        //CustomText(content:"50 kg", fontSize: 24,),
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
                          child:RepaintBoundary(child:Slider(
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
                          )),
                        )
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        CustomText(content:"Gender", fontSize: 24, ),
                        RepaintBoundary(
                        child:
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
                        ))      
                      ]
                    )
                  ])
              )))
            ],)
          ),
          Flexible(
            flex: 40,
            child: Column(
              spacing: MediaQuery.of(context).size.height*0.02,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
              Flexible(
              flex:25,
              child:
              Container(
              //decoration: BoxDecoration(color: Colors.white, boxShadow:[BoxShadow(color: AppColors.accent, offset: Offset(MediaQuery.of(context).size.width*0.007, MediaQuery.of(context).size.width*0.007)),], borderRadius: BorderRadius.circular(40)),
              child:
              ThemedCard(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.008),
                child: 
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                          Column(
                            spacing: MediaQuery.of(context).size.height*0.002,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                content: "Goal Weight",
                                softWrap: true,
                                fontSize: 24,
                                header: true,
                              ),
                              SizedBox(
                              height: MediaQuery.of(context).size.height*.1,
                              width: MediaQuery.of(context).size.width*.1,
                              child:TextField(cursorColor:AppColors.accent, style: TextStyle(fontSize: 48, color: AppColors.accent, fontFamily: AppFonts.headerFont), textAlign: TextAlign.center, decoration:InputDecoration(disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.accent)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.accent)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:AppColors.accent)),hintText: "90", hintStyle: TextStyle(color: const Color.fromARGB(148, 230, 109, 141), fontSize: 48, fontFamily: AppFonts.headerFont), floatingLabelBehavior: FloatingLabelBehavior.always))),
                            ]
                          )
                      ]
                    )
                  ),)
                  ),
              Flexible(
              flex:25,
              child:
              Container(
                //decoration: BoxDecoration(boxShadow:[BoxShadow(color: AppColors.accent, offset: Offset(MediaQuery.of(context).size.width*0.007, MediaQuery.of(context).size.width*0.007)),], borderRadius: BorderRadius.circular(40)),
                child:
              ThemedCard(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.008),
                child: 
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      [
                          Column(
                            spacing: MediaQuery.of(context).size.height*0.002,
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
                  ),),)),
              Flexible(
              flex:25,
              child:
              Container(
                //decoration: BoxDecoration(boxShadow:[BoxShadow(color: AppColors.accent, offset: Offset(10, 10)),], borderRadius: BorderRadius.circular(40)),
                child:
              ThemedCard(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.002),
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
                  ),),)),
              Flexible(
              flex:25,
              child:
              Container(
                //decoration: BoxDecoration(boxShadow:[BoxShadow(color: AppColors.accent, offset: Offset(10, 10)),], borderRadius: BorderRadius.circular(40)),
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
                            mainAxisSize: MainAxisSize.max,
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
                  ),),))

              ]
            )
          )
          ]),
        )
    );
  }
}
