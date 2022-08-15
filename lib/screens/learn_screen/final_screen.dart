// import 'package:flutter/material.dart';
// import 'package:nibble_app/constants.dart';
// import 'package:nibble_app/screens/learn_screen/learn_screen.dart';
// import 'package:nibble_app/screens/set_screen/set_screen.dart';
// import 'package:nibble_app/utilities/auth.dart';
// import 'package:nibble_app/utilities/findIcon.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';

// class FinalLearnScreen extends StatefulWidget {
//   final List questions;
//   final int setId;

//   FinalLearnScreen({
//     Key? key,
//     required this.setId,
//     required this.questions,
//   }) : super(key: key);

//   @override
//   _FinalLearnScreenState createState() => _FinalLearnScreenState();
// }

// class _FinalLearnScreenState extends State<FinalLearnScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   void reset() {
//     Navigator.pushReplacement(
//         context,
//         PageTransition(
//             child: QuizPage(
//               setId: widget.setId,
//             ),
//             type: PageTransitionType.rightToLeft));
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

//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(65),
//           child: SafeArea(
//             top: true,
//             child: Container(
//               color: currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
//               child: Column(children: [
//                 Stack(
//                   children: [
//                     IconButton(
//                         icon: Icon(Icons.close),
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                               context,
//                               PageTransition(
//                                   child: SetScreen(id: widget.setId),
//                                   type: PageTransitionType.bottomToTop));
//                         }),
//                     Center(
//                         heightFactor: 2.5,
//                         child: RichText(
//                           text: TextSpan(
//                               children: [
//                                 WidgetSpan(
//                                   child: findIcon("learn", size: 22),
//                                 ),
//                                 TextSpan(
//                                   text: " Learn",
//                                 ),
//                               ],
//                               style: style.copyWith(
//                                   fontSize: 18, fontWeight: FontWeight.bold)),
//                         ))
//                   ],
//                 ),
//               ]),
//             ),
//           ),
//         ),
//         body: WillPopScope(
//           onWillPop: () async {
//             return false;
//           },
//           child: SingleChildScrollView(
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(15, 15, 15, 30),
//                     color: currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Text(
//                           "Nice Job!",
//                           style: style.copyWith(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Text(
//                           "You have completed multiple choice questions!",
//                           style: style.copyWith(
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           "Up next! Practise what you have learnt with written questions to complete Learn mode.",
//                           style: style.copyWith(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(left: 5),
//                             child: Text(
//                               "Terms studied",
//                               style: style.copyWith(
//                                   fontSize: 14,
//                                   color: currTheme.darkTheme
//                                       ? LIGHT_GREY
//                                       : PRIMARY_GREY,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           ListView.builder(
//                               physics: NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: widget.questions.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Container(
//                                   margin: EdgeInsets.only(bottom: 5),
//                                   child: Card(
//                                       elevation: 5,
//                                       child: Container(
//                                         padding: EdgeInsets.all(15),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               widget.questions[index]['answer'],
//                                               style: style,
//                                             ),
//                                             SizedBox(
//                                               height: 20,
//                                             ),
//                                             Text(
//                                               widget.questions[index]
//                                                   ['question'],
//                                               style:
//                                                   style.copyWith(fontSize: 14),
//                                             ),
//                                             widget.questions[index]['image'] !=
//                                                     null
//                                                 ? Padding(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             vertical: 10),
//                                                     child: Image.network(
//                                                       widget.questions[index]
//                                                           ['image']!,
//                                                       width: 250,
//                                                     ))
//                                                 : Container()
//                                           ],
//                                         ),
//                                       )),
//                                 );
//                               })
//                         ]),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
