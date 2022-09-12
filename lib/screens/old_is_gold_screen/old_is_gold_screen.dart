import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:flutter_tex/flutter_tex.dart';
import '../../components/customIcons.dart';
import '../../constants.dart';
import '../../models/old_is_gold.dart';
import '../../models/old_is_gold_question.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class OldIsGoldScreen extends StatefulWidget {
  const OldIsGoldScreen({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<OldIsGoldScreen> createState() => _OldIsGoldScreenState();
}

class _OldIsGoldScreenState extends State<OldIsGoldScreen>
    with SingleTickerProviderStateMixin {
  late OldIsGold? _oig;
  bool _loading = true;
  List<String> tabs = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    loadOIG();
  }

  void loadOIG() async {
    Response response = await dio().get("/oig/${widget.id}");

    setState(() {
      _oig = response.data == null || response.data.isEmpty
          ? null
          : OldIsGold.fromJson(response.data);

      if (_oig != null && _oig!.categories.isNotEmpty) {
        tabs = _oig!.categories.map((cat) => cat.title).toList();
        _tabController = TabController(length: tabs.length, vsync: this);
      } else {
        _tabController = TabController(length: 0, vsync: this);
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);

    TextStyle style = const TextStyle(
        fontSize: 26.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    TextStyle quesStyle = TextStyle(
        fontSize: 15,
        color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto');

    TeXViewWidget _teXViewWidget(String body) {
      return TeXViewColumn(children: [
        TeXViewDocument(body,
            style: TeXViewStyle(
                margin: const TeXViewMargin.only(bottom: 5),
                fontStyle: TeXViewFontStyle(
                    fontFamily: 'Roboto',
                    fontWeight: TeXViewFontWeight.bold,
                    fontSize: 15),
                contentColor:
                    Provider.of<Auth>(context, listen: false).darkTheme
                        ? Colors.white
                        : PRIMARY_DARK)),
      ]);
    }

    Widget _createDatasList(List<OldIsGoldQuestion> datas) {
      if (datas.isEmpty) {
        return Center(
          child: Text(
            "No questions in this category!",
            style: style.copyWith(
                color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
                fontSize: 16.0,
                fontWeight: FontWeight.normal),
          ),
        );
      }
      datas.sort((a, b) => a.index.compareTo(b.index));
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: TeXView(
            fonts: const [
              TeXViewFont(
                  fontFamily: 'roboto_italic', src: 'fonts/Roboto-Italic.ttf'),
            ],
            renderingEngine: const TeXViewRenderingEngine.mathjax(),
            child: TeXViewColumn(
                children: datas
                    .map((data) => TeXViewColumn(children: [
                          _teXViewWidget("""<style>table, th, td {
                                            border: 1px solid black;
                                            border-collapse: collapse;
                                            margin-top:10px;
                                             padding: 5px;
                                          }</style>
                                          <div style='display: flex; align-items:baseline'>
                                          ${(data.index + 1).toString()}. <div style='margin-left: 2px;flex: 1;'>
                                          ${data.question}</div></div>"""),
                          TeXViewDocument(
                              " [${data.year != null ? data.year! : ""}${data.questionNumber != null ? ("${data.year != null ? ", " : ""}Q.${data.questionNumber!}") : ""}${data.marks != null ? ((data.questionNumber != null ? ", " : "") + data.marks!.toString()) : ""}]",
                              style: TeXViewStyle(
                                textAlign: TeXViewTextAlign.right,
                                margin: const TeXViewMargin.only(bottom: 15),
                                contentColor: currTheme.darkTheme
                                    ? PRIMARY_BLUE.shade100
                                    : PRIMARY_BLUE,
                                fontStyle: TeXViewFontStyle(
                                    fontFamily: 'roboto_italic', fontSize: 10),
                              ))
                        ]))
                    .toList()),
            loadingWidgetBuilder: (BuildContext context) {
              return const Center(
                  child: SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )));
            }),
      );
    }

    Widget getPage(int index, String tab) {
      return _loading
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                  child: CircularProgressIndicator(
                color: PRIMARY_BLUE,
              )),
            )
          : _createDatasList(_oig!.categories[index].questions);
    }

    List<Widget> getDataList() {
      List<Widget> list = [];
      tabs.asMap().entries.forEach(
          (tab) => list.add(getPage(tab.key, tab.value.toUpperCase())));
      return list;
    }

    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: _loading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: PRIMARY_BLUE,
                        )),
                      )
                    : _oig == null
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height - 100,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Old is gold is not available for this subject!",
                                  style: style.copyWith(
                                      fontSize: 20,
                                      color: currTheme.darkTheme
                                          ? Colors.white
                                          : PRIMARY_GREY),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : NestedScrollView(
                            headerSliverBuilder: (BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [
                                SliverAppBar(
                                  pinned: false,
                                  primary: false,
                                  expandedHeight: 100,
                                  // expandedHeight: 200,
                                  actions: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 3, right: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          _oig!.instagram != null
                                              ? IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: Icon(
                                                    CustomIcons.instagram,
                                                    color: Colors
                                                        .pinkAccent.shade100,
                                                    size: 16,
                                                  ),
                                                  tooltip: 'Instagram group',
                                                  onPressed: () async {
                                                    if (!await launchUrl(
                                                        Uri.parse(_oig!
                                                            .instagram!))) {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                )
                                              : Container(),
                                          _oig!.facebook != null
                                              ? IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: Icon(
                                                    Icons.facebook,
                                                    color: Colors
                                                        .blueAccent.shade100,
                                                    size: 16,
                                                  ),
                                                  tooltip: 'Facebook group',
                                                  onPressed: () async {
                                                    if (!await launchUrl(
                                                        Uri.parse(
                                                            _oig!.facebook!))) {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                )
                                              : Container(),
                                          _oig!.whatsapp != null
                                              ? IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: const Icon(
                                                    Icons.whatsapp,
                                                    color:
                                                        Colors.lightGreenAccent,
                                                    size: 16,
                                                  ),
                                                  tooltip: 'Whatsapp group',
                                                  onPressed: () async {
                                                    if (!await launchUrl(
                                                        Uri.parse(
                                                            _oig!.facebook!))) {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                )
                                              : Container(),
                                          _oig!.twitter != null
                                              ? IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  icon: const Icon(
                                                    CustomIcons.twitter,
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    size: 16,
                                                  ),
                                                  tooltip: 'Twitter group',
                                                  onPressed: () async {
                                                    if (!await launchUrl(
                                                        Uri.parse(
                                                            _oig!.twitter!))) {
                                                      throw 'Could not launch';
                                                    }
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                  flexibleSpace: FlexibleSpaceBar(
                                      background: Container(
                                    color: PRIMARY_BLUE,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 5, top: 40),
                                          constraints: const BoxConstraints(
                                              maxHeight: 80),
                                          child: AutoSizeText(
                                            _oig!.title,
                                            style: style,
                                          ),
                                        ),
                                        // Container(
                                        //   margin: const EdgeInsets.symmetric(
                                        //     vertical: 10,
                                        //   ),
                                        //   constraints: const BoxConstraints(
                                        //       maxHeight: 80),
                                        //   child: SingleChildScrollView(
                                        //     child: AutoSizeText(
                                        //       _oig!.description,
                                        //       style: style.copyWith(
                                        //           fontSize: 14,
                                        //           fontWeight: FontWeight.normal,
                                        //           fontFamily: "Roboto"),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  )),
                                ),
                                // (_oig!.instagram == null &&
                                //         _oig!.facebook == null &&
                                //         _oig!.whatsapp == null &&
                                //         _oig!.twitter == null)
                                //     ? SliverToBoxAdapter(child: Container())
                                //     : SliverAppBar(
                                //         pinned: false,
                                //         expandedHeight: 90,
                                //         automaticallyImplyLeading: false,
                                //         backgroundColor: PRIMARY_BLUE,
                                //         flexibleSpace: FlexibleSpaceBar(
                                //             background: Container(
                                //           decoration: BoxDecoration(
                                //               color: currTheme.darkTheme
                                //                   ? PRIMARY_DARK
                                //                   : Colors.white,
                                //               borderRadius:
                                //                   BorderRadius.circular(5.0)),
                                //           margin: const EdgeInsets.symmetric(
                                //               horizontal: 70, vertical: 5),
                                //           padding: const EdgeInsets.symmetric(
                                //               vertical: 8, horizontal: 5),
                                //           child: Column(
                                //             children: [
                                //               Text(
                                //                 "Join our group: ",
                                //                 style: quesStyle.copyWith(
                                //                     fontFamily: "Montserrat",
                                //                     fontSize: 12.0),
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   _oig!.instagram != null
                                //                       ? IconButton(
                                //                           icon: const Icon(
                                //                             CustomIcons
                                //                                 .instagram,
                                //                             color: Colors.pink,
                                //                           ),
                                //                           tooltip:
                                //                               'Instagram group',
                                //                           onPressed: () async {
                                //                             if (!await launchUrl(
                                //                                 Uri.parse(_oig!
                                //                                     .instagram!))) {
                                //                               throw 'Could not launch';
                                //                             }
                                //                           },
                                //                         )
                                //                       : Container(),
                                //                   _oig!.facebook != null
                                //                       ? IconButton(
                                //                           icon: Icon(
                                //                               Icons.facebook,
                                //                               color: Colors
                                //                                   .blue[900]),
                                //                           tooltip:
                                //                               'Facebook group',
                                //                           onPressed: () async {
                                //                             if (!await launchUrl(
                                //                                 Uri.parse(_oig!
                                //                                     .facebook!))) {
                                //                               throw 'Could not launch';
                                //                             }
                                //                           },
                                //                         )
                                //                       : Container(),
                                //                   _oig!.facebook != null
                                //                       ? IconButton(
                                //                           icon: const Icon(
                                //                               Icons.whatsapp,
                                //                               color:
                                //                                   Colors.green),
                                //                           tooltip:
                                //                               'Whatsapp group',
                                //                           onPressed: () async {
                                //                             if (!await launchUrl(
                                //                                 Uri.parse(_oig!
                                //                                     .facebook!))) {
                                //                               throw 'Could not launch';
                                //                             }
                                //                           },
                                //                         )
                                //                       : Container(),
                                //                   _oig!.twitter != null
                                //                       ? IconButton(
                                //                           icon: const Icon(
                                //                               CustomIcons
                                //                                   .twitter,
                                //                               color:
                                //                                   Colors.blue),
                                //                           tooltip:
                                //                               'Twitter group',
                                //                           onPressed: () async {
                                //                             if (!await launchUrl(
                                //                                 Uri.parse(_oig!
                                //                                     .twitter!))) {
                                //                               throw 'Could not launch';
                                //                             }
                                //                           },
                                //                         )
                                //                       : Container(),
                                //                 ],
                                //               ),
                                //             ],
                                //           ),
                                //         ))),
                                SliverAppBar(
                                  pinned: true,
                                  automaticallyImplyLeading: false,
                                  backgroundColor: PRIMARY_BLUE,
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: TabBar(
                                      isScrollable:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.landscape
                                              ? false
                                              : tabs.length > 4,
                                      indicatorColor: currTheme.darkTheme
                                          ? PRIMARY_DARK
                                          : Colors.white,
                                      labelStyle: const TextStyle(
                                          fontSize: 13, color: PRIMARY_DARK),
                                      tabs: tabs
                                          .map((tab) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Text(tab)))
                                          .toList(),
                                      controller: _tabController,
                                    ),
                                  ),
                                )
                              ];
                            },
                            body: _oig!.categories.isNotEmpty
                                ? TabBarView(
                                    controller: _tabController,
                                    children: getDataList(),
                                  )
                                : Center(
                                    child: Text("No content available!",
                                        style: style.copyWith(
                                            color: currTheme.darkTheme
                                                ? Colors.white
                                                : PRIMARY_DARK,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal)),
                                  ),
                          ))));
  }
}
