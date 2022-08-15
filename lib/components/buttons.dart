import 'package:flutter/material.dart';
import '../constants.dart';

Widget buildButton(BuildContext context, Color color, String label,
    TextStyle labelStyle, onPressed, Color btnPrimayColorOnLongPress,
    {double? width,
    double btnHeight = 50.0,
    double elevation = 0.0,
    bool disabled = false}) {
  return Container(
    color: color,
    width: width ?? MediaQuery.of(context).size.width,
    height: btnHeight,
    child: TextButton(
      style: TextButton.styleFrom(
        primary: PRIMARY_DARK,
        elevation: elevation,
        textStyle: const TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
      ),
      onPressed: disabled ? null : onPressed,
      child: Text(label, textAlign: TextAlign.center, style: labelStyle),
    ),
  );
}

Widget buildOutlinedButton(BuildContext context, String label,
    TextStyle labelStyle, onPressed, Color btnPrimayColorOnLongPress,
    {double borderWidth = 1,
    Color borderColor = PRIMARY_BLUE,
    BorderStyle borderStyle = BorderStyle.solid,
    double btnHeight = 50.0,
    bool disabled = false}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: btnHeight,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
          primary: btnPrimayColorOnLongPress,
          textStyle: const TextStyle(
              fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
            style: borderStyle,
          )),
      onPressed: disabled ? null : onPressed,
      child: Text(label,
          textAlign: TextAlign.center,
          style: labelStyle.copyWith(color: borderColor)),
    ),
  );
}
