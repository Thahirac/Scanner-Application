import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:vidwath_v_book/view/video/widgets/landscape_controller_vbl.dart';

import '../../helpers/const/const_exit_alert.dart';
import '../../helpers/const/const_text_vbl.dart';
import '../../helpers/const/snackbar_const.dart';


class CustomVideoPlayerVidwath extends StatefulWidget {
 // var thisSetNewScreenFunc;
  String theVideoPath;

  CustomVideoPlayerVidwath(/*this.thisSetNewScreenFunc*/ this.theVideoPath,
      {Key? key})
      : super(key: key);

  @override
  _CustomVideoPlayerVidwathState createState() =>
      _CustomVideoPlayerVidwathState();
}

class _CustomVideoPlayerVidwathState extends State<CustomVideoPlayerVidwath> {


  void setWidgetToNewScreen(Widget newWidget,
      {bool addToQueue = true, bool changeAppBar = false}) {
    if (changeAppBar) {
      setState(() {
       // appBarTitle;
      });
    } else {
      //if (addToQueue) listOfWidgetForBack.add(newWidget);
     // checkInternetConnection();
     // DASHBOARDMAINWIDGET = newWidget;
      setState(() {
        // print("uotnauhoeatnhu45454545554444");
        //appBarTitle = "";
        //DASHBOARDMAINWIDGET;
        //listOfWidgetForBack;
      });
      // CHECK BEFORE LIVE
      //getNotificationCount();
    }
  }



  Future<void> checkInternetConnection() async {
    bool result = await SimpleConnectionChecker.isConnectedToInternet();
    if (result == true) {
    } else {
      CustomSnackBar.showSnackBar(context,"No Internet connection");
    }
  }



  /*Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }*/

  late FlickManager flickManager;
  late Orientation originalOrientation;
  bool showVideoUI = true;

  @override
  void initState() {
    checkInternetConnection();
    //checkForSubscription();

    print('${widget.theVideoPath}');

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network("${widget.theVideoPath}"),
    );


    //securescreen();
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  // void checkForSubscription() {
  //   String theVideoUrlTopPartIs = widget.theVideoPath;
  //   theVideoUrlTopPartIs = theVideoUrlTopPartIs.substring(
  //       0, theVideoUrlTopPartIs.lastIndexOf("/"));
  //
  //   if (!isThisUserSubscribed) {
  //     if (prefs.getStringList("subscriptionCheckPathList") == null) {
  //       prefs.setStringList(
  //           "subscriptionCheckPathList", [(theVideoUrlTopPartIs)]);
  //       showVideo();
  //     } else {
  //       List<String> subscriptionCheckPathList =
  //           prefs.getStringList("subscriptionCheckPathList")!;
  //       if (subscriptionCheckPathList.contains(theVideoUrlTopPartIs)) {
  //         Navigator.pop(context);
  //         Future.delayed(const Duration(seconds: 1), () {
  //           widget.thisSetNewScreenFunc(
  //               CheckSubscriptionViewPlansVLA(widget.thisSetNewScreenFunc));
  //         });
  //       } else {
  //         subscriptionCheckPathList.add(theVideoUrlTopPartIs);
  //         prefs.setStringList(
  //             "subscriptionCheckPathList", subscriptionCheckPathList);
  //         showVideo();
  //       }
  //     }
  //   } else if (isThisUserSubscribed) {
  //     showVideo();
  //   }
  // }

  Future<bool> onBackPressed() {
    if (originalOrientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]).then((value) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
        ]).then((value) {
          Navigator.pop(context);
        });
      });
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
      ]).then((value) {
        Navigator.pop(context);
      });
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    originalOrientation = MediaQuery.of(context).orientation;
    return WillPopScope(
      onWillPop: () => OnWillPopCallback.onWillPop(context),
      child: Scaffold(
        body: SafeArea(
          child: showVideoUI
              ? FlickVideoPlayer(
            flickManager: flickManager,
            preferredDeviceOrientation: const [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            preferredDeviceOrientationFullscreen: const [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
            systemUIOverlay: [],
            flickVideoWithControls: const FlickVideoWithControls(
              controls: LandscapePlayerControls(),
              videoFit: BoxFit.fitHeight,
            ),
          )
              : Container(
            child: const Center(
              child: Text("The video is not supported"),
              // child: TextCustomVidwath(
              //   textTCV: TR.please_wait[languageIndex],
              // ),
            ),
          ),
        ),
      ),
    );
  }

  void showVideo() {
    showVideoUI = true;
    setState(() {
      showVideoUI;
    });
  }
}





/*
/// Stateful widget to fetch and then display video content.

class VideoplayerPage extends StatefulWidget {

  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;


  const VideoplayerPage({Key? key,required this.videoPlayerController,required this.looping, required this.autoplay,}) : super(key: key);

  @override
  State<VideoplayerPage> createState() => _VideoplayerPageState();
}

class _VideoplayerPageState extends State<VideoplayerPage> {

  late ChewieController _chewieController;


  Future<void> securescreen() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }



  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child:  const Text('No'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
              _chewieController.pause();
              // <-- SEE HERE
    },
            child:  const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      // progressIndicatorDelay: Duration(seconds: 1),
      allowFullScreen: true,
      fullScreenByDefault: true,
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

    //securescreen();
  }


  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    widget.videoPlayerController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Video Player Page'),
          centerTitle: true,
          leading: IconButton(onPressed: (){
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) =>
                const ScanPage(),
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
            _chewieController.pause();
          },
            icon: Icon(Icons.arrow_back),

          ),
        ),
        body: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}



class VideoWidget extends StatefulWidget {

  String videoURL;

  VideoWidget({required this.videoURL});

  @override
  _VideoWidgetState createState() => _VideoWidgetState(videoURL: videoURL);
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Chewie _chewie;
  late ChewieController _chewieController;
  String videoURL;

  _VideoWidgetState({required this.videoURL});


  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      videoURL,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller.addListener(() {
      setState(() {

      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller.play();
    _controller.setLooping(false);
    _controller.initialize();
    _chewieController = ChewieController(
      fullScreenByDefault: true,
      videoPlayerController: _controller,
      autoPlay: true,
      looping: false,
    );
    _chewie = Chewie(
      controller: _chewieController,
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   title: const Text('Video Player Page'),
      //   centerTitle: true,
      //   leading: IconButton(onPressed: (){
      //     Navigator.push(
      //       context,
      //       PageRouteBuilder(
      //         pageBuilder: (c, a1, a2) =>
      //         const ScanPage(),
      //         transitionsBuilder:
      //             (context, animation, secondaryAnimation, child) {
      //           var begin = const Offset(1.0, 0.0);
      //           var end = Offset.zero;
      //           var tween = Tween(begin: begin, end: end);
      //           var offsetAnimation = animation.drive(tween);
      //           return SlideTransition(
      //             position: offsetAnimation,
      //             child: child,
      //           );
      //         },
      //         transitionDuration: const Duration(milliseconds: 300),
      //       ),
      //     );
      //     _chewieController.pause();
      //   },
      //     icon: Icon(Icons.arrow_back),
      //
      //   ),
      // ),
      body:Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Chewie(
            controller: _chewieController,
          ),
        )
            : const Center(
            child: SizedBox(
                height: 30.0,
                width: 30.0,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                    strokeWidth: 1.0))),
      ),
    );

  }
}
*/

