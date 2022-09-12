import 'package:flutter/material.dart';
import 'package:prashna_app/components/imageView.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class FinalLearnScreen extends StatefulWidget {
  final List questions;
  final int setId;

  const FinalLearnScreen({
    Key? key,
    required this.setId,
    required this.questions,
  }) : super(key: key);

  @override
  State<FinalLearnScreen> createState() => _FinalLearnScreenState();
}

class _FinalLearnScreenState extends State<FinalLearnScreen> {
  @override
  void initState() {
    super.initState();
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
                                                  color: Colors.greenAccent,
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
