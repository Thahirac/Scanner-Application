import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/const/snackbar_const.dart';
import '../splash/splash.dart';


class ConnectionLostScreen extends StatefulWidget {
  @override
  State<ConnectionLostScreen> createState() => _ConnectionLostScreenState();
}

class _ConnectionLostScreenState extends State<ConnectionLostScreen> {





 /* Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  }*/


  screenOrientation(){
    if(Device.screenType == ScreenType.mobile){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,]);
    }
  }

  Future<void> checkInternetConnection() async {
    SimpleConnectionChecker.isConnectedToInternet().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
              (
                  ResponsiveSizer(
                    builder: (context, orientation, deviceType) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        // navigatorKey: navigatorKey,
                        theme: ThemeData(
                          // This is the theme of your application.
                          //
                          // Try running your application with "flutter run". You'll see the
                          // application has a blue toolbar. Then, without quitting the app, try
                          // changing the primarySwatch below to Colors.green and then invoke
                          // "hot reload" (press "r" in the console where you ran "flutter run",
                          // or simply save your changes to "hot reload" in a Flutter IDE).
                          // Notice that the counter didn't reset back to zero; the application
                          // is not restarted.
                          primarySwatch: Colors.blue,
                        ),
                        home: const SplashScreen(),
                      );
                    },
                  )
              )),
        );
      } else {

        CustomSnackBar.showSnackBar(context,"No Internet connection");

      }
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    screenOrientation();

    //securescreen();


  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: SafeArea(
          child: nointernetconnection(),
        ),
      ),
    );
  }

  Widget nointernetconnection(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [




          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("Ooops!",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.grey.shade900),),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: VbText(
              text: "No Internet Connection found\n Check your connection",
              fontColor: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),



          Padding(
            padding: const EdgeInsets.only(
              left: 60, right: 60, top: 30,),
            child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HexColor("#201E79"),
                        HexColor("#FF0000")
                      ],
                    ),
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                          blurRadius: 2) //blur radius of shadow
                    ]
                ),
                child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //make color or elevated button transparent
                    ),

                    onPressed: (){


                      checkInternetConnection();


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30,right: 30),
                      child: VbText(
                        text: "Retry",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                )
            ),
          )

        ],
      ),
    );
  }




}

