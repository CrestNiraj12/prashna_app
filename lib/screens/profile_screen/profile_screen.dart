import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prashna_app/screens/login_screen/login_screen.dart';
import '../../constants.dart';
import '../../screens/policy_screen/privacy_policy.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();
  late TextEditingController textController;
  late String? token;
  Map data = {"name": ""};

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    loadToken();
  }

  void loadToken() async {
    final nav = Navigator.of(context);
    final SharedPreferences storage = await _storage;
    token = storage.getString('token');

    if (token == null) {
      nav.pushReplacement(PageTransition(
          child: const LoginScreen(), type: PageTransitionType.fade));
    }
  }

  // snackBar Widget
  snackBar(String message, {Color bgColor = PRIMARY_DARK}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: bgColor,
      ),
    );
  }

  Future getImage(ImageSource source, {required BuildContext context}) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final provider = Provider.of<Auth>(context, listen: false);
    try {
      provider.absorbing = true;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final pickedFile = await _picker.pickImage(
        source: source,
      );

      if (pickedFile != null) {
        scaffoldMessenger.showSnackBar(showLoadingSnackbar("Uploading image"));
        Response response = await dio().post('/user/avatar',
            data: {'avatar': base64Encode(await pickedFile.readAsBytes())},
            options: Options(headers: {'Authorization': 'Bearer $token'}));
        await provider.refreshUser();
        provider.absorbing = false;
        snackBar(response.data, bgColor: Colors.green);
      } else {
        provider.absorbing = false;
        scaffoldMessenger.removeCurrentSnackBar();
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.response);
      }
      Provider.of<Auth>(context, listen: false).absorbing = false;
      snackBar(
          e.response!.data['errors']['image'][0] ??
              "Error while uploading image!",
          bgColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);
    final user = currTheme.user;

    TextStyle style = TextStyle(
        fontSize: 16.0,
        color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    Future<void> _editProfileDialog() async {
      setState(() {
        data["name"] = user!.name;
      });

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
            title: Text(
              'Name',
              style: style.copyWith(color: PRIMARY_BLUE),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: TextEditingController()..text = user!.name,
                    onChanged: (text) {
                      setState(() {
                        data["name"] = text;
                      });
                    },
                    style:
                        const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel', style: style.copyWith(fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                child: Text(
                  'Update',
                  style: style.copyWith(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {
                  dio()
                      .post("/user/details",
                          data: data,
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}))
                      .then((value) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(10),
                          title: Text(
                            "Successfully updated your profile!",
                            style: style.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Roboto'),
                          ),
                          backgroundColor: Colors.green,
                        );
                      },
                    ).then((value) {
                      currTheme.refreshUser();
                    }).catchError((error) {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(10),
                          title: Text(
                            error.response.data["errors"]["name"][0],
                            style: style.copyWith(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                        );
                      },
                    ).then((value) {
                      currTheme.refreshUser();
                    }).catchError((error) {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _feedbackDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
            title: Text(
              'Please provide some feedback for the app',
              style: style.copyWith(color: PRIMARY_BLUE),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: textController,
                    minLines: 5,
                    maxLines: null,
                    style:
                        const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        hintText: "Message"),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel', style: style.copyWith(fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                child: Text(
                  'Send Feedback',
                  style: style.copyWith(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {
                  dio()
                      .post("/user/feedback",
                          data: {
                            "message": textController.text,
                            "user_id": user!.id
                          },
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}))
                      .then((value) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(10),
                          title: Text(
                            "Thank you for your feedback!",
                            style: style.copyWith(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: Colors.green,
                        );
                      },
                    ).then((value) {
                      textController.clear();
                    }).catchError((error) {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    }

    void _shareApp() {
      final box = context.findRenderObject() as RenderBox?;
      Share.share(
          "Download Prashna (Old is Gold) now from: https://play.google.com/store/apps/details?id=com.bijay.prashna_app",
          subject: "Download Prashna (Old is Gold) App",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }

    Future<void> _subjectDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
            title: Text(
              'Enter subject code',
              style: style.copyWith(color: PRIMARY_BLUE),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: textController,
                    maxLines: null,
                    style:
                        const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel', style: style.copyWith(fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                child: Text(
                  'Enroll',
                  style: style.copyWith(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {
                  dio()
                      .post("/user/categories/enroll",
                          data: {"code": textController.text},
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}))
                      .then((value) {
                    Navigator.pop(context);
                    if (value.data == true) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(10),
                            title: Text(
                              "Successfully enrolled the subject!",
                              style: style.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Roboto'),
                            ),
                            backgroundColor: Colors.green,
                          );
                        },
                      ).then((value) {
                        currTheme.refreshUser();
                        textController.clear();
                      }).catchError((error) {
                        if (kDebugMode) {
                          print(error);
                        }
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(10),
                            title: Text(
                              "Sorry! Couldnt find the subject!",
                              style: style.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            backgroundColor: Colors.red,
                          );
                        },
                      ).then((value) {
                        textController.clear();
                      }).catchError((error) {
                        if (kDebugMode) {
                          print(error);
                        }
                      });
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _courseDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
            title: Text(
              'Enter course code',
              style: style.copyWith(color: PRIMARY_BLUE),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: textController,
                    maxLines: null,
                    style:
                        const TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel', style: style.copyWith(fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue[700]),
                child: Text(
                  'Enroll',
                  style: style.copyWith(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {
                  dio()
                      .post("/user/courses/enroll",
                          data: {"code": textController.text},
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}))
                      .then((value) {
                    Navigator.pop(context);
                    if (value.data == true) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(10),
                            title: Text(
                              "Successfully enrolled the course!",
                              style: style.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Roboto'),
                            ),
                            backgroundColor: Colors.green,
                          );
                        },
                      ).then((value) {
                        currTheme.refreshUser();
                        textController.clear();
                      }).catchError((error) {
                        if (kDebugMode) {
                          print(error);
                        }
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(10),
                            title: Text(
                              "Sorry! Couldnt find the course!",
                              style: style.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            backgroundColor: Colors.red,
                          );
                        },
                      ).then((value) {
                        textController.clear();
                      }).catchError((error) {
                        if (kDebugMode) {
                          print(error);
                        }
                      });
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: PRIMARY_BLUE,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: PRIMARY_BLUE,
          shadowColor: Colors.transparent,
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      color: PRIMARY_BLUE,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(children: [
                                    Center(
                                        child: user == null
                                            ? const Icon(Icons.account_circle,
                                                size: 120, color: Colors.white)
                                            : SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Material(
                                                        elevation: 10,
                                                        child: Image.network(
                                                            user.avatar,
                                                            fit: BoxFit
                                                                .cover))))),
                                    user == null
                                        ? Container()
                                        : Positioned(
                                            right: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                90,
                                            child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Provider.of<Auth>(
                                                                context,
                                                                listen: true)
                                                            .darkTheme
                                                        ? PRIMARY_DARK
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0)),
                                                child: IconButton(
                                                    onPressed: () {
                                                      getImage(
                                                          ImageSource.gallery,
                                                          context: context);
                                                    },
                                                    icon: const Icon(
                                                      Icons.add_a_photo,
                                                      size: 20,
                                                    )))),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(top: 140),
                                        child: Column(
                                          children: [
                                            user == null
                                                ? Container()
                                                : Text(
                                                    user.name,
                                                    style: style.copyWith(
                                                        fontSize: 25,
                                                        color: Colors.white),
                                                  ),
                                            user == null
                                                ? Container()
                                                : const SizedBox(
                                                    height: 10,
                                                  ),
                                            Text(
                                              user == null
                                                  ? "Anonymous"
                                                  : user.email,
                                              style: TextStyle(
                                                  color: Colors.grey.shade200,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ))
                                  ])),
                            ],
                          ),
                        ],
                      )),
                  Container(
                      decoration: BoxDecoration(
                          color:
                              Provider.of<Auth>(context, listen: true).darkTheme
                                  ? SECONDARY_DARK
                                  : PRIMARY_LIGHT,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 20, color: PRIMARY_BLUE.shade200),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              title: const Text(
                                "Edit Profile",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text("Edit your information"),
                              leading: const Icon(
                                Icons.print,
                                color: PRIMARY_BLUE,
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: PRIMARY_BLUE),
                              onTap: _editProfileDialog,
                            ),
                            ListTile(
                              title: const Text("Enroll Course",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle:
                                  const Text("Enroll course using course code"),
                              leading: const Icon(
                                Icons.library_books,
                                color: PRIMARY_BLUE,
                              ),
                              onTap: _courseDialog,
                            ),
                            ListTile(
                              title: const Text("Enroll Subject",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text(
                                  "Enroll subject using subject code"),
                              leading: const Icon(
                                Icons.book_online,
                                color: PRIMARY_BLUE,
                              ),
                              onTap: _subjectDialog,
                            ),
                            ListTile(
                              title: const Text(
                                "Dark mode",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text("Change your theme"),
                              leading: const Icon(
                                Icons.nightlight,
                                color: PRIMARY_BLUE,
                              ),
                              trailing: Switch(
                                  value: currTheme.darkTheme,
                                  activeTrackColor: LIGHT_GREY,
                                  activeColor: PRIMARY_GREY,
                                  onChanged: (bool toggle) {
                                    currTheme.darkTheme = toggle;
                                  }),
                            ),
                            ListTile(
                              title: const Text("Feedback",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text("Provide feedback for app"),
                              leading: const Icon(
                                Icons.feedback,
                                color: PRIMARY_BLUE,
                              ),
                              onTap: _feedbackDialog,
                            ),
                            ListTile(
                              title: const Text("Share app",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle:
                                  const Text("Share app to your friends."),
                              leading: const Icon(
                                Icons.share,
                                color: PRIMARY_BLUE,
                              ),
                              onTap: _shareApp,
                            ),
                            ListTile(
                              title: const Text("Privacy Policy",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text("Privacy policy"),
                              leading: const Icon(
                                Icons.privacy_tip,
                                color: PRIMARY_BLUE,
                              ),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const PrivacyPolicyScreen(),
                                        type: PageTransitionType
                                            .rightToLeftWithFade));
                              },
                            ),
                            ListTile(
                              title: const Text("Logout",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text("Logout from app"),
                              leading: const Icon(
                                Icons.logout,
                                color: PRIMARY_BLUE,
                              ),
                              onTap: () async {
                                await Provider.of<Auth>(context, listen: false)
                                    .logoutUser(context);
                              },
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )));
  }
}
