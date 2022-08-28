import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/screens/test_screen/result_answers_body.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

class ResultAnswersScreen extends StatefulWidget {
  final int quizId;
  final List givenAnswers;
  final int page;

  ResultAnswersScreen(
      {Key? key,
      required this.quizId,
      required this.givenAnswers,
      this.page = 0})
      : super(key: key);

  @override
  _ResultAnswersScreenState createState() => _ResultAnswersScreenState();
}

class _ResultAnswersScreenState extends State<ResultAnswersScreen> {
  late PreloadPageController pageController;
  late List _givenAnswers;
  int _pageNumber = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    pageController = PreloadPageController(initialPage: widget.page);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _pageNumber = widget.page;
        _loading = false;
        _givenAnswers = widget.givenAnswers.asMap().entries.toList();
      });
    });
  }

  void goToPage(int i) {
    pageController.jumpToPage(i - 1);
  }

  void goToNextPage() {
    if (_pageNumber == (widget.givenAnswers.length - 1)) {
      return;
    }

    pageController.nextPage(
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontSize: 16,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

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
                      Navigator.pop(context);
                    }),
                Center(
                    heightFactor: 2,
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        "Your answers",
                        style: style.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
              ],
            ),
          ]),
        ),
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
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: PreloadPageView.builder(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              controller: pageController,
                              itemCount: widget.givenAnswers.length,
                              preloadPagesCount: widget.givenAnswers.length,
                              itemBuilder: (BuildContext context,
                                      int position) =>
                                  ResultAnswersBody(
                                      index: _givenAnswers[position]
                                          .value["index"],
                                      question: _givenAnswers[position]
                                          .value["question"],
                                      questionImage: _givenAnswers[position]
                                          .value["questionImage"],
                                      options: [
                                        _givenAnswers[position]
                                            .value["option1"],
                                        _givenAnswers[position]
                                            .value["option2"],
                                        _givenAnswers[position]
                                            .value["option3"],
                                        _givenAnswers[position].value["option4"]
                                      ],
                                      correctAnswer: _givenAnswers[position]
                                          .value["correctAnswer"],
                                      givenAnswer: _givenAnswers[position]
                                          .value["givenAnswer"],
                                      hint:
                                          _givenAnswers[position].value["hint"],
                                      hintImage: _givenAnswers[position]
                                          .value["hintImage"],
                                      richText: _givenAnswers[position]
                                          .value['richText'],
                                      status: _givenAnswers[position]
                                          .value["status"])),
                        )
                      ],
                    ),
                  ],
                )),
    );
  }
}
