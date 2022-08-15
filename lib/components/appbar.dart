import 'package:flutter/material.dart';
import '../constants.dart';

AppBar buildAppBar({String title = '', String subtitle = ''}) {
  TextStyle style = const TextStyle(fontSize: 12.0, color: Colors.white70);

  return AppBar(
    title: Column(children: [
      if (title.isNotEmpty)
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold)),
      if (subtitle.isNotEmpty)
        Text(
          subtitle,
          style: style,
        )
    ]),
    centerTitle: true,
    elevation: 1,
    backgroundColor: PRIMARY_BLUE,
  );
}
