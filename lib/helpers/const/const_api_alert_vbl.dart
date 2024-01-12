// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'const_button_vbl.dart';
import 'const_text_vbl.dart';


class VbAlertView extends StatelessWidget {
  final AlertType? alertType;
  final String? cancelButtonText, okButtonText, message, title;
  final Function? okButtonCallBack, cancelButtonCallBack;
  final BuildContext? alertContext;
  final Color? color;
  const VbAlertView(
      {Key? key,
        this.alertType,
        this.cancelButtonText = null,
        this.okButtonText,
        this.message,
        this.title,
        this.okButtonCallBack,
        this.cancelButtonCallBack,
        this.alertContext,
        this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(border: Border.all(color: imageBgColor(),width: 2.5),shape: BoxShape.circle,),
                  child: Center(
                    child: imageName(),
                  )),
              const SizedBox(
                height: 15,
              ),
              VbText(
                text: title,
                fontColor: iconColor(),
                fontSize: Device.screenType == ScreenType.tablet ? 17.sp : 19.sp,
                fontWeight: FontWeight.bold,
              ),

              SizedBox(height: 14,),

              VbText(
                text: message,
                fontColor: Colors.black,
                fontSize: Device.screenType == ScreenType.tablet ? 12.sp : 15.sp,
              ),
              const SizedBox(
                height: 14,
              ),

              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (cancelButtonText != null)
                            Expanded(
                                child: VbButton(
                                    height: 40,
                                    title: cancelButtonText,
                                    onPressed: () {
                                      Navigator.pop(alertContext!);
                                      cancelButtonCallBack!();
                                    })),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: VbButton(
                                  cornerRadius:
                                  cancelButtonText != null ? 0 : 5,
                                  height: 40,
                                  title: okButtonText,
                                  onPressed: () {
                                    Navigator.pop(alertContext!);
                                    okButtonCallBack;
                                  }))
                        ],
                      )))
            ],
          ),
        ));
  }

  Icon? imageName() {
    Icon icon;
    switch (alertType!) {
      case AlertType.error:
        icon = Icon(
          Icons.close_rounded,
          color: HexColor("#FF0000"),
          size: 35,
        );
        break;
      case AlertType.success:
        icon = const Icon(
          Icons.check,
          color: Colors.green,
          size: 35,
        );
        break;
      case AlertType.warning:
        icon = Icon(
          Icons.warning_amber_rounded,
          color: HexColor("#fea500"),
          size: 35,
        );
        break;
    }
    return icon;
  }

  Color imageBgColor() {
    Color color;
    switch (alertType!) {
      case AlertType.error:
        color = HexColor("#FF0000");
        break;
      case AlertType.success:
        color = Colors.green;
        break;
      case AlertType.warning:
        color = HexColor("#fea500");
        break;
    }
    return color;
  }

  Color? iconColor() {
    Color color;
    switch (alertType!) {
      case AlertType.error:
        color = Colors.black;
        break;
      case AlertType.success:
        color = Colors.green;
        break;
      case AlertType.warning:
        color = Colors.black;
        break;
    }
    return color;
  }
}

enum AlertType {
  error,
  success,
  warning,
}