import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';
import 'package:prashna_app/components/carousel.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/models/course.dart';
import 'package:prashna_app/models/set.dart';
import 'package:prashna_app/models/set_category.dart';
import 'package:prashna_app/screens/login_screen/login_screen.dart';
import 'package:prashna_app/screens/profile_screen/profile_screen.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class EnrolledScreen extends StatefulWidget {
  const EnrolledScreen({Key? key}) : super(key: key);
  @override
  State<EnrolledScreen> createState() => _EnrolledScreenState();
}

class _EnrolledScreenState extends State<EnrolledScreen> {
  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);
    final user = currTheme.user;
    List<SetCategory?> setCategories =
        user != null ? user.followedSetCategories : [];
    List<Set?> sets = user != null ? user.followedSets : [];
    List<Course?> courses = user != null ? user.followedCourses : [];

    TextStyle textStyle = TextStyle(
        fontSize: 13,
        color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto');

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
        body: user == null
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        child: Image.asset("images/locked.jpg"),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        "Please login to view your enrolled courses, subjects or sets!",
                        textAlign: TextAlign.center,
                        style: textStyle.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: PRIMARY_BLUE,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const LoginScreen(),
                                    type: PageTransitionType.fade));
                          },
                          child: Text(
                            "Sign in to your account",
                            style: textStyle.copyWith(
                                color: Colors.white, letterSpacing: 0.8),
                          ))
                    ],
                  ),
                ),
              )
            : setCategories.isEmpty && sets.isEmpty && courses.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 250,
                            child: Image.asset("images/empty.jpg"),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          Text(
                            "Your enrolled courses, subjects and sets will appear here!",
                            textAlign: TextAlign.center,
                            style: textStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                          padding: const EdgeInsets.only(
                              top: 10, right: 20.0, left: 20.0, bottom: 20.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                courses.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Carousel(
                                          title: "Enrolled Courses",
                                          courses: courses,
                                          isCourse: true,
                                        ),
                                      )
                                    : Container(),
                                sets.isNotEmpty
                                    ? Carousel(
                                        title: "Followed Sets",
                                        sets: sets,
                                        isSet: true,
                                      )
                                    : Container(),
                                setCategories.isNotEmpty
                                    ? Column(
                                        children: setCategories
                                            .asMap()
                                            .entries
                                            .map((cat) => Carousel(
                                                title: cat.value!.title,
                                                categoryId: cat.value!.id,
                                                sets: cat.value!.sets!))
                                            .toList())
                                    : Container(),
                              ])),
                    ]))));
  }
}
