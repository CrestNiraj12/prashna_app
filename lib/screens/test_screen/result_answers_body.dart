// import 'package:flutter/material.dart';
// import 'package:nibble_app/components/imageView.dart';
// // import 'package:nibble_app/components/imageView.dart';
// import 'package:nibble_app/constants.dart';
// import 'package:nibble_app/utilities/auth.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_tex/flutter_tex.dart';

// class ResultAnswersBody extends StatefulWidget {
//   final String question;
//   final String? questionImage;
//   final List options;
//   final String correctAnswer;
//   final String? givenAnswer;
//   final int status, index;
//   final String? hint;
//   final String? hintImage;
//   final bool richText;

//   ResultAnswersBody(
//       {Key? key,
//       required this.question,
//       this.questionImage,
//       required this.options,
//       required this.correctAnswer,
//       required this.givenAnswer,
//       required this.status,
//       required this.richText,
//       this.hint,
//       this.hintImage,
//       required this.index})
//       : super(key: key);

//   @override
//   _ResultAnswersBodyState createState() => _ResultAnswersBodyState();
// }

// class _ResultAnswersBodyState extends State<ResultAnswersBody> {
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currTheme = Provider.of<Auth>(context, listen: false);

//     List alphas = ["A", "B", "C", "D"];
//     TextStyle style = new TextStyle(
//         fontSize: 18,
//         color: Provider.of<Auth>(context, listen: false).darkTheme
//             ? Colors.white
//             : PRIMARY_DARK,
//         fontFamily: 'Montserrat');

//     TeXViewStyle texStyle = new TeXViewStyle(
//       fontStyle: TeXViewFontStyle(fontSize: 18, fontFamily: 'Montserrat'),
//       contentColor: Provider.of<Auth>(context, listen: false).darkTheme
//           ? Colors.white
//           : PRIMARY_DARK,
//     );

