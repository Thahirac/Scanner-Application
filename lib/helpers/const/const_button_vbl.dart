// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class VbButton extends StatelessWidget {
  final Gradient? gradient;
  final double width;
  final double height;
  final Function? onPressed;
  final String? title;
  final Color? textColor;
  final double cornerRadius;
  const VbButton({
    Key? key,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
    this.title,
    this.textColor,
    this.cornerRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
          //gradient: gradient,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 2), blurRadius: 3.0)
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 1.0],
            colors: [
              HexColor("#201E79"),
              HexColor("#FF0000")
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius))),
      child: InkWell(
          onTap: onPressed as void Function()?,
          child: Center(
            child: Text(title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins Bold",
                )),
          )),
    );
  }
}