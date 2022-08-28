import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/models/quiz.dart';
import 'package:prashna_app/screens/test_screen/result_screen_with_score.dart';
import 'package:prashna_app/screens/test_screen/test_screen.dart';
import 'package:prashna_app/utilities/api.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  final int quizId;
  final int setId;

  const StartScreen({
    Key? key,
    required this.setId,
    required this.quizId,
  }) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Quiz _quiz;
  late int _questionCount;
  bool _testNotFound = false;
  bool _loading = true;
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();
  Map? _prevScore;

  @override
  void initState() {
    loadSet();
    super.initState();
  }

  void loadSet() async {
    final SharedPreferences storage = await _storage;
    final String? token = storage.getString('token');
    Response response = await dio().get("/quiz/${widget.quizId}");
    if (response.data?.isEmpty ?? true) {
      setState(() {
        _testNotFound = true;
        _loading = false;
      });
    } else {
      Quiz quiz = Quiz.fromJson(response.data);

      if (token != null) {
        response = await dio().post("/quiz/last-score/",
            data: {"quiz_id": quiz.id},
            options: Options(headers: {'Authorization': 'Bearer $token'}));
      }

      setState(() {
        _quiz = quiz;
        _questionCount = quiz.questions.length;
        _loading = false;
        _prevScore = token != null ? response.data : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontSize: 16,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    TextStyle headingStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        color: PRIMARY_BLUE,
        fontFamily: 'Montserrat');

    TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    TextStyle smallTextStyle = TextStyle(
        fontSize: 13,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    Widget getIndex(Color color, String text) {
      return Row(children: [
        Container(
          height: 15,
          width: 15,
          color: color,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: style.copyWith(fontSize: 14),
        )
      ]);
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SafeArea(
              top: true,
              child: Column(children: [
                Stack(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.popUntil(
                              context, ModalRoute.withName("Set"));
                        }),
                    Center(
                        heightFactor: 2,
                        child: Text(
                          "Exam Detail",
                          style: style.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                  ],
                )
              ])),
        ),
        body: SafeArea(
          child: _loading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: PRIMARY_BLUE,
                  )),
                )
              : _testNotFound
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Quiz is not available for this subject!",
                              style: titleStyle),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        _quiz.title,
                                        style: style.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                                width: 30.0,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            _quiz.publisher
                                                                .avatar)))),
                                          ),
                                          Text(_quiz.publisher.name,
                                              style: style.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Provider.of<Auth>(
                                                              context,
                                                              listen: false)
                                                          .darkTheme
                                                      ? LIGHT_GREY
                                                      : PRIMARY_GREY))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Published ${_quiz.createdAt}",
                                        style: style.copyWith(
                                            color: PRIMARY_GREY, fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(_quiz.description, style: style),
                                      Container(
                                        height: 180,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: LIGHT_GREY)),
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Full Marks: ",
                                                    style: headingStyle),
                                                Text(
                                                    _quiz.totalMarks.toString(),
                                                    style: titleStyle)
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Pass Marks: ",
                                                    style: headingStyle),
                                                Text(_quiz.passMarks.toString(),
                                                    style: titleStyle)
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Total Question: ",
                                                    style: headingStyle),
                                                Text(_questionCount.toString(),
                                                    style: titleStyle)
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Negative Marking: ",
                                                    style: headingStyle),
                                                Text(
                                                    "-${_quiz.negativeMarking}%",
                                                    style: titleStyle)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "How to use Prashna (Old is Gold)",
                                              style: style.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            "1. Swipe left or right to switch the questions.",
                                            style: smallTextStyle,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "2. Use navigation bar to easily move between questions",
                                            style: smallTextStyle,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "3. The color palette represents followings.",
                                            style: smallTextStyle,
                                          ),
                                          const SizedBox(height: 10),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      getIndex(
                                                          Colors.yellow[800]!,
                                                          "Answered"),
                                                      getIndex(Colors.red[400]!,
                                                          "Left"),
                                                    ]),
                                                const SizedBox(height: 5),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      getIndex(PRIMARY_BLUE,
                                                          "Current"),
                                                    ])
                                              ]),
                                          const SizedBox(height: 10),
                                          Text(
                                            "4. You can access hints and detailed summary after submitting the test.",
                                            style: smallTextStyle,
                                          ),
                                        ],
                                      ),
                                    ])),
                          ]),
                    ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Container(
            color: Provider.of<Auth>(context, listen: false).darkTheme
                ? SECONDARY_DARK
                : PRIMARY_LIGHT,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            height: 80,
            child: _prevScore != null && _prevScore!.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: TestScreen(
                                          setId: widget.setId,
                                          questionCount: _questionCount,
                                          quiz: _quiz),
                                      type: PageTransitionType.leftToRight));
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size.fromHeight(40),
                              primary: PRIMARY_BLUE,
                              elevation: 5,
                            ),
                            child: Text(
                              "Try Again",
                              style: style.copyWith(
                                  color: Colors.white, fontSize: 13),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: ResultWithScoreScreen(
                                        setId: widget.setId,
                                        quiz: _quiz,
                                        score: _prevScore!["score"].toDouble(),
                                        accuracy:
                                            _prevScore!["accuracy"].toDouble(),
                                        questions: _prevScore![
                                            "user_took_quiz_questions"],
                                      ),
                                      type: PageTransitionType.leftToRight));
                            },
                            style: OutlinedButton.styleFrom(
                                fixedSize: const Size.fromHeight(40),
                                primary: PRIMARY_BLUE,
                                side: const BorderSide(
                                    color: PRIMARY_BLUE, width: 2)),
                            child: Text(
                              "View Result",
                              style: style.copyWith(
                                  color: PRIMARY_BLUE, fontSize: 13),
                            )),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: TestScreen(
                                        setId: widget.setId,
                                        questionCount: _questionCount,
                                        quiz: _quiz),
                                    type: PageTransitionType.leftToRight));
                          },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromHeight(60),
                      primary: PRIMARY_BLUE,
                      elevation: 5,
                    ),
                    child: Text(
                      "Start Test",
                      style: style.copyWith(color: Colors.white),
                    )),
          ),
        ));
  }
}
