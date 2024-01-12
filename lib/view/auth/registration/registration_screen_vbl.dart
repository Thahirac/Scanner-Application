// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../../cubit/auth/registration/register_cubit.dart';
import '../../../helpers/const/const_api_alert_vbl.dart';
import '../../../helpers/const/const_exit_alert.dart';
import '../../../helpers/const/const_text_vbl.dart';
import '../../../helpers/const/const_utils_vbl.dart';
import '../../../helpers/const/snackbar_const.dart';
import '../../../helpers/repository/registration_repository.dart';
import '../../../services/notification_service.dart';
import '../../otp/otp_page.dart';
import '../../scan/scan_screen_vbl.dart';
import '../login/login_screen_vbl.dart';


class RegistrationscreenPage extends StatefulWidget {
  const RegistrationscreenPage({Key? key}) : super(key: key);

  @override
  State<RegistrationscreenPage> createState() => _RegistrationscreenPageState();
}

class _RegistrationscreenPageState extends State<RegistrationscreenPage> {

  late RegisterCubit registerCubit;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  bool _isloading=false;



  var Username_Controller = TextEditingController();
  var mobilenumber_Controller = TextEditingController();
  var activation_key_Controller = TextEditingController();


  String? device_id = "unknown";
  String? model_id = "unknown";


  late Image image1;
  late Image image2;
  late Image image3;
  //late Image image4;



  //NotificationService notificationService = NotificationService();


  // var random_otp="";
  // void randomotp(){
  //   var rnd= new Random();
  //   for (var i = 0; i < 4; i++) {
  //     random_otp = random_otp + rnd.nextInt(9).toString();
  //   }
  //   print(random_otp);
  // }

/*  Future<void> onCreate(String random_otp) async {
    await notificationService.showNotification(
      0,
      "Your OTP is $random_otp",
      "Please use this OTP to validate your number and complete the signup",
      jsonEncode({
        "title":  "Your OTP is $random_otp",
        "eventDate": DateFormat("EEEE, d MMM y").format( DateTime.now()),
        "eventTime": TimeOfDay.now().format(context),
      }),
    );

  }*/




  /*Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/

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


    registerCubit = RegisterCubit(UserRegRepository());
    getDeviceIdentifier();
   // randomotp();

   //securescreen();

    image1 = Image.asset("assets/images/registrationbg.png");
    image2 = Image.asset("assets/images/vlogonew.png", fit: BoxFit.contain,);
    image3 = Image.asset("assets/images/vbook_text.png",fit: BoxFit.contain,);
   // image4= Image.asset("assets/images/reg_login_bg_landscape.png");


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
    Username_Controller.dispose();
    mobilenumber_Controller.dispose();
    activation_key_Controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body:  BlocProvider(
            create: (context) => registerCubit,
            child: BlocListener<RegisterCubit, RegisterState>(
              bloc: registerCubit,
              listener: (context, state) {
                if (state is RegistrationLoading) {}
                if (state is RegistrationLoginSuccessFull) {


                  setState(() {
                    _isloading=false;
                  });


           /*       Fluttertoast.showToast(
                      msg: "Registration Successfully!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);*/


                 // onCreate(state.otp.toString());

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





