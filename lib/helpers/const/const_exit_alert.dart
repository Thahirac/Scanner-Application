import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'const_text_vbl.dart';

class OnWillPopCallback {
  static Future<bool> onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: VbText(
          text: 'Are you sure',
          fontColor: HexColor("#fea500"),
          fontWeight: FontWeight.w800,
          alignment: TextAlign.left,
          fontSize: 18,
        ),
        content: const VbText(
          text: 'Do you want to exit the App?',
          fontColor: Colors.black,
          alignment: TextAlign.left,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const VbText(
              text: 'No',
              fontColor: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
           // onPressed: () {SystemNavigator.pop();},
            child: VbText(
              text: 'Yes',
              fontColor: Colors.indigo.shade600,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ) ?? false;
  }
}
