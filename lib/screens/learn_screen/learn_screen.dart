// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:nibble_app/constants.dart';
// import 'package:nibble_app/models/set.dart';
// import 'package:nibble_app/screens/learn_screen/final_screen.dart';
// import 'package:nibble_app/screens/learn_screen/quiz_body.dart';
// import 'package:nibble_app/utilities/api.dart';
// import 'package:nibble_app/utilities/auth.dart';
// import 'package:nibble_app/utilities/findIcon.dart';
// import 'package:collection/collection.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';

// class QuizPage extends StatefulWidget {
//   final int setId;

//   QuizPage({
//     Key? key,
//     required this.setId,
//   }) : super(key: key);

//   @override
//   _QuizPageState createState() => _QuizPageState();
// }

// class _QuizPageState extends State<QuizPage> {
//   final pageController = PageController();
//   int _correctAnswers = 0;
//   List _questions = [];
//   List _extraQuestions = [];
//   bool _termsNotAvailable = false;
//   int _totalQuestions = 1;
//   bool _loading = true;

//   List getList(int n, List source, String filter) => source
//       .where((element) => element != filter)
//       .sample(n)
//       .map((def) => {"option": def, "isCorrect": false})
//       .toList();

//   @override
//   void initState() {
//     super.initState();
//     loadSet();
//   }

//   void loadSet() async {
//     Response response = await dio().get("/sets/" + widget.setId.toString());
//     Set set = Set.fromJson(response.data);

//     List<dynamic>? terms = set.terms;

//     setState(() {
//       if (terms?.isEmpty ?? true) {
//         _termsNotAvailable = true;
//       } else {
//         List answers = terms!.map((t) => t['term']).toList();
//         List qs = [];
//         terms.forEach((element) {
//           final list = [
//             {"option": element['term'], "isCorrect": true},
//             ...getList(3, answers, element['term'])
//           ];
//           list.shuffle();
//           qs.add({
//             "question": element['definition'],
//             "image": element['image'],
//             "answer": element['term'],
//             "options": list
//           });
//         });

//         _questions = qs;
//         _totalQuestions = _questions.length;
//       }
//       _loading = false;
//     });
//   }

//   void goToNextPage() {
//     pageController.nextPage(
//       duration: Duration(
//         milliseconds: 250,
//       ),
//       curve: Curves.linear,
//     );

//     if (_correctAnswers >= _totalQuestions)
//       Navigator.pushReplacement(
//           context,
//           PageTransition(
//               child: FinalLearnScreen(
//                 setId: widget.setId,
//                 questions: _questions,
//               ),
//               type: PageTransitionType.rightToLeft));
//   }

//   void increaseCorrectAnswers() {
//     setState(() {
//       _correctAnswers++;
//     });
//   }

//   void onIncorrect(Map question) {
//     setState(() {
//       _extraQuestions.add(question);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextStyle style = new TextStyle(
//         fontSize: 16,
//         color: Provider.of<Auth>(context, listen: false).darkTheme
//             ? Colors.white
//             : PRIMARY_DARK,
//         fontFamily: 'Montserrat');

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(86),
//         child: SafeArea(
//           top: true,
//           child: Column(children: [
//             Stack(
//               children: [
//                 IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     }),
//                 Center(
//                     heightFactor: 2.5,
//                     child: RichText(
//                       text: TextSpan(
//                           children: [
//                             WidgetSpan(
//                               child: findIcon("learn", size: 22),
//                             ),
//                             TextSpan(
//                               text: " Learn",
//                             ),
//                           ],
//                           style: style.copyWith(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                     ))
//               ],
//             ),
//             Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: LinearProgressIndicator(
//                   value: _correctAnswers / _totalQuestions,
//                   valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_BLUE),
//                   backgroundColor:
//                       Provider.of<Auth>(context, listen: false).darkTheme
//                           ? PRIMARY_GREY
//                           : LIGHT_GREY,
//                 ))
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
//           : _termsNotAvailable
//               ? Container(
//                   height: MediaQuery.of(context).size.height - 100,
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Text(
//                           "Flash Card is not available for this subject!",
//                           style: style),
//                     ),
//                   ),
//                 )
//               : PageView(
//                   physics: NeverScrollableScrollPhysics(),
//                   controller: pageController,
//                   children: [..._questions, ..._extraQuestions]
//                       .asMap()
//                       .entries
//                       .map((q) => QuizBody(
//                           index: q.key,
//                           question: q.value["question"],
//                           options: q.value["options"],
//                           image: q.value["image"],
//                           goToNextPage: goToNextPage,
//                           increaseCorrectAnswers: increaseCorrectAnswers,
//                           onIncorrect: onIncorrect))
//                       .toList()),
//     );
//   }
// }
