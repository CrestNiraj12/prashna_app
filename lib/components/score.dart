import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:prashna_app/components/loginHint.dart';
import '../constants.dart';
import '../utilities/api.dart';
import '../utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Score extends StatefulWidget {
  const Score({Key? key}) : super(key: key);

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  final NumberFormat formatter = NumberFormat("##.0#", "en_US");
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();
  late int _totalScore, _dailyScore, _totalTime, _dailyTime;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getScore();
  }

  void _getScore() async {
    final SharedPreferences storage = await _storage;
    final String? token = storage.getString('token');
    if (token != null) {
      Response response = await dio().get("/test/total-score",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      setState(() {
        _totalScore = response.data["totalScore"];
        _totalTime = response.data["totalTime"];
        _dailyScore = response.data["dailyScore"];
        _dailyTime = response.data["dailyTime"];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);

    TextStyle style = TextStyle(
        color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
        fontSize: 13.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Montserrat');

    Widget getInfo(String text, IconData icon) {
      return RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
                child: Icon(
              icon,
              color: PRIMARY_BLUE,
              size: 16,
            )),
            TextSpan(text: "  $text"),
          ],
          style: style,
        ),
      );
    }

    Future _showHelp() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor:
                  currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
              title: Text(
                'Help',
                style: style.copyWith(color: Colors.blue[800], fontSize: 16),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    getInfo("shows total quizzes taken by user", Icons.school),
                    const SizedBox(
                      height: 10,
                    ),
                    getInfo("shows total time spent in quizzes by user",
                        Icons.timelapse),
                    const SizedBox(
                      height: 10,
                    ),
                    getInfo("shows daily quizzes taken by user",
                        Icons.library_books),
                    const SizedBox(
                      height: 10,
                    ),
                    getInfo("shows daily time spent in quizzes by user",
                        Icons.alarm),
                  ],
                ),
              ));
        },
      );
    }

    return currTheme.user == null
        ? const LoginHint()
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            color: currTheme.darkTheme ? PRIMARY_DARK : Colors.white,
            child: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                      top: -5,
                      right: 0,
                      child: IconButton(
                          iconSize: 16,
                          splashRadius: 16,
                          padding: EdgeInsets.zero,
                          onPressed: _showHelp,
                          icon: const Icon(
                            Icons.help_outline,
                            color: LIGHT_GREY,
                          ))),
                  _loading
                      ? const SizedBox(
                          height: 130,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: PRIMARY_BLUE,
                          )),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  getInfo("$_totalScore learned", Icons.school),
                                  SizedBox(
                                    width: 90,
                                    child: getInfo(
                                        "$_totalTime min", Icons.timelapse),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  getInfo("$_dailyScore learned",
                                      Icons.library_books),
                                  SizedBox(
                                      width: 90,
                                      child: getInfo(
                                          "$_dailyTime min", Icons.alarm)),
                                ],
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ));
  }
}
