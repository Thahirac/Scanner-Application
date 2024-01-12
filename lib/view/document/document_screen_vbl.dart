import 'dart:async';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/const/snackbar_const.dart';
import '../scan/scan_screen_vbl.dart';



class PDFScreen extends StatefulWidget {
  final String? urlpath;

  PDFScreen({Key? key, this.urlpath}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {

  late PDFDocument document;
  double screenHeight = 0, screenWidth = 0;
  bool showPDF = false;



  /*Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/


  Future<void> checkInternetConnection() async {
    bool result = await SimpleConnectionChecker.isConnectedToInternet();
    if (result == true) {
    } else {


      CustomSnackBar.showSnackBar(context,"No Internet connection");


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

    }
  }

  @override
  void initState() {
    super.initState();
    print( widget.urlpath.toString());
    //securescreen();
    checkInternetConnection();
    loadPDF();
  }


  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const VbText(
              text:"Pdf View Page",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontColor: Colors.black,
            ),
            leading: IconButton(
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
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
          body: Stack(
            children: [
              showPDF
                  ? PDFViewer(
                lazyLoad: false,
                document: document,
                scrollDirection: Axis.vertical,
                indicatorBackground: Colors.white,
                indicatorText: Colors.grey.shade800,
                showPicker: false,
                showNavigation: false,
                indicatorPosition: IndicatorPosition.topLeft,
                progressIndicator: CupertinoActivityIndicator(color: Colors.black,radius: 10,),

              )
                  : Center(
                child: CupertinoActivityIndicator(color: Colors.black,radius: 10,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadPDF() {
    PDFDocument.fromURL("${widget.urlpath}",
    ).then((value) {
      // print("widget.urlIs");
      // print(widget.urlIs);
      document = value;
      showPDF = true;
      setState(() {
        showPDF;
      });
    });
  }

}






