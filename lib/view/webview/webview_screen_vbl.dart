import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/const/snackbar_const.dart';
import '../scan/scan_screen_vbl.dart';

class WebviewPage extends StatefulWidget {

  final String? plaintextoutput;

  const WebviewPage({Key? key,this.plaintextoutput}) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {

  bool? _isLoading = true;
  //bool? _disableBackButton = false;
  // bool _enableBottomNav = false;
  late WebViewController _webViewController;

  final Completer<WebViewController> _controller = Completer<WebViewController>();


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
    checkInternetConnection();

   //securescreen();
  }


/* Future getFuture1() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => PaymentSuccessPage(
            resId: widget.restaurantId,
            icon: Icons.check,
            color: Colors.green,
            message: AppLocalizations.of(context).translate('ts'),
          ),
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
    });
  }


Future getFuture2() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) =>   PaymentFailurePage(
            rest_id: widget.restaurantId,
            icon: Icons.cancel,
            color: Colors.red,
            message: AppLocalizations.of(context).translate('pf'),
          ),
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
    });
  }*/


  @override
  void dispose() {
    _webViewController;
    _controller;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var weburl = Uri.parse("${widget.plaintextoutput}");
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => OnWillPopCallback.onWillPop(context),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const VbText(
              text:"Web View Page",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontColor: Colors.black,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.push(
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
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  initialUrl: weburl.toString(), //website's link
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _webViewController = webViewController;
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (String url) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onProgress: (int progress) {
                    print("Scanner app WebView is loading (progress : $progress%)");
                    //header remove
                    _webViewController.runJavascript(
                      "javascript:(function() { var header = document.getElementsByTagName('header')[0];header.parentNode.removeChild(header);})()",
                    ).then(
                            (value) => debugPrint('Page finished loading Javascript'))
                        .catchError(
                          (onError) => debugPrint('$onError'),
                    );
                    //footer remove
                    _webViewController.runJavascript(
                      "javascript:(function() { var footer = document.getElementsByTagName('footer')[0];footer.parentNode.removeChild(footer);})()",
                    ).then(
                            (value) => debugPrint('Page finished loading Javascript'))
                        .catchError(
                          (onError) => debugPrint('$onError'),
                    );
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      _isLoading = false;

                    });
                    print('Page finished loading : $url');
                  },

                  gestureNavigationEnabled: true,
                ),
              ),
              // loading widget that show when enters to the webview
              if (_isLoading!) Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Colors.white,),
                        height: 40,
                        width: 40,

                        child: const CupertinoActivityIndicator()),
                    const SizedBox(
                      height: 10.0,
                    ),

                     const Text('Loading...'),
                    // CheersClubText(
                    //   text: AppLocalizations.of(context).translate(''),fontColor: Colors.black,
                    //   fontSize: 15,
                    // ),

                  ],
                ),
              ) else Container(),
            ],
          ),
        ),
      ),
    );
  }
}





/*


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:migsoftOOS/config/text_style.dart';
import 'package:migsoftOOS/config/constants.dart';
import 'package:migsoftOOS/helper/common_ui_elements.dart';
import 'package:migsoftOOS/helper/local_storage.dart';
import 'package:migsoftOOS/network/migsoftAPI.dart';
import 'package:migsoftOOS/screens/myorder/myorder_view.dart';
import 'package:migsoftOOS/tools/general.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Payment extends StatefulWidget {
  final String url;
  final String shopId;
  Payment({this.url, this.shopId});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  OrderTypeClass _instance = OrderTypeClass();

  bool _isLoading = true;
  bool disableBackButton = false;
  bool enablebottomButton = false;
  @override
  void initState() {
    super.initState();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<void> delayedNavigation() async {
    await Future.delayed(Duration(seconds: 10));
    print('Delayed completion navigation called');
    //write backbutton press navigation here.
    await Pref().removeAllCart(
      widget.shopId,
      _instance.orderType,
    );
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    await Navigator.pushReplacement(
      context,
      // PageTransition(
      //   type: PageTransitionType.leftToRight,
      //   child: MyOrderView(),
      // ),
      MaterialPageRoute(
          settings: const RouteSettings(name: ' MyOrder Screen'),
          builder: (context) => MyOrderView()),
    );
  }

  Future<void> timer() async {
    await Future.delayed(Duration(seconds: 30));

    setState(() {
      disableBackButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (!disableBackButton) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              title: Text('Payment', style: appTitleStyleBoldLarge),
              leading: disableBackButton
                  ? SizedBox()
                  : IconButton(
                icon: new Icon(Icons.arrow_back_ios, color: kTextColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            extendBodyBehindAppBar: false,
            body: Stack(
              children: [
                WebView(
                    initialUrl: widget.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onPageStarted: (String url) {
                      setState(() {
                        _isLoading = true;
                      });
                    },
                    onPageFinished: (String url) {
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    navigationDelegate: (NavigationRequest request) {


if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }


                      if (request.url
                          .contains('pos-request')) //('payment_completed'))
                          {
                        printLog(request.url);

                      }
                      if (request.url.contains('payment-completed'))

                        //('payment_completed'))
                          {
                        setState(() {
                          disableBackButton = true;
                          enablebottomButton = true;
                          // defaultSnackbar(context,
                          //     'Payment Completed, Redirecting Please wait....\nDo not press back button');
                        });
                        printLog(request.url);

                        delayedNavigation();
                        timer();
                        return NavigationDecision.navigate;
                      } else {
                        print('allowing navigation to $request');
                        return NavigationDecision.navigate;
                      }
                    },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    }),
                _isLoading
                    ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        // width: 30.0,
                        // height: 30.0,
                        child: SpinKitFadingCircle(
                          color: spinnerColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Please wait while we process your request."),
                      Text("Do not press back button."),
                    ],
                  ),
                )
                    : Container(),
              ],
            ),
            bottomNavigationBar: enablebottomButton
                ? Padding(
              padding:
              const EdgeInsets.only(right: 8, bottom: 2, left: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await Pref().removeAllCart(
                    widget.shopId,
                    _instance.orderType,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await Navigator.pushReplacement(
                    context,
                    // PageTransition(
                    //   type: PageTransitionType.leftToRight,
                    //   child: MyOrderView(),
                    // ),
                    MaterialPageRoute(
                        settings:
                        const RouteSettings(name: ' MyOrder Screen'),
                        builder: (context) => MyOrderView()),
                  );
                },
                child: Text(
                  'View Orders',
                  style: buttonStyleSmall,
                ),
                style: ElevatedButton.styleFrom(
                  // shape: CircleBorder(),
                  primary: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(15),
                ),
              ),
            )
                : SizedBox()));
  }
}*/
