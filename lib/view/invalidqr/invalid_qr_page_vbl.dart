import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../scan/scan_screen_vbl.dart';

class InvalidQrPage extends StatefulWidget {
  const InvalidQrPage({Key? key}) : super(key: key);

  @override
  State<InvalidQrPage> createState() => _InvalidQrPageState();
}

class _InvalidQrPageState extends State<InvalidQrPage> {


  /*Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  }*/


  screenOrientation(){
    if(Device.screenType == ScreenType.mobile){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screenOrientation();

    //securescreen();

  //  image1 = Image.asset("assets/images/qr_failed.png", fit: BoxFit.contain,);

  }


  @override
  void didChangeDependencies() {
    //precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: SafeArea(child: invalidscreen()),
      ),
    );
  }

  Widget invalidscreen(){
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /*
                 VbText(
                  text: "Oops!!",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                const SizedBox(height: 25),*/

          // Container(
          //   width: MediaQuery.of(context).size.width - 40,
          //   height: MediaQuery.of(context).size.height * 0.5,
          //   padding: const EdgeInsets.all(10),
          //   child: image1,
          // ),

          const SizedBox(height: 10),

          const VbText(
            text: "Invalid QR Code",
            fontColor: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          const SizedBox(height: 25),



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
                minimumSize: MaterialStateProperty.all(Size(200,40)),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(3),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => const ScanscreenPage(),
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
                padding: const EdgeInsets.all(15),
                child:  VbText(
                  text: "Return to Scan Page",
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}
