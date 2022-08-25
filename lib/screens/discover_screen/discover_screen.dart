import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:prashna_app/models/course.dart';
import 'package:prashna_app/screens/courses_screen/courses_screen.dart';
import 'package:prashna_app/screens/login_screen/login_screen.dart';
import 'package:prashna_app/screens/profile_screen/profile_screen.dart';
import '../../constants.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late List _courses;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  void loadCourses() async {
    Response response = await dio().get("/prashna-courses");
    List<Course> courses =
        response.data.map<Course>((course) => Course.fromJson(course)).toList();

    setState(() {
      _courses = courses;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);
    final user = currTheme.user;

    Widget _createCard(course, {required double width, double height = 100.0}) {
      return Card(
        elevation: 0,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? PRIMARY_DARK
            : PRIMARY_BLUE,
        child: InkWell(
          splashColor: PRIMARY_BLUE.withAlpha(50),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    settings: const RouteSettings(name: "Course"),
                    child: CoursesScreen(id: course.id),
                    type: PageTransitionType.fade));
          },
          child: Container(
              width: width,
              height: height,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: width,
                          child: Text(
                            course.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ))
                    ],
                  ))),
        ),
      );
    }

    TextStyle style = const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Prashna (Old is Gold)",
              style: style.copyWith(fontSize: 16)),
          backgroundColor: PRIMARY_BLUE,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: user == null ? LoginScreen() : ProfileScreen(),
                      type: PageTransitionType.fade)),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: user != null
                    ? Container(
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(user.avatar))))
                    : const Icon(
                        Icons.account_circle,
                        size: 22,
                      ),
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: _loading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 100,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: PRIMARY_BLUE,
                    )),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      children: [
                        ...List<int>.generate((_courses.length / 2).round(),
                            (int index) => index * 2).map(
                          (i) => Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: (i + 2) <= _courses.length
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        ..._courses.sublist(i, i + 2).map(
                                            (item) => _createCard(item,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    18))
                                      ])
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        ..._courses.sublist(i, i + 1).map(
                                            (item) => _createCard(item,
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    18))
                                      ]),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        )));
  }
}
