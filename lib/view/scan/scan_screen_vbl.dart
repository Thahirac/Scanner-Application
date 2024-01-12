// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:vidwath_v_book/helpers/repository/afterscan_repository.dart';

import '../../cubit/afterscan/afterscan_cubit.dart';
import '../../helpers/const/const_api_alert_vbl.dart';
import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/const/const_utils_vbl.dart';
import '../../helpers/const/drawerAfterlogin.dart';
import '../../helpers/const/snackbar_const.dart';
import '../../helpers/managers/shared_preference_manager.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert' as convert;
import '../document/document_screen_vbl.dart';
import '../invalidqr/invalid_qr_page_vbl.dart';
import '../video/video_player_screen_vbl.dart';
import '../webview/webview_screen_vbl.dart';
import 'package:http/http.dart' as http;

class ScanscreenPage extends StatefulWidget {
  const ScanscreenPage({Key? key}) : super(key: key);

  @override
  State<ScanscreenPage> createState() => _ScanscreenPageState();
}

class _ScanscreenPageState extends State<ScanscreenPage> {

  GlobalKey<ScaffoldState> _key = GlobalKey();
  late AfterscanCubit afterscanCubit;
  var contentPath;
  bool _isloading = false;
  late Image image1;
  late Image image2;
  late Image image3;
  String? userName, phoneNumber;
  String? id;
  var result = "";


  getUserserdata() async {
    String username = await SharedPreferenceManager.instance.getValueFor("is_userName");

    String? phonenumber = await SharedPreferenceManager.instance.getValueFor("mobile_number");

    String? userId = await SharedPreferenceManager.instance.getValueFor("id");

    setState(() {
      userName = username;
      phoneNumber = phonenumber;
      id = userId;
    });
  }

