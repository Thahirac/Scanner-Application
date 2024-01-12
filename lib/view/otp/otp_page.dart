import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
//flutter_windowmanager: ^0.2.0
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../cubit/auth/otp/otp_cubit.dart';
import '../../helpers/const/const_api_alert_vbl.dart';
import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/const/const_utils_vbl.dart';
import '../../helpers/const/snackbar_const.dart';
import '../../helpers/managers/user_manager.dart';
import '../../helpers/repository/otp_repository.dart';
import '../../services/notification_service.dart';
import '../scan/scan_screen_vbl.dart';
//import 'package:http/http.dart' as http;

class RoundedWithCustomCursor extends StatefulWidget {
  String? otp;
 final String? phone_number;
 final String? device_id;
 final String? model_id;


  RoundedWithCustomCursor({Key? key,this.otp,this.phone_number,this.device_id,this.model_id}) : super(key: key);

  @override
  _RoundedWithCustomCursorState createState() => _RoundedWithCustomCursorState();

  @override
  String toStringShort() => 'Rounded With Cursor';
}

class _RoundedWithCustomCursorState extends State<RoundedWithCustomCursor> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  late OtpCubit otpCubit;
  bool _isloading=false;
  String? id;


  int delaytime = 1;
  double progressFraction = 0.0;
  int percentage = 0;
  int totalSecs = 90;
  String countDownText = "01:30";
  int countDownSeconds = 90;
  bool stopCounting = false;



  //NotificationService notificationService = NotificationService();


/*  Future<void> onCreate() async {
    await notificationService.showNotification(
      0,
      "Your OTP is ${widget.otp}",
      "Please use this OTP to validate your number and complete the signup",
      jsonEncode({
        "title":"Your OTP is ${widget.phone_number}",
        "eventDate": DateFormat("EEEE, d MMM y").format( DateTime.now()),
        "eventTime": TimeOfDay.now().format(context),
      }),
    );

  }*/

  void startCountDown() {
    if (!stopCounting) {
      Future.delayed( Duration(seconds: delaytime)).then((value) {
        startCountDown();
        countDownSeconds -= 1;

        if (countDownSeconds == 0) {

          stopCounting = true;
          if(mounted){
            setState(() {
              countDownSeconds;
            });
          }

        }
        countDownText = '${(Duration(seconds: countDownSeconds))}'.split('.')[0].padLeft(8, '0').substring(3,);
        if(mounted){
          setState(() {
            countDownText;
            countDownSeconds -= 1;
            progressFraction = (totalSecs - countDownSeconds) / totalSecs;
            percentage = (progressFraction*100).floor();
          });
        }

      });
    }
  }

