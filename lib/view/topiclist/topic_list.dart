import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../subjectlist/subject_list.dart';

class Topic {
  String? name;

  Topic({Key? key,this.name});
}


class TopiclistPage extends StatefulWidget {
  const TopiclistPage({super.key});

  @override
  State<TopiclistPage> createState() => _TopiclistPageState();
}

class _TopiclistPageState extends State<TopiclistPage> {




  List<Topic> topics = [
    Topic(name: "Where does it come From?"),
    Topic(name: "Components of Food?"),
    Topic(name: "Getting to Know Plants"),
    Topic(name: "Body Movements"),
    Topic(name: "Where does it come From?"),
    Topic(name: "Air"),
    Topic(name: "Oil"),
  ];

  List<Color> the7Colors = [
    HexColor("#003F5C"),
    HexColor("#58508D"),
    HexColor("#8A508F"),
    HexColor("#BC5090"),
    HexColor("#DE5A79"),
    HexColor("#FF6361"),
    HexColor("#C9413F"),
  ];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: topiclist(),
      ),
    );
  }

  Widget topiclist() {
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
                        pageBuilder: (c, a1, a2) => const SubjectlistPage(),
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
                text: "Topics",
                fontColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize:
                Device.screenType == ScreenType.tablet ? 16.sp : 19.sp,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            shrinkWrap: true,
              itemCount: topics.length,
              itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
              child: InkWell(
                onTap: (){

                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),color: the7Colors[index % 7]
                  ),
                  child: Center(
                    child: VbText(
                      text: "${topics[index].name}",
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize:
                      Device.screenType == ScreenType.tablet ? 13.sp : 15.sp,
                    ),
                  ),
                ),
              ),
            );
          })
        ),



      ],
    );
  }
}