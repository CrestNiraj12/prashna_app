import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:prashna_app/screens/discover_screen/discover_screen.dart';
import '../../constants.dart';
import '../../utilities/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    final provider = Provider.of<Auth>(context, listen: false);
    final navigator = Navigator.of(context);
    final SharedPreferences storage = await _storage;
    String? token = storage.getString('token');

    if (token != null) {
      try {
        await provider.authWithToken(token);
        navigator.pushReplacement(PageTransition(
            child: const DiscoverScreen(),
            type: PageTransitionType.fade,
            settings: const RouteSettings(name: "Discover")));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        navigator.pushReplacement(PageTransition(
            child: const DiscoverScreen(),
            type: PageTransitionType.fade,
            settings: const RouteSettings(name: "Discover")));
      }
    } else {
      navigator.pushReplacement(PageTransition(
          child: const DiscoverScreen(),
          type: PageTransitionType.fade,
          settings: const RouteSettings(name: "Discover")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: false);

    return Scaffold(
        body: Center(
            child: Container(
      width: MediaQuery.of(context).size.width,
      color: currTheme.darkTheme ? PRIMARY_DARK : Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 80,
                child: Image.asset(
                  "images/ideas.png",
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Prashna",
              style: TextStyle(
                  color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 50,
            ),
            const SpinKitFoldingCube(
              color: PRIMARY_DARK,
            )
          ]),
    )));
  }
}