//     return SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//                 child: Text(
//               "Q No. " + (widget.index + 1).toString(),
//               style: style.copyWith(fontWeight: FontWeight.bold),
//             )),
//             widget.richText
//                 ? TeXView(
//                     renderingEngine: TeXViewRenderingEngine.mathjax(),
//                     loadingWidgetBuilder: (BuildContext context) => Container(
//                           width: MediaQuery.of(context).size.width,
//                           margin: EdgeInsets.only(top: 30),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const <Widget>[
//                               CircularProgressIndicator(),
//                             ],
//                           ),
//                         ),
//                     child: TeXViewColumn(children: [
//                       TeXViewDocument(
//                           """<style>table, th, td {
//                                         border: 1px solid black;
//                                         border-collapse: collapse;
//                                         margin-top:10px;
//                                          padding: 5px;
//                                       }</style>""" +
//                               widget.question,
//                           style: TeXViewStyle(
//                               margin: TeXViewMargin.only(bottom: 20, top: 20),
//                               contentColor: currTheme.darkTheme
//                                   ? Colors.white
//                                   : PRIMARY_DARK)),
//                       widget.questionImage != null
//                           ? TeXViewContainer(
//                               child:
//                                   TeXViewImage.network(widget.questionImage!),
//                               style: TeXViewStyle(
//                                   margin: TeXViewMargin.only(bottom: 30),
//                                   textAlign: TeXViewTextAlign.center,
//                                   height: 200),
//                             )
//                           : TeXViewDocument(""),
//                       TeXViewDocument(
//                         'Options: ',
//                         style: TeXViewStyle(
//                             margin: TeXViewMargin.only(bottom: 20),
//                             contentColor: currTheme.darkTheme
//                                 ? Colors.white
//                                 : PRIMARY_DARK,
//                             fontStyle: TeXViewFontStyle(
//                                 fontFamily: texStyle.fontStyle!.fontFamily,
//                                 fontSize: 16,
//                                 fontWeight: TeXViewFontWeight.bold)),
//                       ),
//                       TeXViewGroup(
//                           onTap: null,
//                           children:
//                               widget.options.asMap().entries.map((option) {
//                             return TeXViewGroupItem(
//                                 rippleEffect: false,
//                                 id: option.key.toString(),
//                                 child: TeXViewDocument(
//                                     """<style>table, th, td {
//                                         border: 1px solid black;
//                                         border-collapse: collapse;
//                                         margin-top:10px;
//                                       }</style>""" +
//                                         "<div style='display: flex'>" +
//                                         alphas[option.key] +
//                                         ". <span style='margin-left: 2px'>" +
//                                         option.value +
//                                         '</span></div>',
//                                     style: TeXViewStyle(
//                                         margin: TeXViewMargin.only(bottom: 10),
//                                         contentColor: widget.correctAnswer ==
//                                                 option.value
//                                             ? Colors.green[600]
//                                             : widget.correctAnswer !=
//                                                         widget.givenAnswer &&
//                                                     option.value ==
//                                                         widget.givenAnswer
//                                                 ? Colors.red[600]
//                                                 : currTheme.darkTheme
//                                                     ? Colors.white
//                                                     : PRIMARY_DARK)));
//                           }).toList()),
//                       widget.status == 0
//                           ? TeXViewDocument(
//                               "Given Answer: Not Answered".toUpperCase(),
//                               style: TeXViewStyle(
//                                   margin: TeXViewMargin.only(top: 20),
//                                   fontStyle: TeXViewFontStyle(
//                                       fontFamily:
//                                           texStyle.fontStyle!.fontFamily,
//                                       fontSize: 12),
//                                   contentColor: Colors.red[600]),
//                             )
//                           : TeXViewDocument(
//                               """<style>table, th, td {
//                                         border: 1px solid black;
//                                         border-collapse: collapse;
//                                         margin-top:10px;
//                                         padding: 5px;
//                                       }</style>""" +
//                                   "<div style='display: flex'>Given Answer: " +
//                                   "<span style='margin-left: 2px'>" +
//                                   widget.givenAnswer! +
//                                   '</span></div>',
//                               style: TeXViewStyle(
//                                   margin: TeXViewMargin.only(top: 20),
//                                   contentColor: widget.status == 1
//                                       ? Colors.green[600]
//                                       : Colors.red[600])),
//                       widget.status != 1 &&
//                               (widget.hint != null || widget.hintImage != null)
//                           ? TeXViewContainer(
//                               style: TeXViewStyle(
//                                 margin: TeXViewMargin.only(top: 20),
//                                 padding: TeXViewPadding.all(12),
//                                 borderRadius: TeXViewBorderRadius.all(5),
//                                 border: TeXViewBorder.all(
//                                     TeXViewBorderDecoration(
//                                         borderColor: PRIMARY_BLUE,
//                                         borderWidth: 1)),
//                                 width:
//                                     MediaQuery.of(context).size.width.toInt() -
//                                         68,
//                               ),
//                               child: TeXViewColumn(children: [
//                                 TeXViewDocument("Hint",
//                                     style: TeXViewStyle(
//                                         fontStyle: TeXViewFontStyle(
//                                             fontFamily:
//                                                 texStyle.fontStyle!.fontFamily,
//                                             fontSize: 13,
//                                             fontWeight: TeXViewFontWeight.bold),
//                                         contentColor: PRIMARY_BLUE)),
//                                 widget.hint != null
//                                     ? TeXViewDocument(widget.hint!,
//                                         style: TeXViewStyle(
//                                             margin: TeXViewMargin.only(top: 5),
//                                             contentColor: currTheme.darkTheme
//                                                 ? Colors.white
//                                                 : PRIMARY_DARK))
//                                     : TeXViewDocument(""),
//                                 widget.hintImage != null
//                                     ? TeXViewContainer(
//                                         child: TeXViewImage.network(
//                                             widget.hintImage!),
//                                         style: TeXViewStyle(
//                                             margin: TeXViewMargin.only(top: 15),
//                                             textAlign: TeXViewTextAlign.center,
//                                             height: 200),
//                                       )
//                                     // ImageViewComponent(image: widget.hintImage!)
//                                     : TeXViewDocument("")
//                               ]))
//                           : TeXViewDocument("")
//                     ]))
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                           margin: EdgeInsets.symmetric(vertical: 20),
//                           child: Text(
//                             widget.question,
//                             style: style,
//                           )),
//                       widget.questionImage != null
//                           ? ImageViewComponent(image: widget.questionImage!)
//                           : Container(),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Text(
//                         "Options:",
//                         style: style.copyWith(
//                             fontFamily: "Roboto",
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Column(
//                         children: widget.options.asMap().entries.map((option) {
//                           return Container(
//                             margin: EdgeInsets.only(bottom: 10),
//                             child: Text(
//                               alphas[option.key] + ". " + option.value,
//                               style: style.copyWith(
//                                   fontSize: 15,
//                                   color: widget.correctAnswer == option.value
//                                       ? Colors.green[600]
//                                       : widget.correctAnswer !=
//                                                   widget.givenAnswer &&
//                                               option.value == widget.givenAnswer
//                                           ? Colors.red[600]
//                                           : currTheme.darkTheme
//                                               ? Colors.white
//                                               : PRIMARY_DARK),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       Container(
//                           margin: EdgeInsets.only(top: 20),
//                           child: widget.status == 0
//                               ? Text(
//                                   "Given Answer: Not Answered".toUpperCase(),
//                                   style: style.copyWith(
//                                       fontFamily: "Roboto",
//                                       fontSize: 12,
//                                       color: Colors.red[600]),
//                                 )
//                               : Text(
//                                   widget.givenAnswer!,
//                                   style: style.copyWith(
//                                       color: widget.status == 1
//                                           ? Colors.green[600]
//                                           : Colors.red[600]),
//                                 ))
//                     ],
//                   ),
//             !widget.richText &&
//                     (widget.status != 1 &&
//                         (widget.hint != null || widget.hintImage != null))
//                 ? Container(
//                     margin: EdgeInsets.only(top: 20.0),
//                     padding: EdgeInsets.all(8.0),
//                     color: Colors.blue.withOpacity(0.2),
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         RichText(
//                           text: TextSpan(
//                             children: [
//                               WidgetSpan(
//                                 alignment: PlaceholderAlignment.middle,
//                                 child: Icon(
//                                   Icons.lightbulb,
//                                   size: 13,
//                                   color: Colors.yellow,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: " Hint",
//                               ),
//                             ],
//                             style: style.copyWith(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                                 color: PRIMARY_BLUE),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         widget.hint != null
//                             ? Text(
//                                 widget.hint!,
//                                 style: style.copyWith(
//                                   fontSize: 15,
//                                 ),
//                               )
//                             : Container(),
//                         widget.hintImage != null
//                             ? SizedBox(
//                                 height: 5,
//                               )
//                             : Container(),
//                         widget.hintImage != null
//                             ? ImageViewComponent(image: widget.hintImage!)
//                             : Container(),
//                       ],
//                     ))
//                 : Container()
//           ],
//         ),
//       ),
//     );
//   }
// }
