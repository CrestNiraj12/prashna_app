import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:prashna_app/components/loginHintTitle.dart';
import 'package:prashna_app/utilities/globals.dart';
import '../../constants.dart';
import '../../models/set.dart';
import '../../screens/subjects_screen/subjects_screen.dart';
import '../../screens/old_is_gold_screen/old_is_gold_screen.dart';
import '../../screens/organization_screen/organization_screen.dart';
import '../../screens/test_screen/test_start_screen.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SetScreen extends StatefulWidget {
  const SetScreen({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<SetScreen> createState() => _SetScreenState();
}

class _SetScreenState extends State<SetScreen> {
  final _searchController = TextEditingController();
  late Set _set;
  late List _quizzes;
  late List _oigs;
  //late Map _status;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadSet();
  }

  void loadSet() async {
    Response response = await dio().get("/sets/${widget.id}");

    setState(() {
      _set = Set.fromJson(response.data);
      _quizzes = response.data["quizzes"];
      _oigs = response.data["oigs"];
      _loading = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);
    final List<Set?> followedSets =
        currTheme.user != null ? currTheme.user!.followedSets : [];

    bool isEnrolled() => _loading == false && followedSets.isNotEmpty
        ? followedSets.map((s) => s!.id).contains(widget.id)
        : false;

    TextStyle style = const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    Widget _createDatasList(List datas, {String type = "QUIZ"}) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          itemCount: datas.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      settings: const RouteSettings(name: "Detail"),
                      child: type == "OIG"
                          ? OldIsGoldScreen(
                              id: datas[index]['id'],
                            )
                          : StartScreen(
                              quizId: datas[index]['id'],
                              setId: _set.id,
                            ),
                      type: PageTransitionType.rightToLeftWithFade)),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}. ${datas[index]['title']}",
                        style: style.copyWith(
                            color: currTheme.darkTheme
                                ? Colors.white
                                : PRIMARY_DARK,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _set.category != null
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                            width: 18.0,
                                            height: 18.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(_set
                                                        .category!
                                                        .publisher
                                                        .avatar)))),
                                      ),
                                      Text(_set.category!.publisher.name,
                                          style: style.copyWith(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: currTheme.darkTheme
                                                  ? Colors.white
                                                  : PRIMARY_DARK)),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Set", style: style.copyWith(fontSize: 16)),
          automaticallyImplyLeading: true,
          backgroundColor: PRIMARY_BLUE,
          elevation: 0,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
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
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Container(
                                  color: PRIMARY_BLUE,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: _set.image == null
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        40
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 80),
                                                      child: AutoSizeText(
                                                        _set.title,
                                                        style: style,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 50),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: AutoSizeText(
                                                          _set.description ==
                                                                  null
                                                              ? "No description available!"
                                                              : _set
                                                                  .description!,
                                                          style: style.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              _set.image != null
                                                  ? SizedBox(
                                                      height: 100,
                                                      child: InteractiveViewer(
                                                          boundaryMargin:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          minScale: 0.1,
                                                          maxScale: 2,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child:
                                                                Image.network(
                                                              _set.image!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          currTheme.user == null
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 25),
                                                  child: const LoginHintTitle())
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: const EdgeInsets.only(
                                                      top: 25),
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 40),
                                                  child: Row(
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            onFollowSet(
                                                                context,
                                                                isEnrolled(),
                                                                widget.id);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: isEnrolled()
                                                                ? PRIMARY_BLUE
                                                                    .withRed(
                                                                        150)
                                                                : PRIMARY_BLUE
                                                                    .withGreen(
                                                                        150),
                                                            elevation: 5,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            fixedSize: const Size
                                                                .fromRadius(70),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                isEnrolled()
                                                                    ? Icons
                                                                        .check
                                                                    : Icons.add,
                                                                size: 16,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                isEnrolled()
                                                                    ? "Enrolled"
                                                                    : "Enroll",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      _set.category != null
                                                          ? ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    PageTransition(
                                                                        child: SubjectsScreen(
                                                                            id: _set
                                                                                .category!.id),
                                                                        type: PageTransitionType
                                                                            .fade));
                                                              },
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                fixedSize:
                                                                    const Size
                                                                        .fromRadius(80),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Icon(
                                                                    Icons.link,
                                                                    size: 16,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Text(
                                                                    "Go to Subject",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            "Montserrat",
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ],
                                                              ))
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                        ],
                                      ),
                                      _set.category != null
                                          ? Container(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          50),
                                              margin: const EdgeInsets.only(
                                                  top: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Container(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: NetworkImage(_set.publisher !=
                                                                            null
                                                                        ? _set
                                                                            .publisher!
                                                                            .avatar
                                                                        : _set
                                                                            .category!
                                                                            .publisher
                                                                            .avatar)))),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    settings: const RouteSettings(
                                                                        name:
                                                                            "Organization"),
                                                                    builder: (context) => OrganizationScreen(
                                                                        id: _set
                                                                            .category!
                                                                            .publisher
                                                                            .id)));
                                                          },
                                                          child: Text(
                                                              "${_set.publisher != null ? _set.publisher!.name : _set.category!.publisher.name} | ",
                                                              style: style.copyWith(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white))),
                                                    ],
                                                  ),
                                                  Flexible(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_set.category !=
                                                            null) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  settings:
                                                                      const RouteSettings(
                                                                          name:
                                                                              "Category"),
                                                                  builder: (context) =>
                                                                      SubjectsScreen(
                                                                          id: _set
                                                                              .category!
                                                                              .id)));
                                                        }
                                                      },
                                                      child: Text(
                                                          _set.category == null
                                                              ? "No subject"
                                                              : _set.category!
                                                                  .title,
                                                          style: style.copyWith(
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _quizzes.isEmpty && _oigs.isEmpty
                                            ? Center(
                                                child: Text(
                                                    "No content available!",
                                                    style: style.copyWith(
                                                        color:
                                                            currTheme.darkTheme
                                                                ? Colors.white
                                                                : PRIMARY_DARK,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              )
                                            : Container(),
                                        _quizzes.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "Quizzes",
                                                  style: style.copyWith(
                                                      fontSize: 16,
                                                      color: currTheme.darkTheme
                                                          ? Colors.white
                                                          : PRIMARY_DARK),
                                                ),
                                              )
                                            : Container(),
                                        _quizzes.isNotEmpty
                                            ? _createDatasList(_quizzes)
                                            : Container(),
                                        _oigs.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "Old is Gold",
                                                  style: style.copyWith(
                                                      fontSize: 16,
                                                      color: currTheme.darkTheme
                                                          ? Colors.white
                                                          : PRIMARY_DARK),
                                                ),
                                              )
                                            : Container(),
                                        _oigs.isNotEmpty
                                            ? _createDatasList(_oigs,
                                                type: "OIG")
                                            : Container(),
                                      ]),
                                )
                              ])))));
  }
}
