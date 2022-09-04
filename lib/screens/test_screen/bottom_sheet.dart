import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class TestBottomSheet extends StatefulWidget {
  final int questionCount;
  // final Function goToPage;
  final List selectedByPage;
  final int currentPage;

  const TestBottomSheet({
    Key? key,
    required this.questionCount,
    // required this.goToPage,
    required this.selectedByPage,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<TestBottomSheet> createState() => _TestBottomSheetState();
}

class _TestBottomSheetState extends State<TestBottomSheet> {
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: false);
    TextStyle style = TextStyle(
        fontSize: 16,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    return Container(
        height: 200,
        color: currTheme.darkTheme ? PRIMARY_DARK : PRIMARY_LIGHT,
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List<int>.generate(widget.questionCount, (i) => i + 1)
              .map((i) => GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   widget.goToPage(i);
                      //   _currentPage = i - 1;
                      // });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: !_currentPage.isNaN
                              ? (_currentPage == (i - 1)
                                  ? PRIMARY_BLUE
                                  : (widget.selectedByPage[i - 1]["seen"] &&
                                          widget.selectedByPage[i - 1]
                                                  ["option"] !=
                                              null
                                      ? Colors.yellow[800]
                                      : (widget.selectedByPage[i - 1]["seen"] &&
                                              widget.selectedByPage[i - 1]
                                                      ["option"] ==
                                                  null
                                          ? Colors.red[400]
                                          : null)))
                              : null,
                          border: Border.all(color: PRIMARY_BLUE)),
                      child: Center(
                        child: Text(
                          i.toString(),
                          style: style.copyWith(
                              fontSize: 14,
                              color: currTheme.darkTheme ||
                                      widget.selectedByPage[i - 1]["seen"]
                                  ? Colors.white
                                  : PRIMARY_GREY),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ));
  }
}