/*  Future<void> securescreen() async{

    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/

  screenOrientation(){
    if(Device.screenType == ScreenType.mobile){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,]);
    }
  }



  void gettoken() async {
    id = await UserManager.instance.getToken();
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^: $id");
  }


  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gettoken();

    startCountDown();

   // securescreen();

    screenOrientation();

    otpCubit = OtpCubit(UserOtpRepository());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocProvider(
              create: (context) => otpCubit,
              child: BlocListener<OtpCubit, OtpState>(
                bloc:  otpCubit,
                listener: (context, state) {
                  if (state is OtpLoading) {}
                  if (state is OtpLoginSuccessFull) {


                    setState(() {
                      _isloading=false;
                    });


                    Fluttertoast.showToast(
                        msg: state.msge,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);

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



                  }
                  else if (state is OtpFailed) {

                    Utils.showDialouge(
                        context, AlertType.error, "Oops!", state.msg);

                    setState(() {
                      _isloading=false;
                    });
                  }
                  else if (state is ResendOtpLoading) {}
                  if (state is ResendOtpLoginSuccessFull){

                    widget.otp = state.otp;

                    setState(() {
                      countDownText = "01:30";
                      countDownSeconds = 90;
                      delaytime = 1;
                      stopCounting = false;
                      pinController.clear();
                    });

                    startCountDown();


                  }
                  else if (state is ResendOtpFailed){

                    Utils.showDialouge(
                        context, AlertType.error, "Oops!", state.msg);

                  }
                },
                child: BlocBuilder<OtpCubit, OtpState>(
                    builder: (context, state) {
                      return otppageOld();
                    }),
              )),
        ),
      ),
    );
  }



  Widget otppageOld(){
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle:  TextStyle(color: const Color.fromRGBO(30, 60, 87, 1), fontSize: 22,fontFamily: "Raleway"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: VbText(
              text: "Verification",
              fontColor: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: Device.screenType == ScreenType.mobile ? 23.sp : 25.sp,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: VbText(
              text: "Code has sent to",
              fontColor: Colors.grey.shade900,
              fontWeight: FontWeight.w400,
              fontSize: Device.screenType == ScreenType.mobile ? 18.sp : 19.sp,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: VbText(
              //text: "${widget.phone_number}",
              text: '${widget.phone_number??"8976545678"}',
              fontColor: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
              fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 17.sp,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50,left: 30,right: 30),
            child: Pinput(
              length: 6,
              controller: pinController,
              focusNode: focusNode,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                return value!.isEmpty ? "Please fill the fields" : value != widget.otp ? "Invalid Otp" : null;
              },
              errorTextStyle: TextStyle(fontFamily: "Raleway",color: Colors.redAccent.shade700,fontSize: 12),
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),


          (countDownSeconds > 0)? Padding(
            padding: const EdgeInsets.only(top: 30),
            child: VbText(
              text: countDownText,
              fontColor: Colors.green,
              fontSize: 18,
            ),
          ):
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VbText(
                  text: "Didn't received code?",
                  fontColor: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 17.sp,
                ),

                SizedBox(width: 5,),

                InkWell(
                  onTap: (){

                    ResendOtp();

                  },
                  child: VbText(
                    text: "resend",
                    fontColor: Color.fromRGBO(23, 171, 144, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.mobile ? 17.sp : 18.sp,
                    dec: TextDecoration.underline,
                  ),
                ),

              ],
            ),
          ),


          Padding(
            padding: EdgeInsets.only(top: 40),
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
                        HexColor("#201E79"), HexColor("#FF0000")
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


                      if(formKey.currentState!.validate()){


                        print("*****************************${widget.otp.toString()}");
                        print("*****************************${widget.phone_number.toString()}");
                        print("*****************************${widget.device_id.toString()}");
                        print("*****************************${widget.model_id.toString()}");

                        setState(() {
                          _isloading=false;
                        });


                        OtpVerification();


                      }


                    },
                    child: Padding(
                      padding:  EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 25,right: 25
                      ),
                      child:   _isloading?  Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),):
                      VbText(
                        text: "Verify",
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
      ),
    );
  }





  void OtpVerification() async{

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        otpCubit.otpauthenticateUser(
            pinController.text.toString(),
            widget.device_id.toString(),
            widget.model_id.toString(),
            widget.phone_number,
            id.toString()

        );

        //return true;
      } else {
        CustomSnackBar.showSnackBar(context,"No Internet connection");
        log("------------------------ No Internet --------------------------------");
        //return false;
      }
    } on SocketException
    catch (_) {
      CustomSnackBar.showSnackBar(context,"No Internet connection");
      //return false;
    }


  }


  void ResendOtp() async{

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        otpCubit.resentOtp(
            id.toString(),
            widget.phone_number
        );

        //return true;
      } else {
        CustomSnackBar.showSnackBar(context,"No Internet connection");
        log("------------------------ No Internet --------------------------------");
        //return false;
      }
    } on SocketException
    catch (_) {
      CustomSnackBar.showSnackBar(context,"No Internet connection");
      //return false;
    }


  }








/*  Widget otppage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: VbText(
            text: "Verification",
            fontColor: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: Device.screenType == ScreenType.mobile ? 23.sp : 25.sp,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: VbText(
            text: "Code has sent to",
            fontColor: Colors.grey.shade900,
            fontWeight: FontWeight.w400,
            fontSize: Device.screenType == ScreenType.mobile ? 18.sp : 19.sp,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: VbText(
            //text: "${widget.phone_number}",
            text: '${widget.phone_number??" "}',
            fontColor: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
            fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 17.sp,
          ),
        ),


        SizedBox(height: 20),

        PhysicalModel(
          color: Colors.transparent,
          child: Icon(Icons.search_rounded,size: 140,),
          shadowColor: Colors.transparent,
          elevation: 15.0,
        ),

        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 30,right: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: LinearProgressIndicator(
              value: progressFraction,
              minHeight: 25,
              color: Colors.teal.shade400,
              backgroundColor: Colors.teal.shade100,
            ),
          ),
        ),


        (countDownSeconds > 0)?

        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: VbText(
            text: countDownText,
            fontColor: Colors.orange,
            fontSize: 18,
          ),
        )
            : Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(),
        ),


        *//*     :
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VbText(
                    text: "Didn't received code?",
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: Device.screenType == ScreenType.mobile ? 16.sp : 17.sp,
                  ),

                  SizedBox(width: 5,),

                  InkWell(
                    onTap: (){

                      // onCreate().then((value) =>
                      //     startCountDown(),
                      // );
                      //
                      // setState(() {
                      //   countDownText = "01:00";
                      //   countDownSeconds = 60;
                      //   stopCounting = false;
                      //   pinController.clear();
                      // });

                    },
                    child: VbText(
                      text: "resend",
                      fontColor: Color.fromRGBO(23, 171, 144, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: Device.screenType == ScreenType.mobile ? 17.sp : 18.sp,
                      dec: TextDecoration.underline,
                    ),
                  ),

                ],
              ),
            ),*//*


        SizedBox(height: 20),

        (countDownSeconds > 0)?  VbText(text: 'We are trying to detect code..',fontSize: 16,fontWeight: FontWeight.w400,fontColor: Colors.black,): Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VbText(text: 'Verified',fontSize: 16,fontWeight: FontWeight.w400,fontColor: Colors.black,),
            SizedBox(width: 5,),
            Icon(Icons.verified_rounded,color: Colors.green.shade800,size: 20,)
          ],
        ) ,


        (countDownSeconds > 0)? Container() : Padding(
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
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor:
                    MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {


                    *//*             if(formKey.currentState!.validate()){


                          print("*****************************${widget.otp.toString()}");
                          print("*****************************${widget.phone_number.toString()}");
                          print("*****************************${widget.device_id.toString()}");
                          print("*****************************${widget.model_id.toString()}");


                          OtpVerification();


                        }*//*


                    if(countDownSeconds < 0){

                      OtpVerification();

                    }



                  },
                  child: Padding(
                    padding:  EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 25,right: 25
                    ),
                    child:   _isloading?  Padding(padding: EdgeInsets.all(10.0), child: SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(strokeWidth: 1,color: Colors.white,)),) : VbText(
                      text: "Continue",
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
  }*/


}


/*
class Filled extends StatefulWidget {
  const Filled({Key? key}) : super(key: key);

  @override
  _FilledState createState() => _FilledState();

  @override
  String toStringShort() => 'Filled';
}

class _FilledState extends State<Filled> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
      decoration:
      const BoxDecoration(color: Color.fromRGBO(159, 132, 193, 0.8)),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 243,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Pinput(
              length: 4,
              controller: controller,
              focusNode: focusNode,
              separatorBuilder: (index) => Container(
                height: 64,
                width: 1,
                color: Colors.white,
              ),
              defaultPinTheme: defaultPinTheme,
              showCursor: true,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration:
                const BoxDecoration(color: Color.fromRGBO(124, 102, 152, 1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
