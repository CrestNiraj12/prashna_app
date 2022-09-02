import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:like_button/like_button.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/models/course.dart';
import 'package:prashna_app/models/set.dart';
import 'package:prashna_app/models/setCategory.dart';
import 'package:prashna_app/screens/courses_screen/courses_screen.dart';
import 'package:prashna_app/screens/subjects_screen/subjects_screen.dart';
import 'package:prashna_app/screens/set_screen/set_screen.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:prashna_app/utilities/globals.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Carousel extends StatefulWidget {
  final String title;
  final int categoryId;
  final List<Set?> sets;
  final List<SetCategory> setCategories;
  final List<Course?> courses;
  final bool recommended;
  final bool isSet;
  final bool isCourse;

  const Carousel(
      {Key? key,
      required this.title,
      this.sets = const [],
      this.categoryId = 0,
      this.setCategories = const [],
      this.courses = const [],
      this.isSet = false,
      this.isCourse = false,
      this.recommended = false})
      : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List _datas = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _datas = widget.recommended
          ? widget.setCategories
          : widget.isCourse
              ? widget.courses
              : widget.sets;
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: 'Montserrat');

    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: style.copyWith(
                      fontSize: 16,
                      color: PRIMARY_BLUE,
                      fontWeight: FontWeight.bold),
                )),
                !widget.recommended && !widget.isCourse
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SubjectsScreen(
                                      id: widget.categoryId,
                                      title: widget.title,
                                      sets: widget.sets,
                                      isFollowedSets: widget.isSet),
                                  type: PageTransitionType.leftToRight));
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            textStyle: const TextStyle(
                                fontFamily: "Montserrat", fontSize: 13)),
                        child: const Text("View all"))
                    : Container(),
              ],
            ),
          ),
          widget.recommended || widget.isCourse
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
          SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    left: widget.sets.length == 1 || widget.courses.length == 1
                        ? 0
                        : MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? -40
                            : -80,
                    right: widget.sets.length == 1 || widget.courses.length == 1
                        ? 20
                        : 10,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider(
                          options: CarouselOptions(
                            height: 150,
                            enableInfiniteScroll: false,
                            viewportFraction: widget.sets.length == 1 ||
                                    widget.courses.length == 1
                                ? 1
                                : 0.8,
                          ),
                          items: _datas.asMap().entries.map((data) {
                            return GestureDetector(
                              onTap: () => widget.isCourse
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          settings: const RouteSettings(
                                              name: "Course"),
                                          builder: (context) =>
                                              CoursesScreen(id: data.value.id)))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          settings:
                                              const RouteSettings(name: "Set"),
                                          builder: (context) => widget
                                                  .recommended
                                              ? SubjectsScreen(
                                                  id: data.value.id)
                                              : SetScreen(id: data.value.id))),
                              child: Card(
                                elevation: 5,
                                color: Provider.of<Auth>(context, listen: false)
                                        .darkTheme
                                    ? PRIMARY_DARK
                                    : Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      (widget.sets.length == 1
                                                          ? 100
                                                          : MediaQuery.of(context)
                                                                      .orientation ==
                                                                  Orientation
                                                                      .portrait
                                                              ? 150
                                                              : 230),
                                                  child: Text(
                                                    "${data.key + 1}. ${data.value.title}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: style.copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Provider.of<
                                                                        Auth>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .darkTheme
                                                            ? Colors.white
                                                            : PRIMARY_DARK),
                                                  ),
                                                ),
                                              ),
                                              widget.recommended ||
                                                      widget.isCourse
                                                  ? Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: PRIMARY_BLUE
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12.0),
                                                      child: Text(
                                                        "${data.value.subjects == null ? "0" : data.value.subjects!.length.toString()} subjects",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: PRIMARY_BLUE,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                  : Container(),
                                              SizedBox(
                                                height: widget.recommended ||
                                                        widget.isCourse
                                                    ? 30
                                                    : 60,
                                              ),
                                              !widget.recommended &&
                                                      !widget.isCourse
                                                  ? Row(
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
                                                                  right: 8.0),
                                                          child: data.value
                                                                      .category !=
                                                                  null
                                                              ? Container(
                                                                  width: 22.0,
                                                                  height: 22.0,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image: NetworkImage(data
                                                                              .value
                                                                              .category
                                                                              .publisher
                                                                              .avatar))))
                                                              : null,
                                                        ),
                                                        Text(
                                                            data.value.category !=
                                                                    null
                                                                ? data
                                                                    .value
                                                                    .category
                                                                    .publisher
                                                                    .name
                                                                : "Removed",
                                                            style: style.copyWith(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Provider.of<Auth>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .darkTheme
                                                                    ? LIGHT_GREY
                                                                    : PRIMARY_GREY))
                                                      ],
                                                    )
                                                  : Text(
                                                      "Code: ${data.value.code}",
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
                                                              : PRIMARY_GREY)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      widget.recommended || widget.isCourse
                                          ? Positioned(
                                              top: 0,
                                              right: 0,
                                              child: LikeButton(
                                                  size: 22,
                                                  circleColor:
                                                      const CircleColor(
                                                          start:
                                                              Color(0xff00ddff),
                                                          end: Color(
                                                              0xff0099cc)),
                                                  bubblesColor:
                                                      const BubblesColor(
                                                    dotPrimaryColor:
                                                        Color(0xff33b5e5),
                                                    dotSecondaryColor:
                                                        Color(0xff0099cc),
                                                  ),
                                                  likeBuilder: (bool isLiked) {
                                                    return isLiked
                                                        ? const Icon(
                                                            Icons.close,
                                                            color: Colors.red)
                                                        : const Icon(Icons.add,
                                                            color: Colors.grey);
                                                  },
                                                  isLiked: widget.isCourse,
                                                  onTap: (isLiked) {
                                                    widget.isCourse
                                                        ? widget.courses
                                                            .removeAt(data.key)
                                                        : widget.setCategories
                                                            .removeAt(data.key);
                                                    return widget.isCourse
                                                        ? onFollowCourse(
                                                            context,
                                                            isLiked,
                                                            data.value.id)
                                                        : onFollow(
                                                            context,
                                                            isLiked,
                                                            data.value.id);
                                                  }))
                                          : Container(),
                                      !widget.recommended && !widget.isCourse
                                          ? data.value.image != null
                                              ? Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Image.network(
                                                      data.value.image,
                                                      height: 80,
                                                      width: 60,
                                                      fit: BoxFit.cover))
                                              : Container()
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList()),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
