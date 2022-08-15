import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants.dart';

String ordinalNum(int n) {
  if (n == 11 || n == 12 || n == 13) {
    return '${n}th';
  }
  if (n % 10 == 1) {
    return '${n}st';
  }
  if (n % 10 == 2) {
    return '${n}nd';
  }
  if (n % 10 == 3) {
    return '${n}rd';
  }
  return '${n}th';
}

SnackBar showLoadingSnackbar(String text) {
  return SnackBar(
    content: RichText(
        text: TextSpan(children: [
      WidgetSpan(
          child: ConstrainedBox(
              constraints: const BoxConstraints.expand(height: 15, width: 30),
              child: const SpinKitRing(
                color: PRIMARY_DARK,
                size: 15.0,
                lineWidth: 2.0,
              ))),
      TextSpan(text: " $text"),
    ])),
    backgroundColor: LIGHT_GREY,
    duration: const Duration(days: 1),
  );
}

Future<String> getDeviceModel() async {
  String deviceModel = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceModel = androidInfo.model;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceModel = iosInfo.utsname.machine;
  }

  return deviceModel;
}

class LocalStorage {
  static final Future<SharedPreferences> _localStorage =
      SharedPreferences.getInstance();

  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    final SharedPreferences localStorage = await _localStorage;
    localStorage.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    final SharedPreferences localStorage = await _localStorage;
    return localStorage.getBool(THEME_STATUS) ?? false;
  }
}
