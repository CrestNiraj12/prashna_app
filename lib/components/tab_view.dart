import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class TabBarViewComponent extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> dataList;
  final TabController tabController;

  const TabBarViewComponent(
      {Key? key,
      required this.tabs,
      required this.dataList,
      required this.tabController})
      : super(key: key);

  @override
  State<TabBarViewComponent> createState() => _TabBarViewComponentState();
}

class _TabBarViewComponentState extends State<TabBarViewComponent> {
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
      children: [
        Container(
          color: PRIMARY_BLUE,
          child: TabBar(
            isScrollable: false,
            controller: widget.tabController,
            tabs: tabs,
            labelStyle: style,
            indicatorColor: currTheme.darkTheme ? PRIMARY_DARK : Colors.white,
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
