import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../view/auth/login/login_screen_vbl.dart';
import '../managers/shared_preference_manager.dart';
import '../managers/user_manager.dart';
import 'const_text_vbl.dart';

class DrowerAfterlogin extends StatefulWidget {

  DrowerAfterlogin({Key? key}) : super(key: key);

  @override
  _DrowerAfterloginState createState() => _DrowerAfterloginState();
}


class _DrowerAfterloginState extends State<DrowerAfterlogin> {



  String? userName;
  String? phoneNumber;

  getUserserdata()async{

    String username = await  SharedPreferenceManager.instance.getValueFor("is_userName");

    String? phonenumber = await   SharedPreferenceManager.instance.getValueFor("mobile_number");

    setState(() {
      userName = username;
      phoneNumber = phonenumber;
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserserdata();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ?
    Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(color: Colors.white,),
      child: Column(
        children: [
          Container(
            height:  MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.25 : MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
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



            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CircleAvatar(
                  radius: 38.0,
                  backgroundColor: Colors.white,
                  child:  Icon(Icons.account_circle_rounded,color: Colors.black,size: 50,) //For Image Asset

                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text( '$userName', style: TextStyle(color: Colors.white,fontFamily: "SeoulHangang",fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 17.sp,fontWeight: FontWeight.w400),)

                )


              ],
            ),
          ),



          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),


          GestureDetector(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  VbText(
                    text: '$phoneNumber',
                    fontColor: Colors.black,
                      fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 16.sp
                  )
                ],
              ),
            ),
          ),


          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          GestureDetector(
            onTap: (){


            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  VbText(
                    text: 'Mysore',
                    fontColor: Colors.black,
                    fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 16.sp,
                  )
                ],
              ),
            ),
          ),






          Expanded(child: SizedBox()),




          Padding(
            padding: const EdgeInsets.only(
                left: 65, right: 65, top: 10,bottom: 30),
            child: Container(
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
                  minimumSize: MaterialStateProperty.all(Size(200, 40)),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  // elevation: MaterialStateProperty.all(3),
                  shadowColor:
                  MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {


                showDialog(context:
                    context, builder: (context){
                  return  AlertDialog(
                      title:  VbText(
                        text: 'Log out?',
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w800,
                        alignment: TextAlign.left,
                        fontSize: 18,
                      ),
                      content: const VbText(
                        text: 'Are you sure you want to log out?',
                        fontColor: Colors.black,
                        alignment: TextAlign.left,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const VbText(
                            text: 'Cancel',
                            fontColor: Colors.blue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextButton(
                          onPressed: (){

                            UserManager.instance.logOutUser();


                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => LoginscreenPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var tween = Tween(begin: begin, end: end);
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 500),
                              ),
                            );

                          },
                          child:  VbText(
                            text: 'Logout',
                            fontColor: Colors.red.shade700,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    );
                  },
                );






                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: const VbText(
                    text: "Logout",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),


          SizedBox(
            height: 40,
          )
        ],
      ),
    ) :
    Container(
      //height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(color: Colors.white,),
      child: Column(
        children: [
          Container(
            height:  MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 1.0],
                colors: [
                  HexColor("#fea500"),
                  HexColor("#e13b06")
                ],
              ),
            ),



            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                new CircleAvatar(
                    radius: 38.0,
                    backgroundColor: Colors.white,
                    child: new Icon(Icons.account_circle_rounded,color: Colors.black,size: 35,) //For Image Asset

                ),

                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: VbText(
                    text: '$userName',
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 17.sp,
                  ),
                )


              ],
            ),
          ),



          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),


          GestureDetector(
            onTap: (){

            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  VbText(
                      text: '$phoneNumber'??"9098908767",
                      fontColor: Colors.black,
                      fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 16.sp
                  )
                ],
              ),
            ),
          ),


          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          GestureDetector(
            onTap: (){


            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  VbText(
                    text: 'Mysore',
                    fontColor: Colors.black,
                    fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 16.sp,
                  )
                ],
              ),
            ),
          ),






          Expanded(child: SizedBox()),




          Padding(
            padding: const EdgeInsets.only(
                left: 65, right: 65, top: 10,bottom: 30),
            child: Container(
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
                  minimumSize: MaterialStateProperty.all(Size(200, 40)),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  // elevation: MaterialStateProperty.all(3),
                  shadowColor:
                  MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {


                  showDialog(context:
                  context, builder: (context){
                    return  AlertDialog(
                      title:  VbText(
                        text: 'Log out?',
                        fontColor: Colors.black,
                        fontWeight: FontWeight.w800,
                        alignment: TextAlign.left,
                        fontSize: 18,
                      ),
                      content: const VbText(
                        text: 'Are you sure you want to log out?',
                        fontColor: Colors.black,
                        alignment: TextAlign.left,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const VbText(
                            text: 'Cancel',
                            fontColor: Colors.blue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextButton(
                          onPressed: (){

                            UserManager.instance.logOutUser();

                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => LoginscreenPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var tween = Tween(begin: begin, end: end);
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 500),
                              ),
                            );

                          },
                          child:  VbText(
                            text: 'Logout',
                            fontColor: Colors.red.shade700,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    );
                  },
                  );






                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: const VbText(
                    text: "Logout",
                    fontColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),


          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}