// import 'package:dio/dio.dart';
// import 'package:duration/duration.dart';
// import 'package:flutter/material.dart';
// import 'package:nibble_app/components/questionStatusCard.dart';
// import 'package:nibble_app/constants.dart';
// import 'package:nibble_app/models/quiz.dart';
// import 'package:nibble_app/screens/test_screen/result_answers_screen.dart';
// import 'package:nibble_app/screens/test_screen/test_screen.dart';
// import 'package:nibble_app/utilities/api.dart';
// import 'package:nibble_app/utilities/auth.dart';
// import 'package:nibble_app/utilities/findIcon.dart';
// import 'package:nibble_app/utilities/globals.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

// class ResultScreen extends StatefulWidget {
//   final int setId; // setId
//   final List selected;
//   final Quiz quiz;
//   final int correctAnswers;
//   final List questions;
//   final int secondsRemaining;

//   ResultScreen(
//       {Key? key,
//       required this.setId,
//       required this.selected,
//       required this.quiz,
//       required this.correctAnswers,
//       required this.questions,
//       required this.secondsRemaining})
//       : super(key: key);

//   @override
//   _ResultScreenState createState() => _ResultScreenState();
// }

// class _ResultScreenState extends State<ResultScreen> {
//   static Future<SharedPreferences> _storage = SharedPreferences.getInstance();
//   int _correct = 0;
//   int _incorrect = 0;
//   int _left = 0;
//   double _score = 0;
//   bool _loading = true;
//   List _givenAnswers = [];
//   int _totalUsers = 0;
//   int _rank = 0;
//   int _attempts = 0;
//   int _total = 0;

//   @override
//   void initState() {
//     super.initState();
//     double rawScore = 0;
//     setState(() {
//       widget.selected.asMap().entries.forEach((selected) {
//         if (selected.value['option'] ==
//             widget.questions[selected.key]['answer']) {
//           _correct++;
//           rawScore += widget.questions[selected.key]['marks'];
//         } else if (selected.value['option'] !=
//                 widget.questions[selected.key]['answer'] &&
//             selected.value['option'] != null) {
//           _incorrect++;
//           rawScore -= widget.questions[selected.key]['marks'] *
//               (widget.quiz.negativeMarking / 100);
//         }
//       });
//       _left = widget.questions.length - (_correct + _incorrect);
//       _score = rawScore;
//       _total = widget.questions.length;
//     });
//     setScore();
//   }

//   void setScore() async {
//     final SharedPreferences storage = await _storage;
//     final String? token = storage.getString('token');
//     List questions = [];
//     int index = 0;
//     widget.selected.asMap().entries.forEach((selected) {
//       questions.add({
//         "index": index,
//         "question": widget.questions[selected.key]['question'],
//         "questionImage": widget.questions[selected.key]['questionImage'],
//         "option1": widget.questions[selected.key]["options"][0]['option'],
//         "option2": widget.questions[selected.key]["options"][1]['option'],
//         "option3": widget.questions[selected.key]["options"][2]['option'],
//         "option4": widget.questions[selected.key]["options"][3]['option'],
//         "hint": widget.questions[selected.key]["hint"],
//         "hintImage": widget.questions[selected.key]["hintImage"],
//         "correctAnswer": widget.questions[selected.key]['answer'],
//         "richText": int.parse(widget.questions[selected.key]['richText']),
//         "givenAnswer": selected.value['option'],
//         "status":
//             selected.value['option'] == widget.questions[selected.key]['answer']
//                 ? 1
//                 : selected.value['option'] !=
//                             widget.questions[selected.key]['answer'] &&
//                         selected.value['option'] != null
//                     ? 2
//                     : 0,
//       });
//       index++;
//     });
//     await dio().post("/submit/quiz/",
//         data: {
//           "quiz_id": widget.quiz.id,
//           "score": _score,
//           "accuracy": (_correct + _incorrect) == 0
//               ? "0"
//               : ((widget.correctAnswers / (_correct + _incorrect)) * 100),
//           "time_taken": widget.quiz.timeInSeconds - widget.secondsRemaining,
//           "questions": questions
//         },
//         options: Options(headers: {'Authorization': 'Bearer $token'}));

