import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/imageView.dart';
// import '../../components/imageView.dart';
import '../../constants.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tex/flutter_tex.dart';

class QuizBody extends StatefulWidget {
  final int questionId;
  final String question;
  final List options;
  final String? image;
  final Function goToNextPage;
  final Function increaseCorrectAnswers;
  final Function? setSelected;
  final bool isTest;
  final String? selected;
  final int index;
  final bool richText;
  final String? hint;
  final String? hintImage;

  const QuizBody(
      {Key? key,
      this.questionId = -1,
      required this.index,
      required this.question,
      required this.options,
      required this.image,
      required this.goToNextPage,
      required this.increaseCorrectAnswers,
      required this.richText,
      this.hint,
      this.hintImage,
      this.setSelected,
      this.selected,
      this.isTest = false})
      : super(key: key);

  @override
  State<QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();
  bool _absorbing = false;
  final TextEditingController textController = TextEditingController();
  late String? token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void loadToken() async {
    final SharedPreferences storage = await _storage;
    token = storage.getString('token');
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List alphas = ["A", "B", "C", "D"];
    final currTheme = Provider.of<Auth>(context, listen: false);

    TextStyle style = TextStyle(
      fontSize: 18,
      color: Provider.of<Auth>(context, listen: false).darkTheme
          ? Colors.white
          : PRIMARY_DARK,
    );

    Future<void> _reportDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor:
                currTheme.darkTheme ? SECONDARY_DARK : Colors.white,
            title: Text(
              'Report the question',
              style: style.copyWith(color: PRIMARY_BLUE),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text(
                    'Please tell us why you want to report the question.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    minLines: 5,
                    controller: textController,
                    maxLines: null,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        hintText: 'Description'),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel', style: style.copyWith(fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red[700]),
                child: Text(
                  'Report',
                  style: style.copyWith(color: Colors.white, fontSize: 12),
                ),
                onPressed: () {
                  dio()
                      .post("/quiz/question/report",
                          data: {
                            "quiz_question_id": widget.questionId,
                            "reportMessage": textController.text
                          },
                          options: Options(
                              headers: {'Authorization': 'Bearer $token'}))
                      .then((value) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(10),
                          title: Text(
                            "Thank you! Your report is under review!",
                            style: style.copyWith(
                                color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: Colors.green,
                        );
                      },
                    ).then((value) {
                      textController.clear();
                    }).catchError((error) {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    }

    TeXViewWidget _teXViewWidget(String body) {
      return TeXViewColumn(children: [
        TeXViewDocument(body,
            style: TeXViewStyle(
                contentColor:
                    Provider.of<Auth>(context, listen: false).darkTheme
                        ? Colors.white
                        : PRIMARY_DARK))
      ]);
    }

    void onSelect(
        int index, String question, Map selected, String correctAnswer,
        {bool richText = false, String? hint, String? hintImage}) {
      setState(() {
        _absorbing = true;
        widget.setSelected!(selected['option']);
      });
      if (selected['isCorrect']) {
        widget.increaseCorrectAnswers();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(const Duration(seconds: 1), () {
              try {
                Navigator.of(context).pop(true);
              } catch (e) {
                return;
              }
            });
            return AlertDialog(
              titlePadding: const EdgeInsets.all(12),
              title: Text(
                '😄 Nicely Done',
                style: style.copyWith(color: Colors.white, fontSize: 14),
              ),
              backgroundColor: Colors.green,
            );
          },
        ).then((value) => widget.goToNextPage());
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  color: Colors.red,
                  child: Text(
                    '😕 Incorrect',
                    style: style.copyWith(color: Colors.white, fontSize: 18),
                  )),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // richTe6xt
                        // ? TeXView(
                        //     renderingEngine:
                        //         const TeXViewRenderingEngine.mathjax(),
                        //     child: TeXViewColumn(children: [
                        //       TeXViewDocument("""<style>table, th, td {
                        //             border: 1px solid black;
                        //             border-collapse: collapse;
                        //             margin-top:10px;
                        //              padding: 5px;
                        //           }</style>
                        //           <div style='display: flex'>${(widget.index + 1).toString()}. <span style='margin-left: 2px'>${widget.question}</span></div>""",
                        //           style: TeXViewStyle(
                        //               padding: const TeXViewPadding.only(
                        //                   bottom: 20),
                        //               contentColor: Provider.of<Auth>(
                        //                           context,
                        //                           listen: false)
                        //                       .darkTheme
                        //                   ? Colors.white
                        //                   : PRIMARY_DARK,
                        //               fontStyle:
                        //                   TeXViewFontStyle(fontSize: 16))),
                        //       TeXViewDocument("CORRECT ANSWER: ",
                        //           style: TeXViewStyle(
                        //               contentColor: Colors.green,
                        //               fontStyle:
                        //                   TeXViewFontStyle(fontSize: 10))),
                        //       TeXViewDocument(
                        //           '${"""<style>table, th, td {
                        //               border: 1px solid black;
                        //               border-collapse: collapse;
                        //               margin-top:10px;
                        //                padding: 5px;
                        //             }</style>$correctAnswer"""}</span></div>',
                        //           style: TeXViewStyle(
                        //               contentColor: Provider.of<Auth>(
                        //                           context,
                        //                           listen: false)
                        //                       .darkTheme
                        //                   ? Colors.white
                        //                   : PRIMARY_DARK,
                        //               fontStyle:
                        //                   TeXViewFontStyle(fontSize: 14))),
                        //       TeXViewDocument("YOU ANSWERED: ",
                        //           style: TeXViewStyle(
                        //               contentColor: Colors.red,
                        //               fontStyle:
                        //                   TeXViewFontStyle(fontSize: 10))),
                        //       TeXViewDocument(
                        //           '${"""<style>table, th, td {
                        //               border: 1px solid black;
                        //               border-collapse: collapse;
                        //               margin-top:10px;
                        //                padding: 5px;
                        //             }</style>${selected['option']}"""}</span></div>',
                        //           style: TeXViewStyle(
                        //               contentColor: Provider.of<Auth>(
                        //                           context,
                        //                           listen: false)
                        //                       .darkTheme
                        //                   ? Colors.white
                        //                   : PRIMARY_DARK,
                        //               fontStyle:
                        //                   TeXViewFontStyle(fontSize: 14))),
                        //     ])):
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${widget.index + 1}. $question",
                                  style: style.copyWith(fontSize: 16)),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Correct Answer:".toUpperCase(),
                                style: style.copyWith(
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    color: Colors.green),
                              ),
                              Text(correctAnswer,
                                  style: style.copyWith(fontSize: 14)),
                              const Divider(),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "You Answered:".toUpperCase(),
                                style: style.copyWith(
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    color: Colors.red),
                              ),
                              Text(selected['option'],
                                  style: style.copyWith(fontSize: 14)),
                              (hint != null || hintImage != null)
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: const [
                                              WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Icon(
                                                  Icons.lightbulb,
                                                  size: 13,
                                                  color: Colors.yellow,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " Hint",
                                              ),
                                            ],
                                            style: style.copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: PRIMARY_BLUE),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        hint != null
                                            ? Text(
                                                hint,
                                                style: style.copyWith(
                                                  fontSize: 15,
                                                ),
                                              )
                                            : Container(),
                                        hintImage != null
                                            ? const SizedBox(
                                                height: 5,
                                              )
                                            : Container(),
                                        hintImage != null
                                            ? ImageViewComponent(
                                                image: hintImage,
                                                height: 100,
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Container()
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  widget.goToNextPage();
                                },
                                child: const Text("Continue")))
                      ])),
            );
          },
        ).then((value) => widget.goToNextPage());
      }
    }

    return SingleChildScrollView(
      child: _loading
          ? Container()
          : AbsorbPointer(
              absorbing: _absorbing,
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          token != null
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: _reportDialog,
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(5.0, 5.0),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                              children: const [
                                                WidgetSpan(
                                                    child: Icon(Icons.flag,
                                                        size: 18,
                                                        color: Colors.red)),
                                                TextSpan(
                                                  text: " Report",
                                                ),
                                              ],
                                              style: TextStyle(
                                                  color: currTheme.darkTheme
                                                      ? Colors.white
                                                      : PRIMARY_DARK)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          widget.richText
                              ? TeXView(
                                  renderingEngine:
                                      const TeXViewRenderingEngine.mathjax(),
                                  child: TeXViewColumn(children: [
                                    _teXViewWidget("""<style>table, th, td {
                                        border: 1px solid black;
                                        border-collapse: collapse;
                                        margin-top:10px;
                                         padding: 5px;
                                      }</style>
                                      <div style='display: flex'>${(widget.index + 1).toString()}. <span style='margin-left: 2px'>${widget.question}</span></div>"""),
                                    widget.image != null
                                        ? TeXViewContainer(
                                            child: TeXViewImage.network(
                                                widget.image!),
                                            style: const TeXViewStyle(
                                                margin:
                                                    TeXViewMargin.only(top: 10),
                                                textAlign:
                                                    TeXViewTextAlign.center,
                                                height: 200),
                                          )
                                        : const TeXViewDocument(""),
                                    const TeXViewDocument("",
                                        style: TeXViewStyle(
                                            margin:
                                                TeXViewMargin.only(top: 20))),
                                    TeXViewContainer(
                                        style: const TeXViewStyle(
                                          padding: TeXViewPadding.only(
                                              top: 10, bottom: 10, right: 10),
                                        ),
                                        child: TeXViewGroup(
                                            children: widget.options
                                                .asMap()
                                                .entries
                                                .map((option) {
                                              return TeXViewGroupItem(
                                                  rippleEffect: true,
                                                  id: option.key.toString(),
                                                  child: TeXViewDocument(
                                                      '${"${"""<style>table, th, td {
                                          border: 1px solid black;
                                          border-collapse: collapse;
                                          margin-top:10px;
                                           padding: 5px;
                                        }</style><div style='display: flex'>${alphas[option.key]}"""}. <span style='margin-left: 2px'>${option.value['option']}"}</span></div>',
                                                      style: const TeXViewStyle(
                                                          padding:
                                                              TeXViewPadding
                                                                  .all(10))));
                                            }).toList(),
                                            selectedItemStyle: const TeXViewStyle(
                                                backgroundColor: PRIMARY_BLUE,
                                                margin: TeXViewMargin.only(
                                                    bottom: 10),
                                                borderRadius:
                                                    TeXViewBorderRadius.all(5),
                                                elevation: 3),
                                            normalItemStyle: TeXViewStyle(
                                                contentColor:
                                                    Provider.of<Auth>(context, listen: false).darkTheme
                                                        ? Colors.white
                                                        : PRIMARY_DARK,
                                                margin:
                                                    const TeXViewMargin.only(
                                                        bottom: 10),
                                                borderRadius:
                                                    const TeXViewBorderRadius.all(
                                                        5),
                                                border: const TeXViewBorder.all(
                                                    TeXViewBorderDecoration(borderWidth: 1, borderColor: PRIMARY_BLUE)),
                                                backgroundColor: Provider.of<Auth>(context, listen: false).darkTheme ? PRIMARY_DARK : PRIMARY_LIGHT,
                                                elevation: 3),
                                            onTap: (id) {
                                              int index = int.parse(id);
                                              onSelect(
                                                  index,
                                                  widget.question,
                                                  widget.options[index],
                                                  widget.options
                                                      .where((element) =>
                                                          element['isCorrect'])
                                                      .toList()[0]['option'],
                                                  richText: true,
                                                  hint: widget.hint,
                                                  hintImage: widget.hintImage);
                                            }))
                                  ]),
                                  loadingWidgetBuilder: (BuildContext context) {
                                    return const Center(
                                        child: SizedBox(
                                            height: 12,
                                            width: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            )));
                                  })
                              : Text(
                                  "${widget.index + 1}. ${widget.question}",
                                  style: style,
                                ),
                          !widget.richText && widget.image != null
                              ? const SizedBox(
                                  height: 10,
                                )
                              : Container(),
                          !widget.richText && widget.image != null
                              ? ImageViewComponent(image: widget.image!)
                              : Container(),
                        ],
                      )),
                  !widget.richText
                      ? Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.options.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Provider.of<Auth>(context,
                                                          listen: false)
                                                      .darkTheme
                                                  ? PRIMARY_GREY
                                                  : LIGHT_GREY,
                                              offset: const Offset(
                                                0.0,
                                                0.0,
                                              ),
                                              blurRadius: 5.0,
                                              spreadRadius: 0.0,
                                            ), //BoxShadow
                                            const BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ), //BoxShadow
                                          ],
                                          color: widget.selected ==
                                                  widget.options[index]
                                                      ['option']
                                              ? PRIMARY_BLUE
                                              : Provider.of<Auth>(context,
                                                          listen: false)
                                                      .darkTheme
                                                  ? PRIMARY_DARK
                                                  : PRIMARY_LIGHT,
                                          border: Border.all(
                                              color: PRIMARY_BLUE, width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: AbsorbPointer(
                                          child: Text(
                                        alphas[index] +
                                            ". " +
                                            widget.options[index]['option'],
                                        style: style.copyWith(fontSize: 16),
                                      )),
                                    ),
                                    onTap: () {
                                      onSelect(
                                          index,
                                          widget.question,
                                          widget.options[index],
                                          widget.options
                                              .where((element) =>
                                                  element['isCorrect'])
                                              .toList()[0]['option'],
                                          hint: widget.hint,
                                          hintImage: widget.hintImage);
                                    });
                              }))
                      : Container(),
                ],
              )),
    );
  }
}
