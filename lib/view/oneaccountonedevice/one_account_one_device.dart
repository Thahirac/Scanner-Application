import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/managers/user_manager.dart';
import '../auth/login/login_screen_vbl.dart';

class OneAccountOneDeviceVB extends StatefulWidget {
  const OneAccountOneDeviceVB({super.key});

  @override
  State<OneAccountOneDeviceVB> createState() => _OneAccountOneDeviceVBState();
}

class _OneAccountOneDeviceVBState extends State<OneAccountOneDeviceVB> {
  /*Future<void> securescreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/

  screenOrientation() {
    if (Device.screenType == ScreenType.mobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserManager.instance.logOutUser();

    screenOrientation();

    //securescreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: oneuseronedevice(),
      ),
    );
  }

  Widget oneuseronedevice() {
    return SingleChildScrollView(
      //physics: BouncingScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),

              const Expanded(child: SizedBox()),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: VbText(
                  text:
                      "You have already logged-in in another mobile. Logout from another mobile to continue.",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 60,
                  right: 60,
                  top: 50,
                ),
                child: Container(
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(Size(170, 40)),
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
                          pageBuilder: (c, a1, a2) => LoginscreenPage(),
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
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: const VbText(
                        text: "I understand",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),

              //  const Expanded(child: SizedBox()),

              // SizedBox(height: MediaQuery.of(context).size.height * 0.05,)
            ],
          ),
        ),
      ),
    );
  }
}
