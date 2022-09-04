import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prashna_app/utilities/api.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:prashna_app/constants.dart';

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

  static const themeStatus = "THEMESTATUS";

  setDarkTheme(bool value) async {
    final SharedPreferences localStorage = await _localStorage;
    localStorage.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    final SharedPreferences localStorage = await _localStorage;
    return localStorage.getBool(themeStatus) ?? false;
  }
}

Future<bool> onFollowCourse(
    BuildContext context, bool isLiked, int courseID) async {
  final messenger = ScaffoldMessenger.of(context);
  final currTheme = Provider.of<Auth>(context, listen: false);
  messenger.removeCurrentSnackBar();
  final SharedPreferences storage = await SharedPreferences.getInstance();
  final String? token = storage.getString('token');
  if (!isLiked) {
    Response response = await dio().post("/user/courses",
        data: {"course_id": courseID, "prashna": true},
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    messenger.showSnackBar(SnackBar(
        content:
            Text(response.data, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 1)));
  } else {
    Response response = await dio().delete("/user/courses/$courseID",
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    messenger.showSnackBar(SnackBar(
        content: Text(
          response.data,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 1)));
  }
  currTheme.refreshUser();
  return !isLiked;
}

Future<bool> onFollow(
    BuildContext context, bool isLiked, int categoryID) async {
  final messenger = ScaffoldMessenger.of(context);
  final currTheme = Provider.of<Auth>(context, listen: false);
  messenger.removeCurrentSnackBar();
  final SharedPreferences storage = await SharedPreferences.getInstance();
  final String? token = storage.getString('token');
  if (!isLiked) {
    Response response = await dio().post("/user/categories",
        data: {"category_id": categoryID, "prashna": true},
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    messenger.showSnackBar(SnackBar(
        content:
            Text(response.data, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 1)));
  } else {
    Response response = await dio().delete("/user/categories/$categoryID",
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    messenger.showSnackBar(SnackBar(
        content: Text(
          response.data,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 1)));
  }
  currTheme.refreshUser();
  return !isLiked;
}

Future<bool> onFollowSet(BuildContext context, bool isLiked, int setID) async {
  final messenger = ScaffoldMessenger.of(context);
  final currTheme = Provider.of<Auth>(context, listen: false);
  messenger.removeCurrentSnackBar();
  final SharedPreferences storage = await SharedPreferences.getInstance();
  final String? token = storage.getString('token');
  if (!isLiked) {
    Response response = await dio().post("/user/followedSets",
        data: {"set_id": setID},
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    messenger.showSnackBar(SnackBar(
        content:
            Text(response.data, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[400],
        duration: const Duration(seconds: 1)));
  } else {
    Response response = await dio().delete("/user/followedSets/$setID",
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    messenger.showSnackBar(SnackBar(
        content: Text(
          response.data,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 1)));
  }
  currTheme.refreshUser();
  return !isLiked;
}
