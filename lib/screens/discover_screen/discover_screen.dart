import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:prashna_app/models/course.dart';
import 'package:prashna_app/models/set.dart';
import 'package:prashna_app/models/setCategory.dart';
import 'package:prashna_app/screens/courses_screen/courses_screen.dart';
import 'package:prashna_app/screens/discover_screen/searchTab.dart';
import 'package:prashna_app/screens/login_screen/login_screen.dart';
import 'package:prashna_app/screens/profile_screen/profile_screen.dart';
import 'package:prashna_app/screens/set_screen/set_screen.dart';
import 'package:prashna_app/screens/subjects_screen/subjects_screen.dart';
import '../../constants.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import 'getCard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late List<Course> _allCourses;
  late List<SetCategory> _categories;
  late List<Set> _sets;
  late List<Course> _filteredCourses;
  late List<Set> _filteredSets;
  late List<SetCategory> _filteredCategories;
  static List<String> tabs = [COURSES, SUBJECTS, SETS];
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    loadCourses();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchController.dispose();
    super.dispose();
  }

  void loadCourses() async {
    Response response = await dio().get("/prashna-courses");
    List<Course> courses =
        response.data.map<Course>((course) => Course.fromJson(course)).toList();
    response = await dio().get("/prashna-subjects");
    List<SetCategory> categories = response.data
        .map<SetCategory>((category) => SetCategory.fromJson(category))
        .toList();
    response = await dio().get("/prashna-sets");
    List<Set> sets =
        response.data.map<Set>((set) => Set.fromJson(set)).toList();

    setState(() {
      _filteredCourses = courses;
      _categories = categories;
      _sets = sets;
      _allCourses = courses;
      _filteredCategories = categories;
      _filteredSets = sets;
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
                      _filteredCourses = _allCourses;
                      _filteredCategories = _categories;
                      _filteredSets = _sets;
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
            _filteredCourses = _allCourses;
            _filteredCategories = _categories;
            _filteredSets = _sets;
            _loading = false;
          });
        } else {
          Response response = await dio()
              .get("/prashna/search/courses/q=${text.trim().toLowerCase()}");
          final courses = response.data;
          response = await dio()
              .get("/prashna/set/categories/q=${text.trim().toLowerCase()}");
          final subjects = response.data;
          response =
              await dio().get("/prashna/sets/q=${text.trim().toLowerCase()}");
          final sets = response.data;

          setState(() {
            _filteredCourses =
                courses.map<Course>((data) => Course.fromJson(data)).toList();
            _filteredCategories = subjects
                .map<SetCategory>((data) => SetCategory.fromJson(data))
                .toList();
            _filteredSets =
                sets.map<Set>((data) => Set.fromJson(data)).toList();
            _loading = false;
          });
        }
      },
    );

    Widget getPage(String type) {
      List dataList = type == COURSES
          ? _filteredCourses
          : type == SUBJECTS
              ? _filteredCategories
              : type == SETS
                  ? _filteredSets
                  : [];

      return dataList.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 250),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No ${type.toLowerCase()} found!",
                      style: style.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: currTheme.darkTheme
                              ? Colors.white
                              : PRIMARY_DARK),
                    ),
                  ]))
          : Column(
              children: [
                ...List<int>.generate(
                        (dataList.length / 2).round(), (int index) => index * 2)
                    .map(
                  (i) => Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: (i + 2) <= dataList.length
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                ...dataList.sublist(i, i + 2).map((item) =>
                                    createCard(context, type, item,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                18))
                              ])
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                ...dataList.sublist(i, i + 1).map((item) =>
                                    createCard(context, type, item,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                18))
                              ]),
                  ),
                )
              ],
            );
    }

    List<Widget> getDataList() {
      List<Widget> list = [];
      for (var tab in tabs) {
        list.add(getPage(tab));
      }
      return list;
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
            child: Container(
          width: MediaQuery.of(context).size.width,
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
                height: 10,
              ),
              _loading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: PRIMARY_BLUE,
                      )),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: TabBarComponent(
                          tabs: tabs,
                          dataList: getDataList(),
                          tabController: _tabController),
                    )
            ],
          ),
        )));
  }
}