//     Response response = await dio().get(
//         "/user/quiz/rank/" + widget.quiz.id.toString(),
//         options: Options(headers: {'Authorization': 'Bearer $token'}));
//     final distinctIds = response.data['scores'].toSet().toList();
//     final rank = distinctIds.indexWhere((id) =>
//         id.toString() == Provider.of<Auth>(context, listen: false).user!.id);
//     setState(() {
//       _totalUsers = response.data['totalUsers'];
//       _rank = rank + 1;
//       _attempts = response.data['attempts'];
//       _givenAnswers = questions;
//       _loading = false;
//     });
//   }

//   void reset() {
//     Navigator.pushReplacement(
//         context,
//         PageTransition(
//             child: TestScreen(
//               quiz: widget.quiz,
//               setId: widget.setId,
//               questionCount: widget.quiz.questions.length,
//               retake: true,
//             ),
//             type: PageTransitionType.rightToLeft));
//   }

//   String? lowerStr(String? s) {
//     if (s != null)
//       return s.trim().toLowerCase();
//     else
//       return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currTheme = Provider.of<Auth>(context, listen: false);
//     TextStyle style = new TextStyle(
//         fontSize: 16,
//         color: Provider.of<Auth>(context, listen: false).darkTheme
//             ? Colors.white
//             : PRIMARY_DARK,
//         fontFamily: 'Montserrat');

