import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import '../../constants.dart';
import '../../models/set.dart';
import '../../models/setCategory.dart';
import '../../screens/organization_screen/organization_screen.dart';
import '../../screens/set_screen/set_screen.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen(
      {Key? key,
      required this.id,
      this.sets = const [],
      this.title = "",
      this.isFollowedSets = false})
      : super(key: key);
  final int id;
  final List<Set?> sets;
  final String title;
  final bool isFollowedSets;
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final _searchController = TextEditingController();
  late SetCategory? _setCategory;
  List<Set?>? _sets = [];
  bool _loading = true;
  String? _title = "";

  @override
  void initState() {
    super.initState();
    loadSet();
  }

  void loadSet() async {
    if (widget.sets.isNotEmpty) {
      setState(() {
        _title = widget.title;
        _setCategory = widget.sets[0]!.category;
        _sets = widget.sets;
        _loading = false;
      });
    } else {
      Response response = await dio().get("/set/categories/${widget.id}");

      setState(() {
        _setCategory = SetCategory.fromJson(response.data);
        _title = _setCategory != null ? _setCategory!.title : null;
        _sets = _setCategory != null ? _setCategory!.sets! : null;
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

    Widget getSetCard(Set? set, int index) {
      return GestureDetector(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: "Set"),
                    builder: (context) => SetScreen(id: set!.id)),
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
                                      "${index + 1}. ${set!.title}",
                                      style: style.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: darkTheme
                                              ? Colors.white
                                              : PRIMARY_DARK),
                                    ),
                                  ),
                                  widget.isFollowedSets
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                              color:
                                                  PRIMARY_BLUE.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          margin:
                                              const EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            set.category != null
                                                ? set.category!.title
                                                : "Removed",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: PRIMARY_BLUE,
                                                fontWeight: FontWeight.bold),
                                          ))
                                      : const SizedBox(
                                          height: 20,
                                        ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _loading
                                      ? Container()
                                      : _setCategory != null
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
                                                          shape: BoxShape
                                                              .circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(set
                                                                          .publisher !=
                                                                      null
                                                                  ? set
                                                                      .publisher!
                                                                      .avatar
                                                                  : set
                                                                      .category!
                                                                      .publisher
                                                                      .avatar)))),
                                                ),
                                                Text(
                                                    set.publisher != null
                                                        ? set.publisher!.name
                                                        : set.category!
                                                            .publisher.name,
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
                        ),
                        set.image != null
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                child: Image.network(set.image!,
                                    height: 80, width: 60, fit: BoxFit.cover))
                            : Container()
                      ],
                    ),
                  ),
                ),
              )));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.isFollowedSets ? "Sets" : "Subject",
              style: style.copyWith(fontSize: 16)),
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
                                            widget.isFollowedSets
                                                ? "Followed Sets"
                                                : _title != null
                                                    ? _title!
                                                    : "",
                                            style: style.copyWith(fontSize: 20),
                                          ),
                                        ),
                                        widget.isFollowedSets ||
                                                _setCategory!.description ==
                                                    null
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
                                                    _setCategory!.description!,
                                                    style: style.copyWith(
                                                        fontFamily: "Roboto",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                        widget.isFollowedSets
                                            ? Container()
                                            : _setCategory != null
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Container(
                                                                        width:
                                                                            22.0,
                                                                        height:
                                                                            22.0,
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(_setCategory!.publisher.avatar)))),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              settings: const RouteSettings(name: "Organization"),
                                                                              builder: (context) => OrganizationScreen(id: _setCategory!.publisher.id)));
                                                                    },
                                                                    child: Text(
                                                                        _setCategory!
                                                                            .publisher
                                                                            .name,
                                                                        style: style.copyWith(
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white)),
                                                                  )
                                                                ],
                                                              ),
                                                        Text(
                                                          " | Code: ${_setCategory!.code}",
                                                          style: style.copyWith(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
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
                                      _setCategory != null && _sets!.isNotEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Text(
                                                "Sets",
                                                style: style.copyWith(
                                                    fontSize: 16,
                                                    color: darkTheme
                                                        ? LIGHT_GREY
                                                        : PRIMARY_GREY),
                                              ))
                                          : Container(),
                                      _setCategory != null && _sets!.length > 0
                                          ? Column(
                                              children: _sets!
                                                  .asMap()
                                                  .entries
                                                  .map((set) => getSetCard(
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
