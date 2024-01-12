import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../scan/scan_screen_vbl.dart';
import '../subjectlist/subject_list.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: analyticspage(),
      ),
    );
  }

  Widget analyticspage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 10,top: 40),
          child: Row(
            children: [
            IconButton(onPressed: (){

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) =>
                  const  ScanscreenPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var tween = Tween(begin: begin, end: end);
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );

            }, icon:    Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(borderRadius:
              BorderRadius.circular(7.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 1.0],
                  colors: [
                    HexColor("#201E79"),
                    HexColor("#FF0000")
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 12,),
              ),
            ))
            ],
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VbText(
                text: "Subject Data Analytics",
                fontColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 18.sp,
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(bottom: 50),
          child: PieChartSample2(),
        ),


        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 1.0],
                colors: [
                  HexColor("#201E79"),
                  HexColor("#FF0000")
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Total Time Spent  :',
                            style: TextStyle(color: Colors.white,fontFamily: "Raleway",fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 17.sp,fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                text: " 89 ",
                                style: TextStyle(color: Colors.white,fontFamily: "SeoulHangang",fontSize: Device.screenType == ScreenType.tablet ? 17.sp : 18.sp,fontWeight: FontWeight.w600),
                              ),

                              TextSpan(
                                text: "hours",
                                style: TextStyle(color: Colors.white,fontFamily: "Raleway",fontSize: Device.screenType == ScreenType.tablet ? 13.sp : 14.sp,fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),











      ],
    );
  }
}


///old code

/*class PieChartSample1 extends StatefulWidget {
  const PieChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        AspectRatio(
          aspectRatio: 1.4,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse
                        .touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              startDegreeOffset: 180,
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 1,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: HexColor("#0A9407"),
                    text: 'Chemitry',
                    isSquare: false,
                    size: touchedIndex == 0 ? 15 : 12,
                    textColor: touchedIndex == 0
                        ? Colors.black
                        : HexColor("#78726A"),
                  ),
                  Indicator(
                    color: HexColor("C60B9D"),
                    text: 'Physics',
                    isSquare: false,
                    size: touchedIndex == 1 ? 15 : 12,
                    textColor: touchedIndex == 1
                        ? Colors.black
                        :HexColor("#78726A"),
                  ),
                  Indicator(
                    color: HexColor("0766F5"),
                    text: 'Biology',
                    isSquare: false,
                    size: touchedIndex == 2 ? 15 : 12,
                    textColor: touchedIndex == 2
                        ? Colors.black
                        : HexColor("#78726A"),
                  ),

                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: HexColor("E90D0D"),
                    text: 'English',
                    isSquare: false,
                    size: touchedIndex == 3 ? 15 : 12,
                    textColor: touchedIndex == 3
                        ? Colors.black
                        : HexColor("#78726A"),
                  ),
                  Indicator(
                    color: HexColor("FFBD13"),
                    text: 'Mathematics',
                    isSquare: false,
                    size: touchedIndex == 4 ? 15 : 12,
                    textColor: touchedIndex == 4
                        ? Colors.black
                        : HexColor("#78726A"),
                  ),
                  Indicator(
                    color: Colors.transparent,
                    text: '',
                    isSquare: false,
                    size: touchedIndex == 4 ? 15 : 12,
                    textColor: touchedIndex == 4
                        ? Colors.transparent
                        : Colors.transparent,
                  ),
                ],
              ),


            ],
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

          ],
        ),



        ///View Details button
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26, offset: Offset(0, 2), blurRadius: 3.0)
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      HexColor("#201E79"),
                      HexColor("#FF0000")
                    ],
                  ),
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(160, 40)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor:
                    MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {


                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) =>
                        const  SubjectlistPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var tween = Tween(begin: begin, end: end);
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );


                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 25,right: 25
                    ),
                    child:  VblText(
                      text: "View Details",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Device.screenType == ScreenType.tablet ? 14.sp : 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      5,
          (i) {
        final isTouched = i == touchedIndex;
         var color0 = HexColor("#0A9407");
         var color1 = HexColor("C60B9D");
        var color2 = HexColor("0766F5");
        var color3 = HexColor("E90D0D");
       var color4 = HexColor("FFBD13");

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 20,
              title: '20%',
              titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Raleway"),
              radius: 89,
              titlePositionPercentageOffset: 0.65,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : const BorderSide(color: Colors.white, width: 1),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 20,
              title: '20%',
              titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Raleway"),
              radius: 80,
              titlePositionPercentageOffset: 0.65,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : const BorderSide(color: Colors.white, width: 1),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 20,
              title: '20%',
              titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Raleway"),
              radius: 105,
              titlePositionPercentageOffset: 0.65,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : const BorderSide(color: Colors.white, width: 1),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 20,
              title: '20%',
              titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Raleway"),
              radius: 90,
              titlePositionPercentageOffset: 0.65,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : const BorderSide(color: Colors.white, width: 1),
            );
          case 4:
            return PieChartSectionData(
              color: color4,
              value: 20,
              title: '20%',
              titleStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Raleway"),
              radius: 105,
              titlePositionPercentageOffset: 0.65,
              borderSide: isTouched
                  ? const BorderSide(
                  color: Colors.white, width: 6)
                  : const BorderSide(color: Colors.white, width: 1),
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 10,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: textColor,
            fontFamily: "Raleway"
          ),
        )
      ],
    );
  }
}*/


///New code
class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
             Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: HexColor("#0A9407"),
                  text: 'Chemitry',
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: HexColor("C60B9D"),
                  text: 'Physics',
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: HexColor("0766F5"),
                  text: 'Biology',
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: HexColor("E90D0D"),
                  text: 'English',
                  isSquare: true,
                ),
                const SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: HexColor("FFBD13"),
                  text: 'Mathematics',
                  isSquare: true,
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),

          ],
        ),

        ///View Details button
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26, offset: Offset(0, 2), blurRadius: 3.0)
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      HexColor("#201E79"),
                      HexColor("#FF0000")
                    ],
                  ),
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.white54; //<-- SEE HERE
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(160, 40)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor:
                    MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {


                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) =>
                        const  SubjectlistPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = const Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var tween = Tween(begin: begin, end: end);
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );


                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 25,right: 25
                    ),
                    child:  VbText(
                      text: "View Details",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Device.screenType == ScreenType.tablet ? 14.sp : 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.grey, blurRadius: 5)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: HexColor("#0A9407"),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: HexColor("C60B9D"),
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: HexColor("0766F5"),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: HexColor("E90D0D"),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: HexColor("FFBD13"),
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 10,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
              fontFamily: "Raleway"
          ),
        )
      ],
    );
  }
}