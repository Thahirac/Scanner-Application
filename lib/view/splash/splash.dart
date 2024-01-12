import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:vidwath_v_book/view/oneaccountonedevice/one_account_one_device.dart';

import '../../cubit/auth/authentication/auth_cubit.dart';
import '../../helpers/const/snackbar_const.dart';
import '../../helpers/networking/app_exception.dart';
import '../../helpers/repository/authentication_repository.dart';
import '../auth/login/login_screen_vbl.dart';
import '../auth/registration/registration_screen_vbl.dart';
import '../nointernet/no_internet_lsb.dart';
import '../scan/scan_screen_vbl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  final splashDelay = 3;
  late Image image1;
  late Image image2;
  late AuthenticationCubit authCubit;
  late  AuthenticationRepository authRepository;


  /*Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/


  screenOrientation(){
    if(Device.screenType == ScreenType.mobile){
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,]);
    }
  }


  Future<void> checkInternetConnection() async {
    bool result = await SimpleConnectionChecker.isConnectedToInternet();
    if (result == true) {

      String mobileNumber = await authRepository.getMobilenumber();
      String deviceId = await authRepository.getDeviceId();
      String modalId = await authRepository.getModalId();

      print('************ mobileNumber  ***********: $mobileNumber');
      print('************ deviceId ****************: $deviceId');
      print('************ modalId  ****************: $modalId');




      Timer(Duration(seconds: splashDelay), () async{

        if (mobileNumber.isEmpty  || deviceId.isEmpty || modalId.isEmpty || mobileNumber == "" || deviceId == "" || modalId == "" || mobileNumber == "null" || deviceId == "null" || modalId == "null") {


          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => RegistrationscreenPage(),
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


        } else {

          try {
            final result = await InternetAddress.lookup('example.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

              authCubit.getoneUseroneDevice(mobileNumber, deviceId,modalId);

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



      });

    } else {

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => ConnectionLostScreen(),
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

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkInternetConnection();
   //securescreen();
    screenOrientation();
    authCubit = AuthenticationCubit(AuthenticationIntial(), UserAuthenticationRepository());
    authRepository = UserAuthenticationRepository();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => authCubit,
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthentionSuccess) {
                return state.user == "Old Users"? ScanscreenPage(): OneAccountOneDeviceVB();
              } else if (state is AuthenticationFailed) {
                return state.msg == "Check user and device  Failed"? LoginscreenPage() : ConnectionLostScreen();
              } else {
                return splashscreenwidget();
              }
            }),
      ),
    );
  }

  Widget splashscreenwidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splashbg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            width: MediaQuery.of(context).size.width - 120,
            height:  MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(left: 50,right: 50),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height:100,
                    width:120,
            child: Image.asset("assets/images/vlogonew.png")),
                 Text("BOOK",style: TextStyle(color: HexColor("#065EA4"),fontSize: 45,fontWeight: FontWeight.w700,
                    shadows: <Shadow>[
                    Shadow(
                    offset: Offset(2.0, 2.0),
                  blurRadius: 2.0,
                  color: Colors.grey,
                ),
              ],
                ),),
                Container(
                  height:30,
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5.0), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(3, 3), // changes position of shadow
                    ),
                  ],),
                child:  Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 3,right: 3),
                    child: Text("Scan - Learn - Score",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 12,color: HexColor("#065EA4")),),
                  ),
                ),)


              ],
            )),


        ],
      ),
    );
  }
}