          /*        Navigator.pushReplacement(
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
                  );*/




                }
                else if (state is RegistrationFailed) {

                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);

                  setState(() {
                    _isloading=false;
                  });
                }
              },
              child: BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return Form(key: _key, child:    registrationform());
                  }),
            )),
      ),
    );
  }





  Widget registrationform() {
    return /* MediaQuery.of(context).orientation == Orientation.portrait ?*/
    SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
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
              padding:  const EdgeInsets.only(left: 32),
              child: Row(
                children:  [
                  Text("Register",style: TextStyle(color: Colors.black, fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 25.sp,fontFamily: "SeoulHangang",fontWeight: FontWeight.w500,),),
                  // VblText(
                  //   text: "Register",
                  //   fontColor: Colors.black,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 25.sp,
                  // ),
                ],
              ),
            ),

            Padding(
              padding:  const EdgeInsets.only(left: 32,top: 7),
              child: Row(
                children: [
                  VbText(
                    text: "Please sign up to continue.",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 18.sp,
                  ),
                ],
              ),
            ),

            ///User name Text field
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
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
              margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: TextFormField(
                keyboardType: TextInputType.text,
                //autofocus: true,
                //enableInteractiveSelection:  true,
                controller: Username_Controller,
                // onChanged: (value) {
                //  setState(() {
                //    _username = value;
                //  });
                // },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'User Name',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
                  filled: true,
                  fillColor: HexColor("#FFFFFF"),
                  contentPadding: const EdgeInsets.only(
                      left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF")),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF")),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ///Mobile number Text field
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
              margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
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
                  contentPadding:  const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
            ///Ativation Key Text field
          /*  Container(
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
              margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: TextFormField(
                inputFormatters:  [
                  LengthLimitingTextInputFormatter(23),
                ],
                keyboardType: TextInputType.number,
                //autofocus: true,
                //enableInteractiveSelection:  true,
                controller: activation_key_Controller,
                // onChanged: (value) {
                // setState(() {
                //   _activationKey = value;
                // });
                // },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(

                  border: InputBorder.none,
                  hintText: 'Activation Key',
                  hintStyle:  const TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
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
            ),*/

            ///Register button
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
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                        MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () async{


                        if(Username_Controller.text.isEmpty){

                          Utils.showDialouge(
                              context, AlertType.error, "Oops!", "Please fill your name field");

                        }
                        else if(mobilenumber_Controller.text.isEmpty){

                          Utils.showDialouge(
                              context, AlertType.error, "Oops!", "Please fill your mobile number field");

                        }
                       /* else if(activation_key_Controller.text.isEmpty){

                          Utils.showDialouge(
                              context, AlertType.error, "Oops!", "Please fill your activation key field");

                        }*/
                        else
                        {

                          bool result = await SimpleConnectionChecker.isConnectedToInternet();
                          if (result == true) {

                            setState(() {
                              _isloading=true;
                            });

                            Register();

                          } else {

                            setState(() {
                              _isloading=false;
                            });

                            CustomSnackBar.showSnackBar(context,"No Internet connection");
                          }

                        }

                      },
                      child: Padding(
                        padding:  const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 25,right: 25
                        ),
                        child:

                        _isloading==true?  const Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),):

                        VbText(
                          text: "Register",
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
                  text: "Already have an account?",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: Device.screenType == ScreenType.tablet ? 13.5.sp : 15.5.sp,
                ),
                GestureDetector(
                    child: VbText(
                      text: " Sign in",
                      fontColor: HexColor("#000000"),
                      fontWeight: FontWeight.w700,
                      fontSize: Device.screenType == ScreenType.tablet ? 14.sp : 16.sp,
                      dec: TextDecoration.underline,

                    ),
                    onTap: () {

                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>
                          const  LoginscreenPage(),
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

/*        :

    SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image4.image,
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          //physics: BouncingScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          shrinkWrap: true,
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),


            Container(
              width: MediaQuery.of(context).size.width - 100,
              height:  MediaQuery.of(context).size.width * 0.1,
              padding:  EdgeInsets.only(left: 50,right: 50),
              child: image2,
            ),



            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),


            Padding(
              padding:  EdgeInsets.only(left: 32),
              child: Row(
                children:  [
                  VblText(
                    text: "Register",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 24.sp,
                  ),
                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.only(left: 32,top: 7),
              child: Row(
                children: [
                  VblText(
                    text: "Please sign up to continue.",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 18.sp,
                  ),
                ],
              ),
            ),

            ///User name Text field
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
                keyboardType: TextInputType.text,
                //autofocus: true,
                //enableInteractiveSelection:  true,
                controller: Username_Controller,
                // onChanged: (value) {
                //  setState(() {
                //    _username = value;
                //  });
                // },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'User Name',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
                  filled: true,
                  fillColor: HexColor("#FFFFFF"),
                  contentPadding: EdgeInsets.only(
                      left: 14.0, bottom: 6.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF")),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: HexColor("#FFFFFF")),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ///Mobile number Text field
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
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
                  filled: true,
                  fillColor: HexColor("#FFFFFF"),
                  contentPadding:  EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
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
            ///Ativation Key Text field
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
                inputFormatters:  [
                  LengthLimitingTextInputFormatter(23),
                ],
                keyboardType: TextInputType.number,
                //autofocus: true,
                //enableInteractiveSelection:  true,
                controller: activation_key_Controller,
                // onChanged: (value) {
                // setState(() {
                //   _activationKey = value;
                // });
                // },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(

                  border: InputBorder.none,
                  hintText: 'Activation Key',
                  hintStyle:  TextStyle(color: Colors.grey, fontSize: 16,fontFamily: "Raleway"),
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

            ///Register button
            Padding(
              padding: EdgeInsets.only(top: 30),
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
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        // elevation: MaterialStateProperty.all(3),
                        shadowColor:
                        MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {


                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (c, a1, a2) =>
                            const  LoginscreenPage(),
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
                        padding:  EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 25,right: 25
                        ),
                        child:

                        _isloading?  Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),):

                        VblText(
                          text: "Register",
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
                  text: "Already have an account?",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: Device.screenType == ScreenType.tablet ? 13.5.sp : 15.5.sp,
                ),
                GestureDetector(
                    child: VblText(
                      text: " Sign in",
                      fontColor: HexColor("#d92008"),
                      fontWeight: FontWeight.w600,
                      fontSize: Device.screenType == ScreenType.tablet ? 14.sp : 16.sp,
                    ),
                    onTap: () {

                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) =>
                          const  LoginscreenPage(),
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

            //Expanded(child: SizedBox()),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),



            // Container(
            //   width: MediaQuery.of(context).size.width - 100,
            //   height: MediaQuery.of(context).size.height * 0.04,
            //   child: image3,
            // ),
            //
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.05,
            // )

          ],
        ),
      ),
    )
    ;*/

  }

  void Register() {
        registerCubit.authenticateUser(
          Username_Controller.text,
          mobilenumber_Controller.text,
          device_id.toString(),
          model_id.toString(),
        );
  }



}
