import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import '../../constants.dart';
import '../../models/course.dart';
import '../../models/setCategory.dart';
import '../../screens/organization_screen/organization_screen.dart';
import '../../screens/subjects_screen/subjects_screen.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen(
      {Key? key, required this.id, this.subjects = const [], this.title = ""})
      : super(key: key);
  final int id;
  final List<SetCategory?> subjects;
  final String title;
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final _searchController = TextEditingController();
  late Course? _course;
  List<SetCategory?>? _subjects = [];
  bool _loading = true;
  String? _title = "";

  @override
  void initState() {
    super.initState();
    loadCourse();
  }

  void loadCourse() async {
    if (widget.subjects.isNotEmpty) {
      setState(() {
        _title = widget.title;
        _course = widget.subjects[0]!.course;
        _subjects = widget.subjects;
        _loading = false;
      });
    } else {
      Response response = await dio().get("/courses/${widget.id}");

      setState(() {
        _course = Course.fromJson(response.data);
        _title = _course != null ? _course!.title : null;
        _subjects = _course != null ? _course!.subjects! : null;
        _loading = false;
      });
    }
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
    final bool darkTheme = currTheme.darkTheme;

    TextStyle style = const TextStyle(
        fontSize: 16.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    Widget getSubjectCard(SetCategory? subject, int index) {
      return GestureDetector(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: "Subject"),
                    builder: (context) => SubjectsScreen(id: subject!.id)),
              ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: Card(
                  color: darkTheme ? PRIMARY_DARK : Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      "${index + 1}. ${subject!.title}",
                                      style: style.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: darkTheme
                                              ? Colors.white
                                              : PRIMARY_DARK),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  _loading
                                      ? Container()
                                      : _course != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Container(
                                                      width: 22.0,
                                                      height: 22.0,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  subject
                                                                      .publisher
                                                                      .avatar)))),
                                                ),
                                                Text(subject.publisher.name,
                                                    style: style.copyWith(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Provider.of<
                                                                        Auth>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .darkTheme
                                                            ? LIGHT_GREY
                                                            : PRIMARY_GREY))
                                              ],
                                            )
                                          : Container(),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Course", style: style.copyWith(fontSize: 16)),
          automaticallyImplyLeading: true,
          backgroundColor: PRIMARY_BLUE,
          elevation: 0,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
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
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin:
                                              const EdgeInsets.only(bottom: 15),
                                          constraints: const BoxConstraints(
                                              maxHeight: 60),
                                          child: AutoSizeText(
                                            _title != null ? _title! : "",
                                            style: style.copyWith(fontSize: 20),
                                          ),
                                        ),
                                        _course!.description == null
                                            ? Container()
                                            : Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 50),
                                                child: SingleChildScrollView(
                                                  child: AutoSizeText(
                                                    _course!.description!,
                                                    style: style.copyWith(
                                                        fontFamily: "Roboto",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                        _course != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16.0),
                                                child: Row(
                                                  children: [
                                                    _loading
                                                        ? Container()
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                child: Container(
                                                                    width: 22.0,
                                                                    height:
                                                                        22.0,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: DecorationImage(
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            image: NetworkImage(_course!.publisher.avatar)))),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          settings: const RouteSettings(
                                                                              name:
                                                                                  "Organization"),
                                                                          builder: (context) =>
                                                                              OrganizationScreen(id: _course!.publisher.id)));
                                                                },
                                                                child: Text(
                                                                    _course!
                                                                        .publisher
                                                                        .name,
                                                                    style: style.copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              )
                                                            ],
                                                          ),
                                                    Text(
                                                      " | Code: ${_course!.code}",
                                                      style: style.copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _course != null && _subjects!.length > 0
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Subjects",
                                                style: style.copyWith(
                                                    fontSize: 16,
                                                    color: darkTheme
                                                        ? LIGHT_GREY
                                                        : PRIMARY_GREY),
                                              ))
                                          : Container(),
                                      _course != null && _subjects!.isNotEmpty
                                          ? Column(
                                              children: _subjects!
                                                  .asMap()
                                                  .entries
                                                  .map((set) => getSubjectCard(
                                                      set.value, set.key))
                                                  .toList(),
                                            )
                                          : Center(
                                              child: Text(
                                                  "No content available!",
                                                  style: style.copyWith(
                                                      color: currTheme.darkTheme
                                                          ? Colors.white
                                                          : PRIMARY_DARK,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                            )
                                    ],
                                  ))
                            ],
                          )))));
  }
}