 /* Future<void> securescreen() async {
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

    screenOrientation();

    //securescreen();

    getUserserdata();

    afterscanCubit = AfterscanCubit(AfterscanIntial(),AfterScanRepository());

    image1 = Image.asset("assets/images/scanpagebg.png");
    image2 = Image.asset("assets/images/qrscan.png", height: 250,);
    image3 = Image.asset("assets/images/qrscan.png", height: 150,);

  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        drawer: DrowerAfterlogin(),
        key: _key,
        resizeToAvoidBottomInset: false,
        body: BlocProvider(
            create: (context) => afterscanCubit,
            child: BlocListener<AfterscanCubit, AfterscanState>(
              bloc: afterscanCubit,
              listener: (context, state) {
                if (state is AfterscanLoading) {}
                if (state is AfterscanSuccess) {

                  contentPath =state.contentPath;

                  setState(() {
                    _isloading=false;
                  });


                    if (contentPath.contains('.mp4')) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomVideoPlayerVidwath("https://vbook.b-cdn.net/$contentPath"),
                          ));
                    }  else {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (c, a1, a2) => PDFScreen(
                            urlpath: "https://vbook.b-cdn.net/$contentPath",
                          ),
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



                } else if (state is AfterscanFailed) {
                  Utils.showDialouge(
                      context, AlertType.error, "Oops!", state.msg);

                  setState(() {
                    _isloading=false;
                  });
                }
              },
              child: BlocBuilder<AfterscanCubit, AfterscanState>(
                  builder: (context, state) {
                    return scanscreenpage();
                  }),
            )
        ),
      ),
    );
  }

  Widget scanscreenpage() {
    return /*MediaQuery.of(context).orientation == Orientation.portrait ?*/

        Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image1.image,
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                  icon: SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset(
                        "assets/images/profileicon.png",
                        fit: BoxFit.contain,
                      )),
                ),

                /*     Icon(
                  Icons.account_circle_rounded,
                  size: Device.screenType == ScreenType.tablet ? 20.sp : 23.sp,
                  color: Colors.white.withOpacity(0.6),
                ),*/
                /*           Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.6),borderRadius: BorderRadius.circular(6.0)),
                  child: Center(
                    child: Icon(
                        Icons.bar_chart_rounded,
                        size: Device.screenType == ScreenType.tablet ? 20.sp : 23.sp,
                        color: Colors.grey
                    ),
                  ),
                ),*/

                /*   IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) =>
                        const  AnalyticsPage(),
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
                  icon:  SizedBox(
                    height: 25,
                      width: 25,
                      child: Image.asset("assets/images/charticon.png",fit: BoxFit.contain,)),
                ),*/
              ],
            ),
          ),

          /*    Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      VblText(
                        text: "Welcome, " + "Veda",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        alignment: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),*/

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Welcome, ',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "SeoulHangang",
                              fontSize: Device.screenType == ScreenType.tablet
                                  ? 16.sp
                                  : 17.sp,
                              fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            TextSpan(
                              text: userName ?? "Unknown",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "SeoulHangang",
                                  fontSize:
                                      Device.screenType == ScreenType.tablet
                                          ? 15.sp
                                          : 16.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: Device.screenType == ScreenType.tablet ||
                    Device.screenType == ScreenType.desktop
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).size.height * 0.27,
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: SizedBox(
              width: Device.screenType == ScreenType.tablet ||
                      Device.screenType == ScreenType.desktop
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width * 0.75,
              child: SingleChildScrollView(
                //physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    ///Scan QR Text
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Device.screenType == ScreenType.tablet
                            ? 18.sp
                            : 21.sp,
                        fontFamily: "SeoulHangang",
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    ///Scan gif
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 0),
                      child: image2,
                    ),

                    SizedBox(
                      height: Device.screenType == ScreenType.tablet ||
                              Device.screenType == ScreenType.desktop
                          ? MediaQuery.of(context).size.height * 0.02
                          : MediaQuery.of(context).size.height * 0.001,
                    ),

                    ///Scan button
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 60,
                        right: 60,
                        top: 10,
                      ),
                      child: Container(
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
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white54; //<-- SEE HERE
                                }
                                return null; // Defer to the widget's default.
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(200, 40)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () async{

                            try {
                              final result = await InternetAddress.lookup('example.com');
                              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

                                setState(() {
                                  _isloading = true;
                                });

                                scanQR();
                                //return true;
                              } else {
                                CustomSnackBar.showSnackBar(context,"No Internet connection");
                                //return false;
                              }
                            } on SocketException
                            catch (_) {
                              CustomSnackBar.showSnackBar(context,"No Internet connection");
                              //return false;
                            }

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: _isloading
                                ? const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: Colors.white,
                                        )),
                                  )
                                : const VbText(
                                    text: "Scan",
                                    fontColor: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SizedBox(
          //   height: Device.screenType == ScreenType.tablet || Device.screenType == ScreenType.desktop ? MediaQuery.of(context).size.height * 0.01 : MediaQuery.of(context).size.height * 0.01,
          // ),
        ],
      ),
    );

    /*   :
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image6.image,
          fit: BoxFit.fill,
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _key.currentState!.openDrawer();
                  },
                  icon: Icon(
                    Icons.account_circle_rounded,
                    size: Device.screenType == ScreenType.tablet ? 20.sp : 23.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),


          */ /*    Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      VblText(
                        text: "Welcome, " + "Veda",
                        fontColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        alignment: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),*/ /*


          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Welcome, ',
                          style: TextStyle(color: Colors.white,fontFamily: "Raleway",fontSize: Device.screenType == ScreenType.tablet ? 16.sp : 17.sp,fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                              text: userName??"Unknown",
                              style: TextStyle(color: Colors.white,fontFamily: "Raleway",fontSize: Device.screenType == ScreenType.tablet ? 15.sp : 16.sp,fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),

          Container(
            width: MediaQuery.of(context).size.width - 100,
            height:  MediaQuery.of(context).size.width * 0.1,
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: image2,
          ),

          SizedBox(
            height:MediaQuery.of(context).size.height * 0.05,
          ),

          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.38,right: MediaQuery.of(context).size.width * 0.38),
            child: Container(
              decoration: BoxDecoration(

                  color: Colors.white,
              borderRadius: BorderRadius.circular(20),
                  boxShadow: [ BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6.0,
                    spreadRadius: 2.0,
                  ),]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),



                  ///Scan QR Text
                  Text("Scan QR Code",style: TextStyle(color: Colors.black, fontSize: Device.screenType == ScreenType.tablet ? 22.sp : 25.sp,fontFamily: "SeoulHangang",fontWeight: FontWeight.w500,),),




                  ///Scan gif
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: image7,
                  ),


                  SizedBox(
                    height:  MediaQuery.of(context).size.height * 0.02 ,
                  ),

                  ///Scan button
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60, right: 60, top: 10,),
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
                          colors: [HexColor("#fea500"), HexColor("#e13b06")],
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          minimumSize:
                          MaterialStateProperty.all(Size(170, 40)),
                          backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                          // elevation: MaterialStateProperty.all(3),
                          shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          setState(() {
                            _isloading = true;
                          });

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: _isloading
                              ? const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: Colors.white,
                                )),
                          )
                              : const VblText(
                            text: "Scan",
                            fontColor: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),

                ],
              ),
            ),
          ),

          // SizedBox(
          //   height: Device.screenType == ScreenType.tablet || Device.screenType == ScreenType.desktop ? MediaQuery.of(context).size.height * 0.01 : MediaQuery.of(context).size.height * 0.01,
          // ),

          //Expanded(child: SizedBox()),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),

          // Container(
          //   width: MediaQuery.of(context).size.width - 100,
          //   height: MediaQuery.of(context).size.height * 0.04,
          //   child: image5,
          // ),
          //
          //
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.05,
          // )

        ],
      ),
    )


    ;*/
  }

  Future<void> scanQR() async {
    var res;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      res = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SimpleBarcodeScannerPage(
              isShowFlashIcon: true,
              lineColor: "#FF0000",
              scanType: ScanType.qr,
            ),
          ));

      setState(() {
          result = res;
      });

      if (result.isNotEmpty || result != "-1") {
        setState(() {
          _isloading = false;
        });

        print("##################1#########################$result");


        if(result.contains("http://") || result.contains("https://")){


            if(result.contains('.mp4') || result.contains('.m4v')) {

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomVideoPlayerVidwath(result),
                  ));

            }
            else if(result.contains('.pdf')){

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => PDFScreen(
                    urlpath: result,
                  ),
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

            } else{

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => WebviewPage(
                    plaintextoutput: result,
                  ),
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

        }else{

          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

          ///Decription function
          await decryption(result);

        }



      } else {
        setState(() {
          _isloading = false;
        });

        print("####################2#######################$result");


      }
    } catch (E) {
      log("Error on scanning function: $E");
      setState(() {
        _isloading = false;
      });
    }
  }

  Future<void> decryption(encryptedcode) async {
    String myKey = "Lekhak#\$RUSK&\$#SM@Rt_VIDW@Th\$2102";
    String myIv = 'Lekhak!SMARt';

    try {
      var iv = crypto.sha256
          .convert(convert.utf8.encode(myIv))
          .toString()
          .substring(0, 16); // Consider the first 16 bytes of all 64 bytes
      var key = crypto.sha256
          .convert(convert.utf8.encode(myKey))
          .toString()
          .substring(0, 32); // Consider the first 32 bytes of all 64 bytes
      encrypt.IV ivObj = encrypt.IV.fromUtf8(iv);
      encrypt.Key keyObj = encrypt.Key.fromUtf8(key);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(keyObj, mode: encrypt.AESMode.cbc)); // Apply CBC mode
      String firstBase64Decoding = String.fromCharCodes(
          convert.base64.decode(encryptedcode)); // First Base64 decoding
      final decrypted = encrypter.decrypt(
          encrypt.Encrypted.fromBase64(firstBase64Decoding),
          iv: ivObj); // Second Base64 decoding (during decryption)

      log("final decrypted result: $decrypted");


          afterscan(decrypted);

    } on FormatException catch (E) {

      log("Error on Scanning decrypt function: ${E.offset}");

      setState(() {
        _isloading = false;
      });

      if (E.offset == 2) {
        setState(() {
          _isloading = false;
        });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanscreenPage(),
            ));

      } else {
        setState(() {
          _isloading = false;
        });

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const InvalidQrPage(),
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
  }

  void afterscan(String filename) {

    try{

      afterscanCubit.afterscan(
          id.toString(),
          filename
      );

    } on TimeoutException{

      log("------------------------ TimeoutException --------------------------------");

      CustomSnackBar.showSnackBar(context,"No Internet connection");

    }on SocketException {



      CustomSnackBar.showSnackBar(context,"No Internet connection");

    } catch (e) {
      log('*********************Catch Error *******************************: $e');
    }


  }


}

