import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vidwath_v_book/services/notification_service.dart';
import 'package:vidwath_v_book/view/splash/splash.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService notificationService = NotificationService();
  //await notificationService.init();
  //await notificationService.requestIOSPermissions();
  runApp(const MyApp());
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
    if(Platform.isAndroid){
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'V-BOOK',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home:  SplashScreen(),
          );
        }
    );
  }
}
