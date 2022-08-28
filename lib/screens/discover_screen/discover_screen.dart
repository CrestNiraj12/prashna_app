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
  final _searchController = TextEditingController();
  List<Course> _allCourses = [];

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
      _allCourses = courses;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);
    final user = currTheme.user;
    TextStyle searchStyle = const TextStyle(
        fontSize: 16, color: PRIMARY_DARK, fontFamily: 'Montserrat');

    TextStyle style = const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    // Input field for search
    final TextField searchField = TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      obscureText: false,
      style: searchStyle.copyWith(
          color: Provider.of<Auth>(context, listen: false).darkTheme
              ? Colors.white
              : PRIMARY_DARK),
      decoration: InputDecoration(
          hintText: "Search",
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _courses = _allCourses;
                    });
                  },
                  icon: const Icon(Icons.clear)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          fillColor: Provider.of<Auth>(context, listen: true).darkTheme
              ? PRIMARY_DARK
              : Colors.white,
          filled: true,
          prefixIcon: const Icon(
            Icons.search,
            color: PRIMARY_BLUE,
            size: 18,
          ),
          focusColor: PRIMARY_BLUE,
          border: const OutlineInputBorder(borderSide: BorderSide.none)),
      onSubmitted: (String text) async {
        setState(() {
          _loading = true;
        });

        if (text.isEmpty) {
          setState(() {
            _courses = _allCourses;
            _loading = false;
          });
        } else {
          Response response =
              await dio().get("/search/courses/q=${text.trim().toLowerCase()}");
          setState(() {
            _courses = response.data
                .map<Course>((data) => Course.fromJson(data))
                .toList();
            _loading = false;
          });
        }
      },
    );

    Widget _createCard(course, {required double width, double height = 100.0}) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
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
              decoration: BoxDecoration(
                color: Provider.of<Auth>(context, listen: false).darkTheme
                    ? PRIMARY_DARK
                    : PRIMARY_BLUE,
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: const AssetImage("images/background.jpg"),
                ),
              ),
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
                                fontSize: 14.0,
                                letterSpacing: 0.3,
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ))),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leadingWidth: 75,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                        value: currTheme.darkTheme,
                        activeTrackColor: LIGHT_GREY,
                        activeColor: PRIMARY_GREY,
                        onChanged: (bool toggle) {
                          currTheme.darkTheme = toggle;
                        }),
                  ),
                ),
                Icon(
                  currTheme.darkTheme ? Icons.dark_mode : Icons.light_mode,
                  color: currTheme.darkTheme ? Colors.white : PRIMARY_BLUE,
                  size: 20,
                )
              ],
            ),
          ),
          title: SizedBox(
            width: 60,
            height: 46,
            child: Image.asset('images/ideas.png'),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: user == null
                          ? const LoginScreen()
                          : const ProfileScreen(),
                      type: PageTransitionType.fade)),
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: user != null
                    ? Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(user.avatar))))
                    : Icon(
                        Icons.account_circle,
                        size: 22,
                        color:
                            currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
                      ),
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Find courses",
                              style: searchStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: PRIMARY_BLUE)),
                          const SizedBox(
                            height: 10,
                          ),
                          searchField
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _loading
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height - 300,
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: PRIMARY_BLUE,
                          )),
                        )
                      : _courses.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height - 300,
                              child: Center(
                                child: Text(
                                  "No courses found!",
                                  style: style.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: currTheme.darkTheme
                                          ? Colors.white
                                          : PRIMARY_DARK),
                                ),
                              ))
                          : Column(
                              children: [
                                ...List<int>.generate(
                                    (_courses.length / 2).round(),
                                    (int index) => index * 2).map(
                                  (i) => Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: (i + 2) <= _courses.length
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                ..._courses
                                                    .sublist(i, i + 2)
                                                    .map((item) => _createCard(
                                                        item,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            18))
                                              ])
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                                ..._courses
                                                    .sublist(i, i + 1)
                                                    .map((item) => _createCard(
                                                        item,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            18))
                                              ]),
                                  ),
                                )
                              ],
                            )
                ],
              ),
            ),
          ),
        )));
  }
}
