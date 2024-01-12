// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../../cubit/auth/login/login_cubit.dart';
import '../../../helpers/const/const_api_alert_vbl.dart';
import '../../../helpers/const/const_exit_alert.dart';
import '../../../helpers/const/const_text_vbl.dart';
import '../../../helpers/const/const_utils_vbl.dart';
import '../../../helpers/const/snackbar_const.dart';
import '../../../helpers/repository/login_repository.dart';
import '../../otp/otp_page.dart';
import '../../scan/scan_screen_vbl.dart';
import '../registration/registration_screen_vbl.dart';

class LoginscreenPage extends StatefulWidget {
  const LoginscreenPage({Key? key}) : super(key: key);

  @override
  State<LoginscreenPage> createState() => _LoginscreenPageState();
}

class _LoginscreenPageState extends State<LoginscreenPage> {


  String? device_id = "unknown";
  String? model_id = "unknown";

  late LoginCubit loginCubit;

  bool _isloading=false;
  DateTime? pre_backpress = DateTime.now();
  var mobilenumber_Controller = TextEditingController();

  bool value = false;


  GlobalKey<ScaffoldState>? _key = GlobalKey();

  late Image image1;
  late Image image2;
  late Image image3;
  //late Image image4;




  Future<void> getDeviceIdentifier() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      model_id = androidInfo.model;
      device_id = androidInfo.id;


    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      model_id = iosInfo.utsname.machine;
      device_id  = iosInfo.identifierForVendor;



    }
    print('******************MODAL ID^^^^^^^^^^^^^^^^^^$model_id');
    print('******************DEVICE ID^^^^^^^^^^^^^^^^^^$device_id');



    // return deviceIdentifier;
  }

 /* Future<void> securescreen() async{
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

  // securescreen();

    image1 = Image.asset("assets/images/loginbg.png");
    image2 = Image.asset("assets/images/vlogo.png", fit: BoxFit.contain,);
    image3 = Image.asset("assets/images/vbook_text.png",fit: BoxFit.contain,);
    //image4= Image.asset("assets/images/reg_login_bg_landscape.png",fit: BoxFit.contain,);

    getDeviceIdentifier();

    loginCubit = LoginCubit(UserLoginRepository());

  }


  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
   // precacheImage(image4.image, context);

    super.didChangeDependencies();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    mobilenumber_Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocProvider(
            create: (context) => loginCubit,
            child: BlocListener<LoginCubit, LoginState>(
              bloc: loginCubit,
              listener: (context, state) {
                if (state is LoginLoading) {}
                if (state is LoginSuccessFull) {


               /*   Fluttertoast.showToast(
                      msg: "Otp send Successfully!",
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 2,
                      fontSize: 16.0
                  );*/

                  setState(() {
                    _isloading=false;
                  });



                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) =>
                          RoundedWithCustomCursor(otp: state.otp.toString(),phone_number:mobilenumber_Controller.text,device_id: device_id.toString(),model_id:   model_id.toString(),),
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



                } else if (state is LoginFailed) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);

                  setState(() {
                    _isloading=false;
                  });
                }
              },
              child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return loginform();
                  }),
            )
        ),
      ),
    );
  }



  Widget loginform() {
    return  /*MediaQuery.of(context).orientation == Orientation.portrait ?*/
      SingleChildScrollView(
      //physics: BouncingScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration:  BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: image1.image,
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * 0.1,),


            Container(
              padding:  const EdgeInsets.only(left: 50,right: 50),
              width: MediaQuery.of(context).size.width - 100,
              height:  MediaQuery.of(context).size.width * 0.2,
              child: Row(
                children: [
                  SizedBox(
                      height: 100,
                      width: 50,
                      child: image2),
                  SizedBox(
                      height: 40,
                      width: 80,
                      child: image3),
                ],
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
            ),


            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                children: [
                  Text("Login",style: TextStyle(color: Colors.black, fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 25.sp,fontFamily: "SeoulHangang",fontWeight: FontWeight.w500,),),

                  // VblText(
                  //   text: "Login",
                  //   fontColor: Colors.black,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 25.sp,
                  // ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 32,top: 7),
              child: Row(
                children: [
                  VbText(
                    text: "Please sign in to continue.",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 18.sp,
                  ),
                ],
              ),
            ),



            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: HexColor("#FF1212").withOpacity(0.4))
                // boxShadow:[
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5), //color of shadow
                //     spreadRadius: 3, //spread radius
                //     blurRadius: 5, // blur radius
                //     offset: Offset(0, 2), // changes position of shadow
                //     //first paramerter of offset is left-right
                //     //second parameter is top to down
                //   ),
                //   //you can set more BoxShadow() here
                // ],
              ),
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                inputFormatters:  [FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: TextInputType.number,
                //autofocus: true,
                //enableInteractiveSelection:  true,
                controller: mobilenumber_Controller,
                // onChanged: (value) {
                //  setState(() {
                //    _password = value;
                //  });
                //  },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(

                  border: InputBorder.none,
                  hintText: 'Mobile Number',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
                  filled: true,
                  fillColor: HexColor("#FFFFFF"),
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF"),),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF"),),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),


            ///Login button
            Padding(
              padding: const EdgeInsets.only(top: 30),
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
                      onPressed: () async{

                        if(mobilenumber_Controller.text.isEmpty){

                          Utils.showDialouge(
                              context, AlertType.error, "Oops!", "Please fill the Mobile number field");

                        }else{


                          bool result = await SimpleConnectionChecker.isConnectedToInternet();
                          if (result == true) {

                            setState(() {
                              _isloading=true;
                            });

                            signin();

                          } else {

                            setState(() {
                              _isloading=false;
                            });

                            CustomSnackBar.showSnackBar(context,"No Internet connection");



                          }

                        }


                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                            left: 25,right: 25
                        ),
                        child: _isloading?  const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),): VbText(
                          text: "Login",
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


            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [

                 VbText(
                  text: "Don't have an account?",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: Device.screenType == ScreenType.tablet ? 13.5.sp : 15.5.sp,
                ),
                GestureDetector(
                    child: VbText(
                      text: " Sign up",
                      fontColor: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: Device.screenType == ScreenType.tablet ? 14.sp : 16.sp,
                      dec: TextDecoration.underline,
                    ),
                    onTap: () {

                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>
                          const  RegistrationscreenPage(),
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

                ),

              ],
            ),

          ],
        ),
      ),
    ) ;

    /*:

    SingleChildScrollView(
      child: Container(
        width:  MediaQuery.of(context).size.width,
        height: Device.screenType == ScreenType.mobile ? MediaQuery.of(context).size.height * 0.95 : MediaQuery.of(context).size.height,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: image4.image,
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
           shrinkWrap: true,
          //physics: BouncingScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),

            Container(
              width: MediaQuery.of(context).size.width - 100,
              height:  MediaQuery.of(context).size.width * 0.1,
              padding: const EdgeInsets.only(left: 50,right: 50),
              child: image2,
            ),



            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),


            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Row(
                children: [
                  VblText(
                    text: "Login",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 24.sp,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 32,top: 7),
              child: Row(
                children: [
                  VblText(
                    text: "Please sign in to continue.",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 18.sp,
                  ),
                ],
              ),
            ),



            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                boxShadow:[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 3, //spread radius
                    blurRadius: 5, // blur radius
                    offset: Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                inputFormatters:  [FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: TextInputType.number,
                //autofocus: true,
                //enableInteractiveSelection:  true,
                controller: mobilenumber_Controller,
                // onChanged: (value) {
                //  setState(() {
                //    _password = value;
                //  });
                //  },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(

                  border: InputBorder.none,
                  hintText: 'Mobile Number',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
                  filled: true,
                  fillColor: HexColor("#FFFFFF"),
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF"),),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF"),),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),


            ///Login button
            Padding(
              padding: const EdgeInsets.only(top: 30),
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
                          HexColor("#fea500"),
                          HexColor("#e13b06")
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
                        minimumSize: MaterialStateProperty.all(Size(160, 40)),
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
                            const  RegistrationscreenPage(),
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
                        child: _isloading?  Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),): VblText(
                          text: "Login",
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


            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [

                VblText(
                  text: "Don't have an account?",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: Device.screenType == ScreenType.tablet ? 13.5.sp : 15.5.sp,
                ),
                GestureDetector(
                    child: VblText(
                      text: " Sign up",
                      fontColor: HexColor("#d92008"),
                      fontWeight: FontWeight.w600,
                      fontSize: Device.screenType == ScreenType.tablet ? 14.sp : 16.sp,
                    ),
                    onTap: () {

                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>
                          const  RegistrationscreenPage(),
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

                ),

              ],
            ),

            //const Expanded(child: SizedBox()),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),

          ],
        ),
      ),
    )
    ;*/

  }








  void signin() {

      loginCubit.authenticateUser(
        mobilenumber_Controller.text,
        device_id.toString(),
        model_id.toString(),
      );

  }

}
