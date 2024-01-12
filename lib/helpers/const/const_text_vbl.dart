import 'package:flutter/material.dart';

class VbText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? fontColor;
  final TextAlign alignment;
  final String font;
  final TextOverflow? over;
  final double? maxlines;
  final TextDecoration? dec;
  const VbText(
      {Key? key,
        this.text,
        this.fontSize,
        this.fontWeight = FontWeight.normal,
        this.fontColor,
        this.alignment = TextAlign.center,
        this.font = "Raleway",
        this.over,
        this.maxlines,
        this.dec,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
          color: fontColor,
          fontWeight: fontWeight,
          fontFamily: font,
          fontSize: fontSize,
        decoration: dec
      ),
      textAlign: alignment,
      overflow: over,
    );
  }
}