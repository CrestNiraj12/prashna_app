import "package:flutter/material.dart";
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/screens/discover_screen/discover_screen.dart';
import 'package:prashna_app/screens/enrolled_screen/enrolled_screen.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  final String? token;
  const MainScreen({Key? key, this.token}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final autoSizeGroup = AutoSizeGroup();
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DiscoverScreen(),
    EnrolledScreen(),
  ];

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _checkInternetConnection() async {
    try {
      await InternetAddress.lookup('studypill.org');
    } catch (_) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("No internet connection!"),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ));
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: AbsorbPointer(
        absorbing: Provider.of<Auth>(context, listen: false).absorbing,
        child: Opacity(
          opacity:
              Provider.of<Auth>(context, listen: false).absorbing ? 0.5 : 1,
          child: Scaffold(
              body: _pages.elementAt(_selectedIndex),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: PRIMARY_DARK,
                iconSize: 20,
                selectedItemColor: PRIMARY_BLUE,
                unselectedItemColor: LIGHT_GREY,
                unselectedFontSize: 10,
                selectedFontSize: 12,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.download), label: "Enrolled")
                ],
                currentIndex: _selectedIndex, //New
                onTap: _onItemTapped,
              )),
        ),
      ),
    );
  }
}
