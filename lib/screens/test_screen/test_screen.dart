import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/models/quiz.dart';
import 'package:prashna_app/models/quizQuestion.dart';
import 'package:prashna_app/screens/learn_screen/quiz_body.dart';
import 'package:prashna_app/screens/test_screen/bottom_sheet.dart';
import 'package:prashna_app/screens/test_screen/result_screen.dart';
import 'package:prashna_app/screens/test_screen/test_start_screen.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:preload_page_view/preload_page_view.dart';

class TestScreen extends StatefulWidget {
  final Quiz quiz;
  final int setId, questionCount; // setId
  final bool retake;
  final bool result;

  const TestScreen(
      {Key? key,
      required this.setId,
      required this.questionCount,
      this.retake = false,
      required this.quiz,
      this.result = false})
      : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final pageController = PreloadPageController();
  int _pageNumber = 0;
  int _correctAnswers = 0;
  List _questions = [];
  List<Map<String, dynamic>> _selectedByPage = [];
  bool _loading = true;
  bool _absorbing = true;

  List getList(List source, String filter) => source
      .map((option) =>
          {"option": option, "isCorrect": option == filter ? true : false})
      .toList();

  @override
  void initState() {
    super.initState();
    _absorbing = !widget.retake;
    loadSet();
  }

  void goToPage(int i) {
    pageController.jumpToPage(i - 1);
  }

  void loadSet() async {
    List<QuizQuestion> questions =
        widget.quiz.questions.map((q) => QuizQuestion.fromJson(q)).toList();
    questions.sort((a, b) => a.index.compareTo(b.index));
    List qs = [];
    for (var question in questions) {
      final list = getList(question.options, question.correctOption);
      list.shuffle();
      qs.add({
        "id": question.id,
        "question": question.question,
        "questionImage": question.questionImage,
        "options": list,
        "hint": question.hint,
        "hintImage": question.hintImage,
        "answer": question.correctOption,
        "marks": question.marksPerQuestion,
        "richText": question.richText
      });
    }

    setState(() {
      _questions = qs;
      _selectedByPage = List<Map<String, dynamic>>.generate(qs.length, (index) {
        return {"option": null, "seen": index == 0 ? true : false};
      });
      _loading = false;
    });
  }

  void setSelected(String option) {
    setState(() {
      _selectedByPage[_pageNumber] = {"option": option, "seen": true};
    });
  }

  void goToNextPage() {
    if (_pageNumber == (_questions.length - 1)) {
      return;
    }

    pageController.nextPage(
      duration: const Duration(
        milliseconds: 150,
      ),
      curve: Curves.easeIn,
    );
  }

  void increaseCorrectAnswers() {
    setState(() {
      _correctAnswers++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: false);
    TextStyle style = TextStyle(
        fontSize: 16,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    void _showBottomSheet() {
      showModalBottomSheet(
          context: context,
          builder: (_) => TestBottomSheet(
                currentPage: _pageNumber,
                selectedByPage: _selectedByPage,
                goToPage: goToPage,
                questionCount: widget.questionCount,
              ));
    }

    Future<bool> _showCancelDialog() async {
      return await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor:
                    currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
                title: Text(
                  'Cancel Quiz',
                  style: style.copyWith(color: Colors.red[800]),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('Would you like to cancel the quiz?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  OutlinedButton(
                    child: Text('Cancel', style: style.copyWith(fontSize: 12)),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName("Set"));
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red[800]),
                    child: Text(
                      'Yes',
                      style: style.copyWith(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                          context, (route) => route.settings.name == "Set");
                    },
                  ),
                ],
              );
            },
          ) ??
          false;
    }

    Future<void> _showSubmitDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
            title: Text(
              'Submit Quiz',
              style: style.copyWith(color: PRIMARY_BLUE),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Would you like to submit the quiz?'),
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('No', style: style.copyWith(fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: PRIMARY_BLUE),
                child: Text(
                  'Yes',
                  style: style.copyWith(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: ResultScreen(
                              setId: widget.setId,
                              selected: _selectedByPage,
                              correctAnswers: _correctAnswers,
                              quiz: widget.quiz,
                              questions: _questions),
                          type: PageTransitionType.fade));
                },
              ),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: _showCancelDialog,
      child: Scaffold(
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
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: StartScreen(
                                  quizId: widget.quiz.id,
                                  setId: widget.setId,
                                ),
                                type: PageTransitionType.bottomToTop));
                      }),
                  Center(
                      heightFactor: 2,
                      child: SizedBox(
                        width: 250,
                        child: Text(
                          widget.quiz.title,
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
            child: Container(
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
                    AbsorbPointer(
                      absorbing: _absorbing,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                    onPressed: _showCancelDialog,
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 1.0, color: Colors.red[800]!),
                                    ),
                                    child: Text("Cancel",
                                        style: style.copyWith(
                                            fontSize: 12,
                                            color: Colors.red[800]))),
                                ElevatedButton(
                                    onPressed: _showSubmitDialog,
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0, primary: PRIMARY_BLUE),
                                    child: Text("Submit",
                                        style: style.copyWith(
                                            fontSize: 12, color: Colors.white)))
                              ],
                            ),
                          ),
                          Expanded(
                            child: PreloadPageView.builder(
                                physics: const ScrollPhysics(
                                    parent: ClampingScrollPhysics()),
                                controller: pageController,
                                preloadPagesCount: _questions.length,
                                itemCount: _questions.length,
                                onPageChanged: (page) {
                                  setState(() {
                                    _pageNumber = page;
                                    _selectedByPage[page]['seen'] = true;
                                  });
                                },
                                itemBuilder: (BuildContext context,
                                        int position) =>
                                    QuizBody(
                                      questionId: _questions[position]["id"],
                                      index: _pageNumber,
                                      question: _questions[position]
                                          ["question"],
                                      options: _questions[position]["options"],
                                      image: _questions[position]
                                          ["questionImage"],
                                      goToNextPage: goToNextPage,
                                      increaseCorrectAnswers:
                                          increaseCorrectAnswers,
                                      isTest: true,
                                      selected: _selectedByPage[_pageNumber]
                                          ['option'],
                                      setSelected: setSelected,
                                      richText: _questions[position]
                                          ["richText"],
                                    )),
                          ),
                          Container(
                            height: 80,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: _showBottomSheet,
                                style: ElevatedButton.styleFrom(
                                    primary: PRIMARY_BLUE),
                                child: Text(
                                  "Question Navigation",
                                  style: style.copyWith(
                                      fontSize: 13, color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _absorbing,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _absorbing = false;
                          });
                        },
                        onHorizontalDragStart: (dragStartDetails) {
                          setState(() {
                            _absorbing = false;
                          });
                        },
                        child: Container(
                          color: currTheme.darkTheme
                              ? PRIMARY_DARK.withOpacity(0.8)
                              : LIGHT_GREY.withOpacity(0.6),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Swipe left/right to navigate",
                                  style: style.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                              const Icon(Icons.switch_right_sharp,
                                  size: 80, color: PRIMARY_BLUE)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        )),
      ),
    );
  }
}
