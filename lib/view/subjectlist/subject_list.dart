import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../analytics/analyticspage.dart';
import '../topiclist/topic_list.dart';

class Subject {
  String? image;
  String? name;

  Subject({Key? key,this.image,this.name});
}


class SubjectlistPage extends StatefulWidget {
  const SubjectlistPage({super.key});

  @override
  State<SubjectlistPage> createState() => _SubjectlistPageState();
}

class _SubjectlistPageState extends State<SubjectlistPage> {


 bool? _isselected;

 int optionselected =0;

 void checkOption(int index){
   setState(() {
     optionselected = index;
   });
 }

  List<Subject> subjects = [
    Subject(image:"assets/images/biology.png",name: "Biology"),
    Subject(image:"assets/images/chemistry.png",name: "Chemistry"),
    Subject(image:"assets/images/physics.png",name: "Physics"),
    Subject(image:"assets/images/math.png",name: "Mathematics"),
    Subject(image:"assets/images/eng.png",name: "English"),
  ];

  List<Color> the5Colors = [
    HexColor("#FF8A01"),
    HexColor("#FC0505"),
    HexColor("#0047FD"),
    HexColor("#EA11E1"),
    HexColor("#00FFFF")
  ];



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: subjectlist(),
      ),
    );
  }

  Widget subjectlist() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 40),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => const AnalyticsPage(),
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
                  icon: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 1.0],
                        colors: [HexColor("#201E79"), HexColor("#FF0000")],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ))
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VbText(
                text: "Subjects",
                fontColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize:
                    Device.screenType == ScreenType.tablet ? 16.sp : 19.sp,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: subjects.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 20.0,
               childAspectRatio: 1
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: (){
                  checkOption(index + 1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: index + 1 == optionselected ? 85 : 75 ,width: index + 1 == optionselected ? 85 : 75,
                      decoration: BoxDecoration(shape: BoxShape.circle,border: index + 1 == optionselected ? Border.all(color: the5Colors[index % 5],width: 3) : Border.all(color: the5Colors[index % 5],width: 1) ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset("${subjects[index].image}",fit: BoxFit.cover,),
                        )),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: VbText(
                        text: "${subjects[index].name}",
                        fontColor: Colors.black,
                        fontWeight:  FontWeight.w600,
                        fontSize: index + 1 == optionselected ? Device.screenType == ScreenType.tablet ? 15.sp : 16.sp : Device.screenType == ScreenType.tablet ? 14.sp : 15.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        ///Continue button
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 3.0)
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [HexColor("#201E79"), HexColor("#FF0000")],
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
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {

                    if(optionselected ==0) {

                      var snackBar = const SnackBar(
                          elevation: 6.0,
                          behavior: SnackBarBehavior.floating,

                          content: Row(
                            children: <Widget>[
                              Icon(
                                Icons.error_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8,),
                              Text("Please select a subject",style: TextStyle(fontFamily: "Raleway"),),
                            ],
                          ),
                          // the duration of your snack-bar
                          duration: Duration(milliseconds: 1500),
                          backgroundColor: Colors.black
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    else{
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => const TopiclistPage(),
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
                    }


                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 25, right: 25),
                    child: VbText(
                      text: "Continue",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Device.screenType == ScreenType.tablet
                          ? 14.sp
                          : 16.sp,
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
}
