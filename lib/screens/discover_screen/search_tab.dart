import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class TabBarComponent extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> dataList;
  final TabController tabController;

  const TabBarComponent(
      {Key? key,
      required this.tabs,
      required this.dataList,
      required this.tabController})
      : super(key: key);

  @override
  State<TabBarComponent> createState() => _TabBarComponentState();
}

class _TabBarComponentState extends State<TabBarComponent> {
  List<Tab> tabs = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      tabs = widget.tabs.map((tab) => Tab(text: tab)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);

    TextStyle style = const TextStyle(fontSize: 10, letterSpacing: 0.8);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 25,
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: TabBar(
            isScrollable: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            indicator: BoxDecoration(
                border: Border.all(
                    color: currTheme.darkTheme
                        ? PRIMARY_BLUE
                        : PRIMARY_BLUE.shade100),
                borderRadius: BorderRadius.circular(
                  5.0,
                ),
                color:
                    currTheme.darkTheme ? PRIMARY_BLUE : PRIMARY_BLUE.shade100),
            labelColor: Colors.white,
            unselectedLabelColor:
                currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
            controller: widget.tabController,
            tabs: tabs,
            labelStyle: style,
            // indicatorColor: currTheme.darkTheme ? PRIMARY_DARK : Colors.white,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: widget.dataList,
          ),
        ),
      ],
    );
  }
}
