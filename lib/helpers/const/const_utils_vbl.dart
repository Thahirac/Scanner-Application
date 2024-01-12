import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'const_api_alert_vbl.dart';
class Utils {
  static showDialouge(
      BuildContext context, AlertType alertType, String title, String? message,
      {Function? okButtonCallBack,
        Function? cancelButtonCallBack,
        String okButtonText = "OK",
        String? cancelButtonText = null}) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return VbAlertView(
            color: Colors.white,
            alertType: alertType,
            message: message,
            title: title,
            cancelButtonCallBack: cancelButtonCallBack,
            okButtonCallBack: okButtonCallBack,
            cancelButtonText: cancelButtonText,
            okButtonText: okButtonText,
            alertContext: context,
          );
        });
  }

  static String getDateString(DateTime dateTime) {
    DateFormat format = DateFormat('dd-MM-yyyy');
    String formattedDate = format.format(dateTime);
    return formattedDate;
  }
}