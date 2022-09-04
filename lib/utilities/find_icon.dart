import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants.dart';

Widget findIcon(String iconData,
    {Color color = PRIMARY_BLUE, required double size}) {
  Widget icon;

  switch (iconData) {
    case "learn":
      icon = Icon(
        Icons.school_outlined,
        color: color,
        size: size,
      );
      break;
    case "flashcard":
      icon = Icon(Icons.style_outlined, color: color, size: size);
      break;
    case "write":
      icon = Icon(Icons.drive_file_rename_outline, color: color, size: size);
      break;
    case "match":
      icon = Icon(Icons.dashboard_outlined, color: color, size: size);
      break;
    case "test":
      icon = Icon(Icons.quiz_outlined, color: color, size: size);
      break;
    case "payment":
      icon = Icon(Icons.payment, color: color, size: size);
      break;
    case "payments":
      icon = Icon(Icons.payments, color: color, size: size);
      break;
    case "balance":
      icon = Icon(Icons.account_balance_wallet, color: color, size: size);
      break;
    case "paid":
      icon = Icon(Icons.account_balance, color: color, size: size);
      break;
    case "settings":
      icon = Icon(Icons.settings, color: color, size: size);
      break;
    case "redeem":
      icon = Icon(Icons.redeem, color: color, size: size);
      break;
    case "share":
      icon = Icon(Icons.share, color: color, size: size);
      break;
    case "logout":
      icon = Icon(Icons.logout, color: color, size: size);
      break;
    case "web":
      icon = Icon(Icons.web, color: color, size: size);
      break;
    case "facebook":
      icon = FaIcon(FontAwesomeIcons.facebook, color: color, size: size);
      break;
    case "twitter":
      icon = FaIcon(FontAwesomeIcons.twitter, color: color, size: size);
      break;
    case "instagram":
      icon = FaIcon(FontAwesomeIcons.instagram, color: color, size: size);
      break;
    case "youtube":
      icon = FaIcon(FontAwesomeIcons.youtube, color: color, size: size);
      break;
    case "help":
      icon = FaIcon(Icons.help, color: color, size: size);
      break;
    default:
      icon = Icon(Icons.radio_button_checked, color: color, size: size);
  }

  return icon;
}
