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

// class ResultWithScoreScreen extends StatefulWidget {
//   final int setId;
//   final Quiz quiz;
//   final double score, accuracy;
//   final List questions;
//   final int timeInSeconds;

//   ResultWithScoreScreen(
//       {Key? key,
//       required this.setId,
//       required this.quiz,
//       required this.score,
//       required this.accuracy,
//       required this.questions,
//       required this.timeInSeconds})
//       : super(key: key);

//   @override
//   _ResultWithScoreScreenState createState() => _ResultWithScoreScreenState();
// }

// class _ResultWithScoreScreenState extends State<ResultWithScoreScreen> {
//   int _correct = 0;
//   int _incorrect = 0;
//   int _left = 0;
//   bool _loading = true;
//   int _totalUsers = 0;
//   int _rank = 0;
//   int _attempts = 0;
//   int _total = 0;

//   @override
//   void initState() {
//     super.initState();
//     loadRank();
//   }

//   void loadRank() async {
//     final SharedPreferences storage = await SharedPreferences.getInstance();
//     final String? token = storage.getString('token');
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
//       _correct = widget.questions.where((q) => q["status"] == 1).length;
//       _incorrect = widget.questions.where((q) => q["status"] == 2).length;
//       _left = widget.questions.length - (_correct + _incorrect);
//       _total = widget.questions.length;
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
//         inverseScore = false}) {
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
//       body: _loading
//           ? SizedBox(
//               height: MediaQuery.of(context).size.height,
//               child: Center(
//                   child: CircularProgressIndicator(
//                 color: PRIMARY_BLUE,
//               )),
//             )
//           : SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Column(
//                       children: [
//                         Text(
//                           "Your Score",
//                           style: style.copyWith(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                               color: PRIMARY_BLUE),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           widget.score.toStringAsFixed(1) +
//                               " / " +
//                               widget.quiz.totalMarks.toString(),
//                           style: style.copyWith(
//                               fontSize: 28, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         RichText(
//                           text: TextSpan(children: [
//                             TextSpan(
//                                 text: ordinalNum(_attempts) + " Attempt ",
//                                 style: style.copyWith(
//                                     fontSize: 14, fontWeight: FontWeight.bold)),
//                             TextSpan(
//                                 text: "Exam Stats",
//                                 style: style.copyWith(fontSize: 14)),
//                           ], style: style.copyWith(color: PRIMARY_BLUE)),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 30),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           generateScoreGauge(_rank.toStringAsFixed(0), "Rank",
//                               _rank.toDouble(), _totalUsers.toDouble(),
//                               divider: true,
//                               integerResult: true,
//                               inverseScore: true),
//                           generateScoreGauge(
//                               widget.accuracy.toStringAsFixed(1) + '%',
//                               "Accuracy",
//                               widget.accuracy,
//                               100),
//                           generateScoreGauge(
//                               prettyDuration(
//                                   Duration(seconds: widget.timeInSeconds),
//                                   abbreviated: true,
//                                   delimiter: " ",
//                                   spacer: ""),
//                               "Time Taken",
//                               widget.timeInSeconds.toDouble(),
//                               widget.quiz.timeInSeconds.toDouble())
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: Text(
//                         widget.quiz.title,
//                         style: style.copyWith(
//                             fontWeight: FontWeight.bold, fontSize: 22),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   crossAxisAlignment: CrossAxisAlignment.center,
//                     //   children: [
//                     //     getIndex(true, "Correct : " + _correct.toString()),
//                     //     getIndex(false, "Wrong : " + _incorrect.toString()),
//                     //     getIndex(null, "Left : " + _left.toString()),
//                     //   ],
//                     // ),
//                     // Container(
//                     //     padding: EdgeInsets.symmetric(horizontal: 20),
//                     //     margin: EdgeInsets.symmetric(vertical: 30),
//                     //     color: currTheme.darkTheme
//                     //         ? SECONDARY_DARK
//                     //         : PRIMARY_LIGHT,
//                     //     child: GridView.count(
//                     //       shrinkWrap: true,
//                     //       crossAxisCount: 8,
//                     //       crossAxisSpacing: 3,
//                     //       mainAxisSpacing: 10,
//                     //       children: List<int>.generate(
//                     //               widget.questions.length, (i) => i + 1)
//                     //           .map((i) => GestureDetector(
//                     //                 onTap: () {
//                     //                   Navigator.push(
//                     //                       context,
//                     //                       PageTransition(
//                     //                           child: ResultAnswersScreen(
//                     //                             givenAnswers: widget.questions,
//                     //                             quizId: widget.quiz.id,
//                     //                             page: i - 1,
//                     //                           ),
//                     //                           type: PageTransitionType
//                     //                               .leftToRight));
//                     //                 },
//                     //                 child: Container(
//                     //                   decoration: BoxDecoration(
//                     //                       color: widget.questions[i - 1]
//                     //                                   ["status"] ==
//                     //                               1
//                     //                           ? Colors.green[400]
//                     //                           : (widget.questions[i - 1]
//                     //                                       ["status"] ==
//                     //                                   2
//                     //                               ? Colors.red[400]
//                     //                               : Colors.yellow[800])),
//                     //                   child: Center(
//                     //                     child: Text(
//                     //                       i.toString(),
//                     //                       style: style.copyWith(
//                     //                           fontSize: 14,
//                     //                           color: Colors.white),
//                     //                     ),
//                     //                   ),
//                     //                 ),
//                     //               ))
//                     //           .toList(),
//                     //     )),
//                     QuestionStatusCard(
//                       title: "Correct",
//                       data: _correct,
//                       total: _total,
//                       color: PRIMARY_BLUE,
//                       questions: widget.questions
//                           .where((q) => q["status"] == 1)
//                           .toList(),
//                       quizId: widget.quiz.id,
//                     ),
//                     QuestionStatusCard(
//                       title: "Incorrect",
//                       data: _incorrect,
//                       total: _total,
//                       color: Colors.red[400]!,
//                       questions: widget.questions
//                           .where((q) => q["status"] == 2)
//                           .toList(),
//                       quizId: widget.quiz.id,
//                     ),
//                     QuestionStatusCard(
//                       title: "Left",
//                       data: _left,
//                       total: _total,
//                       color: Colors.yellow[800]!,
//                       questions: widget.questions
//                           .where((q) => q["status"] == 0)
//                           .toList(),
//                       quizId: widget.quiz.id,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
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
//                                 givenAnswers: widget.questions,
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