//     Widget generateScoreGauge(
//         String innerText, String title, double score, double total,
//         {bool divider = false,
//         bool integerResult = false,
//         bool inverseScore = false}) {
//       return Column(
//         children: [
//           Container(
//             height: 100,
//             width: 110,
//             child: SfRadialGauge(axes: <RadialAxis>[
//               RadialAxis(
//                   minimum: 0,
//                   maximum: total,
//                   startAngle: 90,
//                   endAngle: 90,
//                   showLabels: false,
//                   showTicks: false,
//                   axisLineStyle: AxisLineStyle(
//                     thickness: 0.22,
//                     color: PRIMARY_GREY,
//                     thicknessUnit: GaugeSizeUnit.factor,
//                   ),
//                   pointers: <GaugePointer>[
//                     RangePointer(
//                       cornerStyle: score == total
//                           ? CornerStyle.bothFlat
//                           : CornerStyle.bothCurve,
//                       color: PRIMARY_BLUE,
//                       value: inverseScore ? (1 / total) - score : score,
//                       width: 0.22,
//                       sizeUnit: GaugeSizeUnit.factor,
//                       enableAnimation: true,
//                     )
//                   ],
//                   annotations: <GaugeAnnotation>[
//                     GaugeAnnotation(
//                         positionFactor: divider ? 0.75 : 0.15,
//                         angle: 90,
//                         widget: divider
//                             ? Column(
//                                 children: [
//                                   Text(
//                                       integerResult
//                                           ? score.toInt().toString()
//                                           : score.toString(),
//                                       style: style.copyWith(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: PRIMARY_BLUE)),
//                                   Container(
//                                     width: 50,
//                                     child: Divider(
//                                       thickness: 3,
//                                       height: 3,
//                                       color: PRIMARY_BLUE,
//                                     ),
//                                   ),
//                                   Text(
//                                       integerResult
//                                           ? total.toInt().toString()
//                                           : total.toString(),
//                                       style: style.copyWith(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                           color: PRIMARY_BLUE)),
//                                 ],
//                               )
//                             : Container(
//                                 width: 100,
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(innerText,
//                                           textAlign: TextAlign.center,
//                                           style: style.copyWith(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                               color: PRIMARY_BLUE)),
//                                     ]),
//                               ))
//                   ])
//             ]),
//           ),
//           Text(title,
//               style: style.copyWith(
//                 fontSize: 13,
//                 letterSpacing: 0.5,
//                 fontWeight: FontWeight.bold,
//               ))
//         ],
//       );
//     }

//     // Widget getIndex(bool? correct, String text) {
//     //   return Container(
//     //     margin: EdgeInsets.only(right: 10),
//     //     child: Row(children: [
//     //       Container(
//     //         height: 15,
//     //         width: 15,
//     //         color: correct == null
//     //             ? Colors.yellow[800]
//     //             : (correct ? Colors.green[400] : Colors.red[400]),
//     //       ),
//     //       SizedBox(
//     //         width: 10,
//     //       ),
//     //       Text(
//     //         text,
//     //         style: style.copyWith(fontSize: 12),
//     //       )
//     //     ]),
//     //   );
//     // }

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(65),
//         child: SafeArea(
//           top: true,
//           child: Column(children: [
//             Stack(
//               children: [
//                 IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () {
//                       Navigator.popUntil(context, ModalRoute.withName("Set"));
//                     }),
//                 Center(
//                     heightFactor: 2.5,
//                     child: RichText(
//                       text: TextSpan(
//                           children: [
//                             WidgetSpan(
//                               child: findIcon("test", size: 22),
//                             ),
//                             TextSpan(
//                               text: " Result",
//                             ),
//                           ],
//                           style: style.copyWith(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                     ))
//               ],
//             ),
//           ]),
//         ),
//       ),
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.popUntil(context, ModalRoute.withName("Set"));
//           return true;
//         },
//         child: _loading
//             ? SizedBox(
//                 height: MediaQuery.of(context).size.height,
//                 child: Center(
//                     child: CircularProgressIndicator(
//                   color: PRIMARY_BLUE,
//                 )),
//               )
//             : SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   width: MediaQuery.of(context).size.width,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             "Your Score",
//                             style: style.copyWith(
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.bold,
//                                 color: PRIMARY_BLUE),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             _score.toStringAsFixed(1) +
//                                 " / " +
//                                 widget.quiz.totalMarks.toString(),
//                             style: style.copyWith(
//                                 fontSize: 28, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           RichText(
//                             text: TextSpan(children: [
//                               TextSpan(
//                                   text: ordinalNum(_attempts) + " Attempt ",
//                                   style: style.copyWith(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold)),
//                               TextSpan(
//                                   text: "Exam Stats",
//                                   style: style.copyWith(fontSize: 14)),
//                             ], style: style.copyWith(color: PRIMARY_BLUE)),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 30),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             generateScoreGauge(_rank.toStringAsFixed(0), "Rank",
//                                 _rank.toDouble(), _totalUsers.toDouble(),
//                                 divider: true,
//                                 integerResult: true,
//                                 inverseScore: true),
//                             generateScoreGauge(
//                                 ((_correct + _incorrect) == 0
//                                         ? "0"
//                                         : ((widget.correctAnswers /
//                                                     (_correct + _incorrect)) *
//                                                 100)
//                                             .toStringAsFixed(1)) +
//                                     '%',
//                                 "Accuracy",
//                                 ((_correct + _incorrect) == 0
//                                     ? 0
//                                     : ((widget.correctAnswers /
//                                             (_correct + _incorrect)) *
//                                         100)),
//                                 100),
//                             generateScoreGauge(
//                                 prettyDuration(
//                                     Duration(
//                                         seconds: widget.quiz.timeInSeconds -
//                                             widget.secondsRemaining),
//                                     spacer: "",
//                                     delimiter: " ",
//                                     abbreviated: true),
//                                 "Time Taken",
//                                 (widget.quiz.timeInSeconds -
//                                         widget.secondsRemaining)
//                                     .toDouble(),
//                                 widget.quiz.timeInSeconds.toDouble())
//                           ],
//                         ),
//                       ),
//                       Center(
//                         child: Text(
//                           widget.quiz.title,
//                           style: style.copyWith(
//                               fontWeight: FontWeight.bold, fontSize: 22),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   crossAxisAlignment: CrossAxisAlignment.center,
//                       //   children: [
//                       //     getIndex(true, "Correct : " + _correct.toString()),
//                       //     getIndex(false, "Wrong : " + _incorrect.toString()),
//                       //     getIndex(null, "Left : " + _left.toString()),
//                       //   ],
//                       // ),
//                       // Container(
//                       //     padding: EdgeInsets.symmetric(horizontal: 20),
//                       //     margin: EdgeInsets.symmetric(vertical: 30),
//                       //     color: currTheme.darkTheme
//                       //         ? SECONDARY_DARK
//                       //         : PRIMARY_LIGHT,
//                       //     child: GridView.count(
//                       //       shrinkWrap: true,
//                       //       crossAxisCount: 8,
//                       //       crossAxisSpacing: 3,
//                       //       mainAxisSpacing: 10,
//                       //       children: List<int>.generate(
//                       //               widget.questions.length, (i) => i + 1)
//                       //           .map((i) => GestureDetector(
//                       //                 onTap: () {
//                       //                   Navigator.push(
//                       //                       context,
//                       //                       PageTransition(
//                       //                           child: ResultAnswersScreen(
//                       //                             givenAnswers: _givenAnswers,
//                       //                             quizId: widget.quiz.id,
//                       //                             page: i - 1,
//                       //                           ),
//                       //                           type: PageTransitionType
//                       //                               .leftToRight));
//                       //                 },
//                       //                 child: Container(
//                       //                   decoration: BoxDecoration(
//                       //                       color: widget.selected[i - 1]
//                       //                                   ["option"] ==
//                       //                               widget.questions[i - 1]
//                       //                                   ['answer']
//                       //                           ? Colors.green[400]
//                       //                           : (widget.selected[i - 1]
//                       //                                           ["option"] !=
//                       //                                       null &&
//                       //                                   widget.selected[i - 1]
//                       //                                           ["option"] !=
//                       //                                       widget.questions[
//                       //                                           i - 1]['answer']
//                       //                               ? Colors.red[400]
//                       //                               : Colors.yellow[800])),
//                       //                   child: Center(
//                       //                     child: Text(
//                       //                       i.toString(),
//                       //                       style: style.copyWith(
//                       //                           fontSize: 14,
//                       //                           color: Colors.white),
//                       //                     ),
//                       //                   ),
//                       //                 ),
//                       //               ))
//                       //           .toList(),
//                       //     ))
//                       QuestionStatusCard(
//                         title: "Correct",
//                         data: _correct,
//                         total: _total,
//                         color: PRIMARY_BLUE,
//                         questions: _givenAnswers
//                             .where((q) => q["status"] == 1)
//                             .toList(),
//                         quizId: widget.quiz.id,
//                       ),
//                       QuestionStatusCard(
//                         title: "Incorrect",
//                         data: _incorrect,
//                         total: _total,
//                         color: Colors.red[400]!,
//                         questions: _givenAnswers
//                             .where((q) => q["status"] == 2)
//                             .toList(),
//                         quizId: widget.quiz.id,
//                       ),
//                       QuestionStatusCard(
//                         title: "Left",
//                         data: _left,
//                         total: _total,
//                         color: Colors.yellow[800]!,
//                         questions: _givenAnswers
//                             .where((q) => q["status"] == 0)
//                             .toList(),
//                         quizId: widget.quiz.id,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0,
//         child: Container(
//           color: currTheme.darkTheme ? SECONDARY_DARK : PRIMARY_LIGHT,
//           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//           height: 80,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                     onPressed: () {
//                       reset();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       fixedSize: Size.fromHeight(40),
//                       primary: PRIMARY_BLUE,
//                       elevation: 5,
//                     ),
//                     child: Text(
//                       "Try Again",
//                       style: style.copyWith(color: Colors.white, fontSize: 13),
//                     )),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: OutlinedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                               child: ResultAnswersScreen(
//                                 givenAnswers: _givenAnswers,
//                                 quizId: widget.quiz.id,
//                               ),
//                               type: PageTransitionType.leftToRight));
//                     },
//                     style: OutlinedButton.styleFrom(
//                         fixedSize: Size.fromHeight(40),
//                         primary: PRIMARY_BLUE,
//                         side: BorderSide(color: PRIMARY_BLUE, width: 2)),
//                     child: Text(
//                       "Check Answer",
//                       style: style.copyWith(color: PRIMARY_BLUE, fontSize: 13),
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
