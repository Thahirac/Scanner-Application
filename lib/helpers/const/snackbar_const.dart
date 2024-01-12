import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 6.0,
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.black,
      content: Row(
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          SizedBox(width: 8,),
          Text(message,style: TextStyle(fontFamily: "Raleway",fontSize: 12),),
        ],
      ),

/*      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // You can add custom code to handle the action button.
          // For example, to dismiss the SnackBar.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),*/
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


/*        var snackBar = const SnackBar(
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,

            content: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 8,),
                Text("No Internet Connection",style: TextStyle(fontFamily: "Raleway"),),
              ],
            ),
            // the duration of your snack-bar
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.black
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/