/*
class QrScan extends StatefulWidget {
  const QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  bool _isloading=false;

 */ /* Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

      if (barcodeScanRes != null || barcodeScanRes!="-1") {
        decryption(barcodeScanRes);
      }else{
        setState(() {
          _isloading=false;
        });
      }
    } catch (E) {
      log("Error on scanning function: $E");
      setState(() {
        _isloading=false;
      });

    }
  }*/ /*

  Future<void> decryption(encryptedcode) async {
    String myKey = "muni";
    String myIv = 'muni123';
    try{
      var iv = crypto.sha256.convert(convert.utf8.encode(myIv)).toString().substring(0, 16); // Consider the first 16 bytes of all 64 bytes
      var key = crypto.sha256.convert(convert.utf8.encode(myKey)).toString().substring(0, 32); // Consider the first 32 bytes of all 64 bytes
      encrypt.IV ivObj = encrypt.IV.fromUtf8(iv);
      encrypt.Key keyObj = encrypt.Key.fromUtf8(key);
      final encrypter = encrypt.Encrypter(encrypt.AES(keyObj, mode: encrypt.AESMode.cbc)); // Apply CBC mode
      String firstBase64Decoding = String.fromCharCodes(convert.base64.decode(encryptedcode)); // First Base64 decoding
      final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(firstBase64Decoding), iv: ivObj); // Second Base64 decoding (during decryption)
      log("final $decrypted");
      if (decrypted != null) {

        if(decrypted.contains('.mp4') || decrypted.contains('.m4v')) {

          // Navigator.push(
          //   context,
          //   PageRouteBuilder(
          //     pageBuilder: (c, a1, a2) =>
          //         CustomVideoPlayerVidwath(decrypted),
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) {
          //       var begin = const Offset(1.0, 0.0);
          //       var end = Offset.zero;
          //       var tween = Tween(begin: begin, end: end);
          //       var offsetAnimation = animation.drive(tween);
          //       return SlideTransition(
          //         position: offsetAnimation,
          //         child: child,
          //       );
          //     },
          //     transitionDuration: const Duration(milliseconds: 100),
          //   ),
          // );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  CustomVideoPlayerVidwath(decrypted)),
          );

        }
        else if(decrypted.contains('.pdf')){

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) =>
                  PdfViewerPage(plaintextoutput: decrypted),
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
        else if(decrypted.contains('.html')) {

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => WebviewPage(
                plaintextoutput: decrypted,
              ),
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
        else{

          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => InvalidQrPage(),
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
      else{

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => InvalidQrPage(),
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
    }catch(E){
      log("Error on Scanning decrypt function: $E");

    }
  }


  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Stack(
            children: [
              QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderRadius: 10, borderWidth: 5, borderColor: Colors.blue,
              ),
            ),


              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      icon: FutureBuilder(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          return snapshot.data==null || snapshot.data==false? Icon(Icons.flash_off,color: Colors.white,size: 28,):

                          Icon(Icons.flash_on,color: Colors.white,size: 28,);

                        },
                      )),
                ),
              ),

              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  onPressed: (){

                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => ScanscreenPage(),
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
                  icon: Icon(Icons.close,size: 25,color: Colors.white,),
                )
              ),


          ]
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });


      if(result != null){

        decryption(result?.code).then((value) => controller.resumeCamera());

        log('*************Result Code**************${result?.code}');
      }else
        {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => InvalidQrPage(),
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

          log('*************Result Code Null**************${result?.code}');

        }


    });
  }





  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}*/





