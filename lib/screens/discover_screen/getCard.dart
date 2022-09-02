import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/screens/courses_screen/courses_screen.dart';
import 'package:prashna_app/screens/discover_screen/discover_screen.dart';
import 'package:prashna_app/screens/set_screen/set_screen.dart';
import 'package:prashna_app/screens/subjects_screen/subjects_screen.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

TextStyle style = const TextStyle(
    fontSize: 24.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat');

Widget createCard(context, String type, data,
    {required double width, double height = 100.0}) {
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
                child: type == COURSES
                    ? CoursesScreen(id: data.id)
                    : type == SUBJECTS
                        ? SubjectsScreen(id: data.id)
                        : type == SETS
                            ? SetScreen(id: data.id)
                            : const DiscoverScreen(),
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
              image: (type == SETS && data.image != null)
                  ? NetworkImage(data.image)
                  : const AssetImage("images/background.jpg") as ImageProvider,
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
                        data.title,
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
