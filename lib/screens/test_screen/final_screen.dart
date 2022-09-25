import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prashna_app/components/imageView.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/utilities/api.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinalLearnScreen extends StatefulWidget {
  final List questions;
  final int setId;
  final int quizId;
  final int correctAnswers;

  const FinalLearnScreen(
      {Key? key,
      required this.setId,
      required this.quizId,
      required this.questions,
      required this.correctAnswers})
      : super(key: key);

  @override
  State<FinalLearnScreen> createState() => _FinalLearnScreenState();
}

class _FinalLearnScreenState extends State<FinalLearnScreen> {
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _pushCorrectAnswers();
  }

  void _pushCorrectAnswers() async {
    final SharedPreferences storage = await _storage;
    final String? token = storage.getString('token');

    if (token != null) {
      await dio().post("/prashna/submit/quiz/",
          data: {
            "quiz_id": widget.quizId,
            "correctAnswers": widget.correctAnswers,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: false);

    TextStyle style = TextStyle(
        fontSize: 14,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: SafeArea(
            top: true,
            child: Container(
              color: currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
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
                      heightFactor: 2.5,
                      child: Text("Quiz",
                          style: style.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.popUntil(context, ModalRoute.withName("Set"));
            return true;
          },
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 30),
                    color: currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Nice Job!",
                          style: style.copyWith(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "You have completed multiple choice questions!",
                          style: style.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Correct answers: ${widget.correctAnswers}",
                          style:
                              style.copyWith(fontSize: 14, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "Questions studied",
                              style: style.copyWith(
                                  fontSize: 14,
                                  color: currTheme.darkTheme
                                      ? LIGHT_GREY
                                      : PRIMARY_GREY,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.questions.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Card(
                                      elevation: 5,
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${index + 1}. ${widget.questions[index]['question']}",
                                              style: style.copyWith(
                                                  letterSpacing: 0.35,
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto'),
                                            ),
                                            widget.questions[index]
                                                        ['questionImage'] !=
                                                    null
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    child: ImageViewComponent(
                                                      image: widget
                                                              .questions[index]
                                                          ['questionImage'],
                                                      height: 150,
                                                    ),
                                                  )
                                                : Container(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Answer: ",
                                              style:
                                                  style.copyWith(fontSize: 10),
                                            ),
                                            Text(
                                              widget.questions[index]['answer'],
                                              style: style.copyWith(
                                                  color: Provider.of<Auth>(
                                                              context,
                                                              listen: false)
                                                          .darkTheme
                                                      ? Colors.greenAccent
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                  fontFamily: 'Roboto'),
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              })
                        ]),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
