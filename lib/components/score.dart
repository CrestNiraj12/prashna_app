import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import '../constants.dart';
import '../utilities/auth.dart';
import 'package:provider/provider.dart';

class Score extends StatefulWidget {
  final int totalScore, dailyScore, totalCorrectAnswers, dailyCorrectAnswers;
  const Score(
      {Key? key,
      required this.totalScore,
      required this.totalCorrectAnswers,
      required this.dailyScore,
      required this.dailyCorrectAnswers})
      : super(key: key);

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  final NumberFormat formatter = NumberFormat("##.0#", "en_US");

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
                    getInfo("total quizzes taken by user", Icons.school),
                    const SizedBox(
                      height: 10,
                    ),
                    getInfo("total correct answers in quizzes by user",
                        Icons.timelapse),
                    const SizedBox(
                      height: 10,
                    ),
                    getInfo("daily quizzes taken by user", Icons.library_books),
                    const SizedBox(
                      height: 10,
                    ),
                    getInfo("daily correct answers in quizzes by user",
                        Icons.check),
                  ],
                ),
              ));
        },
      );
    }

    return Card(
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
                      top: -10,
                      right: -5,
                      child: IconButton(
                          iconSize: 16,
                          splashRadius: 16,
                          padding: EdgeInsets.zero,
                          onPressed: _showHelp,
                          icon: const Icon(
                            Icons.help_outline,
                            color: LIGHT_GREY,
                          ))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getInfo(
                                "${widget.totalScore} learned", Icons.school),
                            SizedBox(
                              width: 90,
                              child: getInfo(
                                  "${widget.totalCorrectAnswers} answers",
                                  Icons.timelapse),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            getInfo("${widget.dailyScore} learned",
                                Icons.library_books),
                            SizedBox(
                                width: 90,
                                child: getInfo(
                                    "${widget.dailyCorrectAnswers} answers",
                                    Icons.check)),
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
